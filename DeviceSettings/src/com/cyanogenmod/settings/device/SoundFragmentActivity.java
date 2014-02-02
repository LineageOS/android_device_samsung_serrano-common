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

import android.app.ActivityManagerNative;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.SystemProperties;
import android.os.UserHandle;
import android.preference.CheckBoxPreference;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.PreferenceFragment;
import android.preference.PreferenceManager;
import android.preference.PreferenceScreen;
import android.util.Log;

public class SoundFragmentActivity extends PreferenceFragment {
    private static final String CATEGORY_VOLUME   = "volume";
    private static final String KEY_VOC_EP_XGAIN  = "voc_ep_xgain";
    private static final String PROP_VOC_EP_XGAIN = "persist.audio.voc_ep.xgain";
    private static final String TAG = "S4MiniSettings_General";

    private CheckBoxPreference mVocEpXgain;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.sound_preferences);

        PreferenceCategory pc = (PreferenceCategory) findPreference(CATEGORY_VOLUME);
        mVocEpXgain           = (CheckBoxPreference) findPreference(KEY_VOC_EP_XGAIN);
        if (getResources().getBoolean(R.bool.config_hasVocEpXgain)) {
            mVocEpXgain.setChecked(SystemProperties.get(PROP_VOC_EP_XGAIN).equals("1"));
        } else {
            pc.removePreference(mVocEpXgain);
        }

        if (pc.getPreferenceCount() == 0) {
           getPreferenceScreen().removePreference(pc);
        }
    }

    @Override
    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {
        String boxValue;
        String key = preference.getKey();
        Log.w(TAG, "key: " + key);
        if (preference == mVocEpXgain) {
            SystemProperties.set(PROP_VOC_EP_XGAIN, mVocEpXgain.isChecked() ? "1" : "0");
        } else if (key.compareTo(DeviceSettings.KEY_USE_DOCK_AUDIO) == 0) {
            boxValue = (((CheckBoxPreference)preference).isChecked() ? "1" : "0");
            Intent i = new Intent("com.cyanogenmod.settings.SamsungDock");
            i.putExtra("data", boxValue);
            ActivityManagerNative.broadcastStickyIntent(i, null, UserHandle.USER_ALL);
        } else {
            return super.onPreferenceTreeClick(preferenceScreen, preference);
        }
        return true;
    }

    public static void restore(Context context) {
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);
        boolean dockAudio = sharedPrefs.getBoolean(DeviceSettings.KEY_USE_DOCK_AUDIO, false);
        Intent i = new Intent("com.cyanogenmod.settings.SamsungDock");
        i.putExtra("data", (dockAudio? "1" : "0"));
        ActivityManagerNative.broadcastStickyIntent(i, null, UserHandle.USER_ALL);
    }
}
