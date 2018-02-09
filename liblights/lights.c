/*
 * Copyright (C) 2010 Diogo Ferreira <diogo@underdev.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "lights"

#include <cutils/log.h>

#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>

#include <sys/ioctl.h>
#include <sys/types.h>

#include <hardware/lights.h>

static pthread_once_t g_init = PTHREAD_ONCE_INIT;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;
static struct light_state_t g_notification;
static struct light_state_t g_battery;
static int g_backlight = 255;

char const*const GREEN_LED_FILE
        = "/sys/class/leds/green/brightness";

char const*const AMBER_LED_FILE
        = "/sys/class/leds/amber/brightness";

char const*const BLUE_LED_FILE
        = "/sys/class/leds/blue/brightness";

char const*const BUTTON_FILE
        = "/sys/class/leds/button-backlight/brightness";

char const*const AMBER_BLINK_FILE
        = "/sys/class/leds/amber/blink";

char const*const GREEN_BLINK_FILE
        = "/sys/class/leds/green/blink";

char const*const BLUE_BLINK_FILE
        = "/sys/class/leds/blue/blink";

char const*const LCD_BACKLIGHT_FILE
        = "/sys/class/leds/lcd-backlight/brightness";

enum {
    LED_BLUE,
    LED_AMBER,
    LED_GREEN,
    LED_BLANK,
};

/**
 * Aux method, write int to file
 */
static int write_int(const char* path, int value)
{
    char buffer[20];
    int fd, bytes, written;
    static int already_warned = 0;

    fd = open(path, O_RDWR);
    if (fd < 0) {
        if (already_warned == 0) {
            ALOGE("write_int failed to open %s\n", path);
            already_warned = 1;
        }
        return -errno;
    }

    bytes = snprintf(buffer, sizeof(buffer), "%d\n",value);
    written = write(fd, buffer, bytes);
    close(fd);

    return written == -1 ? -errno : 0;
}

void init_globals(void)
{
    pthread_mutex_init(&g_lock, NULL);
}

static int is_lit(struct light_state_t const* state)
{
    return state->color & 0x00ffffff;
}

static void reset_speaker_light_locked(void)
{
    write_int(GREEN_LED_FILE, 0);
    write_int(GREEN_BLINK_FILE, 0);
    write_int(AMBER_LED_FILE, 0);
    write_int(AMBER_BLINK_FILE, 0);
    write_int(BLUE_LED_FILE, 0);
    write_int(BLUE_BLINK_FILE, 0);
}

static void set_speaker_light_locked(struct light_device_t *dev,
        struct light_state_t *state)
{
    unsigned int color = LED_BLANK;

    reset_speaker_light_locked();

    if ((state->color >> 8) & 0xFF)
        color = LED_GREEN;
    if ((state->color >> 16) & 0xFF)
        color = LED_AMBER;
    if (state->color & 0xFF)
        color = LED_BLUE;

    switch (state->flashMode) {
    case LIGHT_FLASH_TIMED:
        switch (color) {
        case LED_BLUE:
            write_int(BLUE_BLINK_FILE, 4);
            break;
        case LED_AMBER:
            write_int(AMBER_BLINK_FILE, 4);
            break;
        case LED_GREEN:
            write_int(GREEN_BLINK_FILE, 1);
            break;
        case LED_BLANK:
            break;
        default:
            ALOGE("set_led_state color=%08X, unknown color\n", state->color);
            break;
        }
        break;
    case LIGHT_FLASH_NONE:
        switch (color) {
        case LED_BLUE:
            write_int(BLUE_LED_FILE, 1);
            break;
        case LED_AMBER:
            write_int(AMBER_LED_FILE, 1);
            break;
        case LED_GREEN:
            write_int(GREEN_LED_FILE, 1);
            break;
        case LED_BLANK:
            break;
        }
        break;
    default:
        ALOGE("set_led_state color=%08X, unknown mode %d\n", state->color,
                state->flashMode);
    }
}

static void set_speaker_light_locked_dual(struct light_device_t *dev,
        struct light_state_t *bstate, struct light_state_t *nstate)
{
    if (bstate->color & 0xFFFF00) {
        reset_speaker_light_locked();
        write_int(GREEN_LED_FILE, 1);
        if (bstate->color & 0xFF0000)
            write_int(AMBER_BLINK_FILE, 4);
        else
            write_int(AMBER_BLINK_FILE, 1);
    } else
        ALOGE("set_led_state (dual) unexpected color: %08x\n", bstate->color);
}

static void handle_speaker_battery_locked(struct light_device_t *dev)
{
    if (is_lit(&g_battery) && is_lit(&g_notification))
        set_speaker_light_locked_dual(dev, &g_battery, &g_notification);
    else if (is_lit(&g_battery))
        set_speaker_light_locked(dev, &g_battery);
    else
        set_speaker_light_locked(dev, &g_notification);
}

static int set_light_buttons(struct light_device_t* dev,
        struct light_state_t const* state)
{
    int err = 0;
    int on = is_lit(state);
    pthread_mutex_lock(&g_lock);
    err = write_int(BUTTON_FILE, on ? 255 : 0);
    pthread_mutex_unlock(&g_lock);

    return 0;
}

static int rgb_to_brightness(struct light_state_t const* state)
{
    int color = state->color & 0x00ffffff;
    return ((77*((color>>16)&0x00ff))
            + (150*((color>>8)&0x00ff)) + (29*(color&0x00ff))) >> 8;
}

static int set_light_backlight(struct light_device_t* dev,
        struct light_state_t const* state)
{
    int err = 0;
    int brightness = rgb_to_brightness(state);
    ALOGV("%s brightness=%d color=0x%08x", __func__, brightness, state->color);
    pthread_mutex_lock(&g_lock);
    g_backlight = brightness;
    err = write_int(LCD_BACKLIGHT_FILE, brightness);
    pthread_mutex_unlock(&g_lock);
    return err;
}

static int set_light_battery(struct light_device_t* dev,
        struct light_state_t const* state)
{
    pthread_mutex_lock(&g_lock);
    g_battery = *state;
    handle_speaker_battery_locked(dev);
    pthread_mutex_unlock(&g_lock);

    return 0;
}

/* bravo has no attention, bad bravo */
static int set_light_attention(struct light_device_t* dev,
        struct light_state_t const* state)
{
    return 0;
}

static int set_light_notifications(struct light_device_t* dev,
        struct light_state_t const* state)
{
    pthread_mutex_lock(&g_lock);
    g_notification = *state;
    handle_speaker_battery_locked(dev);
    pthread_mutex_unlock(&g_lock);
    return 0;
}


static int close_lights(struct light_device_t *dev)
{
    if (dev)
        free(dev);
    return 0;
}


static int open_lights(const struct hw_module_t* module, char const* name,
        struct hw_device_t** device)
{
    struct light_device_t *dev;
    int (*set_light)(struct light_device_t* dev,
            struct light_state_t const* state);

    if (0 == strcmp(LIGHT_ID_BACKLIGHT, name))
        set_light = set_light_backlight;
    else if (0 == strcmp(LIGHT_ID_BUTTONS, name))
        set_light = set_light_buttons;
    else if (0 == strcmp(LIGHT_ID_BATTERY, name))
        set_light = set_light_battery;
    else if (0 == strcmp(LIGHT_ID_ATTENTION, name))
        set_light = set_light_attention;
    else if (0 == strcmp(LIGHT_ID_NOTIFICATIONS, name))
        set_light = set_light_notifications;
    else
        return -EINVAL;

    pthread_once(&g_init, init_globals);
    dev = malloc(sizeof(struct light_device_t));
    memset(dev, 0, sizeof(*dev));

    dev->common.tag = HARDWARE_DEVICE_TAG;
    dev->common.version = 0;
    dev->common.module = (struct hw_module_t*)module;
    dev->common.close = (int (*)(struct hw_device_t*))close_lights;
    dev->set_light = set_light;

    *device = (struct hw_device_t*)dev;
    return 0;
}

static struct hw_module_methods_t lights_module_methods = {
    .open = open_lights,
};

struct hw_module_t HAL_MODULE_INFO_SYM = {
    .tag = HARDWARE_MODULE_TAG,
    .version_major = 1,
    .version_minor = 0,
    .id = LIGHTS_HARDWARE_MODULE_ID,
    .name = "Qualcomm lights module",
    .author = "Diogo Ferreira <diogo@underdev.org>",
    .methods = &lights_module_methods,
};
