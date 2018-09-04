/*
 * Copyright (C) 2013-2016, The CyanogenMod Project
 * Copyright (C) 2017, The LineageOS Project
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

#include <hardware/power.h>

/* Video encode hint optimisations */
#define VID_ENC_TIMER_RATE 30000
#define VID_ENC_IO_IS_BUSY 0

enum {
    PROFILE_POWER_SAVE = 0,
    PROFILE_BALANCED,
    PROFILE_HIGH_PERFORMANCE,
    PROFILE_BIAS_POWER,
    PROFILE_MAX
};

typedef struct governor_settings {
    int is_interactive;
    int boost;
    int boostpulse_duration;
    int go_hispeed_load;
    int go_hispeed_load_off;
    int hispeed_freq;
    int hispeed_freq_off;
    int timer_rate;
    int timer_rate_off;
    char* above_hispeed_delay;
    int io_is_busy;
    int min_sample_time;
    int max_freq_hysteresis;
    char* target_loads;
    char* target_loads_off;
    int limited_min_freq;
    int limited_max_freq;
} power_profile;

static power_profile profiles[PROFILE_MAX] = {
        [PROFILE_POWER_SAVE] =
            {
                .boost = 0,
                .boostpulse_duration = 40000,
                .go_hispeed_load = 90,
                .go_hispeed_load_off = 110,
                .hispeed_freq = 702000,
                .hispeed_freq_off = 702000,
                .timer_rate = 20000,
                .timer_rate_off = 50000,
                .above_hispeed_delay = "19000 1400000:39000",
                .io_is_busy = 1,
                .min_sample_time = 39000,
                .max_freq_hysteresis = 99000,
                .target_loads = "85 1700000:90",
                .target_loads_off = "95 1728000:99",
                .limited_min_freq = 384000,
                .limited_max_freq = 1026000,
            },
        [PROFILE_BALANCED] =
            {
                .boost = 0,
                .boostpulse_duration = 40000,
                .go_hispeed_load = 90,
                .go_hispeed_load_off = 110,
                .hispeed_freq = 918000,
                .hispeed_freq_off = 918000,
                .timer_rate = 20000,
                .timer_rate_off = 50000,
                .above_hispeed_delay = "19000 1400000:39000",
                .io_is_busy = 1,
                .min_sample_time = 39000,
                .max_freq_hysteresis = 99000,
                .target_loads = "85 1700000:90",
                .target_loads_off = "95 1728000:99",
                .limited_min_freq = 384000,
                .limited_max_freq = 1728000,
            },
        [PROFILE_HIGH_PERFORMANCE] =
            {
                .boost = 1,
                .boostpulse_duration = 40000,
                .go_hispeed_load = 50,
                .go_hispeed_load_off = 110,
                .hispeed_freq = 1134000,
                .hispeed_freq_off = 1134000,
                .timer_rate = 20000,
                .timer_rate_off = 50000,
                .above_hispeed_delay = "19000 1400000:39000",
                .io_is_busy = 1,
                .min_sample_time = 39000,
                .max_freq_hysteresis = 99000,
                .target_loads = "80 1700000:90",
                .target_loads_off = "90 1728000:99",
                .limited_min_freq = 384000,
                .limited_max_freq = 1728000,
            },
        [PROFILE_BIAS_POWER] =
            {
                .boost = 0,
                .boostpulse_duration = 40000,
                .go_hispeed_load = 90,
                .go_hispeed_load_off = 110,
                .hispeed_freq = 702000,
                .hispeed_freq_off = 702000,
                .timer_rate = 20000,
                .timer_rate_off = 50000,
                .above_hispeed_delay = "19000 1400000:39000",
                .io_is_busy = 1,
                .min_sample_time = 39000,
                .max_freq_hysteresis = 99000,
                .target_loads = "85 1700000:90",
                .target_loads_off = "95 1728000:99",
                .limited_min_freq = 384000,
                .limited_max_freq = 1242000,
            },
};

// Custom Lineage hints
const static power_hint_t POWER_HINT_SET_PROFILE = (power_hint_t)0x00000111;
