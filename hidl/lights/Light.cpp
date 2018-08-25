/*
 * Copyright (C) 2017 The LineageOS Project
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

#define LOG_TAG "light"

#include "Light.h"

#include <log/log.h>

namespace {
using android::hardware::light::V2_0::LightState;

static uint32_t rgbToBrightness(const LightState& state) {
    uint32_t color = state.color & 0x00ffffff;
    return ((77 * ((color >> 16) & 0xff)) + (150 * ((color >> 8) & 0xff)) +
            (29 * (color & 0xff))) >> 8;
}

static bool isLit(const LightState& state) {
    return (state.color & 0x00ffffff);
}
} // anonymous namespace

namespace android {
namespace hardware {
namespace light {
namespace V2_0 {
namespace implementation {

Light::Light(std::ofstream&& backlight, std::ofstream&& buttonlight, std::ofstream&& indicator) :
    mBacklight(std::move(backlight)),
    mButtonlight(std::move(buttonlight)),
    mIndicator(std::move(indicator)) {
    auto attnFn(std::bind(&Light::setAttentionLight, this, std::placeholders::_1));
    auto backlightFn(std::bind(&Light::setBacklight, this, std::placeholders::_1));
    auto batteryFn(std::bind(&Light::setBatteryLight, this, std::placeholders::_1));
    auto buttonFn(std::bind(&Light::setButtonLight, this, std::placeholders::_1));
    auto notifFn(std::bind(&Light::setNotificationLight, this, std::placeholders::_1));
    mLights.emplace(std::make_pair(Type::ATTENTION, attnFn));
    mLights.emplace(std::make_pair(Type::BACKLIGHT, backlightFn));
    mLights.emplace(std::make_pair(Type::BATTERY, batteryFn));
    mLights.emplace(std::make_pair(Type::BUTTONS, buttonFn));
    mLights.emplace(std::make_pair(Type::NOTIFICATIONS, notifFn));
}

// Methods from ::android::hardware::light::V2_0::ILight follow.
Return<Status> Light::setLight(Type type, const LightState& state) {
    if (mLights.find(type) != mLights.end()) {
        mLights.at(type)(state);
        return Status::SUCCESS;
    }
    return Status::LIGHT_NOT_SUPPORTED;
}

Return<void> Light::getSupportedTypes(getSupportedTypes_cb _hidl_cb) {
    Type *types = new Type[mLights.size()];
    int idx = 0;

    for (auto const &kv : mLights) {
        Type t = kv.first;
        types[idx++] = t;
    }

    {
        hidl_vec<Type> hidl_types{};
        hidl_types.setToExternal(types, mLights.size());

        _hidl_cb(hidl_types);
    }

    delete[] types;

    return Void();
}

void Light::setAttentionLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mAttentionState = state;
    setSpeakerBatteryLightLocked();
}

void Light::setBacklight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);

    uint32_t brightness = rgbToBrightness(state);

    mBacklight << brightness << std::endl;
}

void Light::setBatteryLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mBatteryState = state;
    setSpeakerBatteryLightLocked();
}

void Light::setButtonLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mButtonlight << (state.color & 0xff) << std::endl;
}

void Light::setNotificationLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mNotificationState = state;
    setSpeakerBatteryLightLocked();
}

void Light::setSpeakerBatteryLightLocked() {
    if (isLit(mNotificationState)) {
        setSpeakerLightLocked(mNotificationState);
    } else if (isLit(mAttentionState)) {
        setSpeakerLightLocked(mAttentionState);
    } else if (isLit(mBatteryState)) {
        setSpeakerLightLocked(mBatteryState);
    } else {
        /* Lights off */
        ALOGD("%s: Lights off", __func__);
        mIndicator << "0x00000000 0 0" << std::endl;
    }
}

void Light::setSpeakerLightLocked(const LightState& state) {
    uint32_t color;

    color = state.color & 0x00ffffff;

    ALOGD("%s: inColor=0x%08x delay_on=%d, delay_off=%d", __func__, color,
          state.flashOnMs, state.flashOffMs);

    char blink[32];
    int count;

    count = snprintf(blink, sizeof(blink) - 1, "0x%08x %d %d", color, state.flashOnMs, state.flashOffMs);

    ALOGD("%s: count=%d, blink=\"%s\".", __func__, count, blink);

    mIndicator << blink << std::endl;
}

}  // namespace implementation
}  // namespace V2_0
}  // namespace light
}  // namespace hardware
}  // namespace android
