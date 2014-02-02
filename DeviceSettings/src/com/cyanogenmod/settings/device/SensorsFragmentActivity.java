/*
 * Copyright (C) 2012 The CyanogenMod Project
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

package com.cyanogenmod.settings.device;

import java.io.File;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.CheckBoxPreference;
import android.preference.Preference;
import android.preference.PreferenceCategory;
import android.preference.PreferenceFragment;
import android.preference.PreferenceManager;
import android.preference.PreferenceScreen;
import android.util.Log;

public class SensorsFragmentActivity extends PreferenceFragment {

    private static final String TAG = "S4MiniSettings_General";

    private static final String FILE_TOUCHKEY_TOGGLE = "/sys/class/leds/button-backlight/max_brightness";

    private static final boolean sHasTouchkeyToggle = Utils.fileExists(FILE_TOUCHKEY_TOGGLE);

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        addPreferencesFromResource(R.xml.sensors_preferences);

        PreferenceCategory prefs = (PreferenceCategory) findPreference(DeviceSettings.CATEGORY_TOUCHKEY);
        if (!sHasTouchkeyToggle) {
            prefs.removePreference(findPreference(DeviceSettings.KEY_TOUCHKEY_LIGHT));
        }
        if (prefs.getPreferenceCount() == 0) {
            getPreferenceScreen().removePreference(prefs);
        }
    }

    @Override
    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {

        String boxValue;
        String key = preference.getKey();

        Log.w(TAG, "key: " + key);

        if (key.compareTo(DeviceSettings.KEY_TOUCHKEY_LIGHT) == 0) {
            Utils.writeValue(FILE_TOUCHKEY_TOGGLE, ((CheckBoxPreference)preference).isChecked() ? "255" : "0");
        }

        return true;
    }

    public static void restore(Context context) {
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);

        if (sHasTouchkeyToggle) {
            Utils.writeValue(FILE_TOUCHKEY_TOGGLE, sharedPrefs.getBoolean(DeviceSettings.KEY_TOUCHKEY_LIGHT, true) ? "255" : "0");
        }
    }
}
