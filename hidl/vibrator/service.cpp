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

#define LOG_TAG "android.hardware.vibrator@1.0-service.serrano"

#include <android/hardware/vibrator/1.0/IVibrator.h>
#include <hidl/HidlSupport.h>
#include <hidl/HidlTransportSupport.h>
#include <hwbinder/ProcessState.h>
#include <utils/StrongPointer.h>

#include "Vibrator.h"

using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;
using android::hardware::vibrator::V1_0::IVibrator;
using android::hardware::vibrator::V1_0::implementation::Vibrator;
using android::status_t;
using namespace android;

static const char *ENABLE_PATH = "/sys/class/timed_output/vibrator/enable";

int main() {
    android::hardware::ProcessState::initWithMmapSize((size_t)8192);
    std::ofstream enable{ENABLE_PATH};
    if (!enable) {
        int error = errno;
        ALOGE("Failed to open %s (%d): %s", ENABLE_PATH, error, strerror(error));
        return -error;
    }

    sp<IVibrator> vibrator = new Vibrator(std::move(enable));

    configureRpcThreadpool(1, true);

    status_t status = vibrator->registerAsService();

    if (status != OK) {
        return 1;
    }

    ALOGI("Vibrator HAL Ready.");
    joinRpcThreadpool();
    // Under normal cases, execution will not reach this line.
    ALOGE("Vibrator HAL failed to join thread pool.");
    return 1;
}
