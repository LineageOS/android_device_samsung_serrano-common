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

package com.android.internal.telephony;

import static com.android.internal.telephony.RILConstants.*;

import android.content.Context;
import android.telephony.Rlog;
import android.os.AsyncResult;
import android.os.Message;
import android.os.Parcel;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.telephony.ModemActivityInfo;
import android.telephony.PhoneNumberUtils;
import android.telephony.SignalStrength;
import com.android.internal.telephony.cdma.CdmaInformationRecords;
import com.android.internal.telephony.cdma.CdmaInformationRecords.CdmaSignalInfoRec;
import com.android.internal.telephony.cdma.SignalToneUtil;
import com.android.internal.telephony.gsm.SmsBroadcastConfigInfo;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.IccUtils;
import java.util.ArrayList;
import java.util.Collections;

/**
 * RIL customization for Galaxy S4 Mini (GSM/CDMA) devices
 *
 * {@hide}
 */
public class SerranoRIL extends RIL {

    private static final int RIL_REQUEST_DIAL_EMERGENCY = 10016;
    private static final int RIL_UNSOL_RESPONSE_IMS_NETWORK_STATE_CHANGED = 1036;
    private static final int RIL_UNSOL_DEVICE_READY_NOTI = 11008;
    private static final int RIL_UNSOL_AM = 11010;
    private static final int RIL_UNSOL_WB_AMR_STATE = 11017;
    private static final int RIL_UNSOL_RESPONSE_HANDOVER = 11021;
    private static final int RIL_UNSOL_ON_SS_SAMSUNG = 1040;
    private static final int RIL_UNSOL_STK_CC_ALPHA_NOTIFY_SAMSUNG = 1041;
    private static final int RIL_UNSOL_UICC_SUBSCRIPTION_STATUS_CHANGED_SAMSUNG = 11031;

    private Object mSMSLock = new Object();
    private boolean mIsSendingSMS = false;
    public static final long SEND_SMS_TIMEOUT_IN_MS = 30000;
    protected boolean isGSM = false;

    public SerranoRIL(Context context, int preferredNetworkType, int cdmaSubscription) {
        this(context, preferredNetworkType, cdmaSubscription, null);
    }

    public SerranoRIL(Context context, int preferredNetworkType,
            int cdmaSubscription, Integer instanceId) {
        super(context, preferredNetworkType, cdmaSubscription, instanceId);
    }

    @Override
    public void
    dial(String address, int clirMode, UUSInfo uusInfo, Message result) {
        if (PhoneNumberUtils.isEmergencyNumber(address)) {
            dialEmergencyCall(address, clirMode, result);
            return;
        }

        RILRequest rr = RILRequest.obtain(RIL_REQUEST_DIAL, result);

        rr.mParcel.writeString(address);
        rr.mParcel.writeInt(clirMode);
        rr.mParcel.writeInt(0);     // CallDetails.call_type
        rr.mParcel.writeInt(1);     // CallDetails.call_domain
        rr.mParcel.writeString(""); // CallDetails.getCsvFromExtras

        if (uusInfo == null) {
            rr.mParcel.writeInt(0); // UUS information is absent
        } else {
            rr.mParcel.writeInt(1); // UUS information is present
            rr.mParcel.writeInt(uusInfo.getType());
            rr.mParcel.writeInt(uusInfo.getDcs());
            rr.mParcel.writeByteArray(uusInfo.getUserData());
        }

        if (RILJ_LOGD) riljLog(rr.serialString() + "> " + requestToString(rr.mRequest));

        send(rr);
    }

    @Override
    protected Object
    responseIccCardStatus(Parcel p) {
        IccCardApplicationStatus appStatus;

        IccCardStatus cardStatus = new IccCardStatus();
        cardStatus.setCardState(p.readInt());
        cardStatus.setUniversalPinState(p.readInt());
        cardStatus.mGsmUmtsSubscriptionAppIndex = p.readInt();
        cardStatus.mCdmaSubscriptionAppIndex = p.readInt();
        cardStatus.mImsSubscriptionAppIndex = p.readInt();

        int numApplications = p.readInt();

        // limit to maximum allowed applications
        if (numApplications > IccCardStatus.CARD_MAX_APPS) {
            numApplications = IccCardStatus.CARD_MAX_APPS;
        }
        cardStatus.mApplications = new IccCardApplicationStatus[numApplications];

        for (int i = 0 ; i < numApplications ; i++) {
            appStatus = new IccCardApplicationStatus();
            appStatus.app_type       = appStatus.AppTypeFromRILInt(p.readInt());
            appStatus.app_state      = appStatus.AppStateFromRILInt(p.readInt());
            appStatus.perso_substate = appStatus.PersoSubstateFromRILInt(p.readInt());
            appStatus.aid            = p.readString();
            appStatus.app_label      = p.readString();
            appStatus.pin1_replaced  = p.readInt();
            appStatus.pin1           = appStatus.PinStateFromRILInt(p.readInt());
            appStatus.pin2           = appStatus.PinStateFromRILInt(p.readInt());
            p.readInt(); // pin1_num_retries
            p.readInt(); // puk1_num_retries
            p.readInt(); // pin2_num_retries
            p.readInt(); // puk2_num_retries
            p.readInt(); // perso_unblock_retries

            cardStatus.mApplications[i] = appStatus;
        }
        return cardStatus;
    }

    @Override
    public void
    sendCdmaSms(byte[] pdu, Message result) {
        smsLock();
        super.sendCdmaSms(pdu, result);
    }

    @Override
    public void
        sendSMS (String smscPDU, String pdu, Message result) {
        smsLock();
        super.sendSMS(smscPDU, pdu, result);
    }

    @Override
    protected Object
    responseSMS(Parcel p) {
        // Notify that sendSMS() can send the next SMS
        synchronized (mSMSLock) {
            mIsSendingSMS = false;
            mSMSLock.notify();
        }

        return super.responseSMS(p);
    }

    private void smsLock(){
        // Do not send a new SMS until the response for the previous SMS has been received
        //   * for the error case where the response never comes back, time out after
        //     30 seconds and just try the next SEND_SMS
        synchronized (mSMSLock) {
            long timeoutTime  = SystemClock.elapsedRealtime() + SEND_SMS_TIMEOUT_IN_MS;
            long waitTimeLeft = SEND_SMS_TIMEOUT_IN_MS;
            while (mIsSendingSMS && (waitTimeLeft > 0)) {
                Rlog.d(RILJ_LOG_TAG, "sendSMS() waiting for response of previous SEND_SMS");
                try {
                    mSMSLock.wait(waitTimeLeft);
                } catch (InterruptedException ex) {
                    // ignore the interrupt and rewait for the remainder
                }
                waitTimeLeft = timeoutTime - SystemClock.elapsedRealtime();
            }
            if (waitTimeLeft <= 0) {
                Rlog.e(RILJ_LOG_TAG, "sendSms() timed out waiting for response of previous CDMA_SEND_SMS");
            }
            mIsSendingSMS = true;
        }
    }

    @Override
    protected Object
    responseCallList(Parcel p) {
        int num;
        ArrayList<DriverCall> response;
        DriverCall dc;

        num = p.readInt();
        response = new ArrayList<DriverCall>(num);

        if (RILJ_LOGV) {
            riljLog("responseCallList: num=" + num +
                    " mEmergencyCallbackModeRegistrant=" + mEmergencyCallbackModeRegistrant +
                    " mTestingEmergencyCall=" + mTestingEmergencyCall.get());
        }
        for (int i = 0 ; i < num ; i++) {
            dc = new DriverCall();

            dc.state = DriverCall.stateFromCLCC(p.readInt());
            dc.index = p.readInt() & 0xff;
            dc.TOA = p.readInt();
            dc.isMpty = (0 != p.readInt());
            dc.isMT = (0 != p.readInt());
            dc.als = p.readInt();
            dc.isVoice = (0 != p.readInt());
            if (isGSM) {
                boolean isVideo = (0 != p.readInt());   // Samsung CallDetails
                int call_type = p.readInt();            // Samsung CallDetails
                int call_domain = p.readInt();          // Samsung CallDetails
                String csv = p.readString();            // Samsung CallDetails
            }
            dc.isVoicePrivacy = (0 != p.readInt());
            dc.number = p.readString();
            int np = p.readInt();
            dc.numberPresentation = DriverCall.presentationFromCLIP(np);
            dc.name = p.readString();
            dc.namePresentation = p.readInt();
            int uusInfoPresent = p.readInt();
            if (uusInfoPresent == 1) {
                dc.uusInfo = new UUSInfo();
                dc.uusInfo.setType(p.readInt());
                dc.uusInfo.setDcs(p.readInt());
                byte[] userData = p.createByteArray();
                dc.uusInfo.setUserData(userData);
                riljLogv(String.format("Incoming UUS : type=%d, dcs=%d, length=%d",
                                dc.uusInfo.getType(), dc.uusInfo.getDcs(),
                                dc.uusInfo.getUserData().length));
                riljLogv("Incoming UUS : data (string)="
                        + new String(dc.uusInfo.getUserData()));
                riljLogv("Incoming UUS : data (hex): "
                        + IccUtils.bytesToHexString(dc.uusInfo.getUserData()));
            } else {
                riljLogv("Incoming UUS : NOT present!");
            }

            // Make sure there's a leading + on addresses with a TOA of 145
            dc.number = PhoneNumberUtils.stringFromStringAndTOA(dc.number, dc.TOA);

            response.add(dc);

            if (dc.isVoicePrivacy) {
                mVoicePrivacyOnRegistrants.notifyRegistrants();
                riljLog("InCall VoicePrivacy is enabled");
            } else {
                mVoicePrivacyOffRegistrants.notifyRegistrants();
                riljLog("InCall VoicePrivacy is disabled");
            }
        }

        Collections.sort(response);

        if ((num == 0) && mTestingEmergencyCall.getAndSet(false)) {
            if (mEmergencyCallbackModeRegistrant != null) {
                riljLog("responseCallList: call ended, testing emergency call," +
                            " notify ECM Registrants");
                mEmergencyCallbackModeRegistrant.notifyRegistrant();
            }
        }

        return response;
    }

    @Override
    protected Object responseSignalStrength(Parcel p) {
        int numInts = 12;
        int response[];

        // Get raw data
        response = new int[numInts];
        for (int i = 0; i < numInts; i++) {
            response[i] = p.readInt();
        }

        //gsm
        response[0] &= 0xff;

        //cdma
        response[2] %= 256;
        response[4] %= 256;
        response[7] &= 0xff;

        return new SignalStrength(response[0], response[1], response[2], response[3], response[4], response[5], response[6], response[7], response[8], response[9], response[10], response[11], true);
    }

    @Override
    public void setPhoneType(int phoneType){
        super.setPhoneType(phoneType);
        isGSM = (phoneType != RILConstants.CDMA_PHONE);
    }

    @Override
    protected RILRequest
    processSolicited (Parcel p, int type) {
        int serial, error;
        int dataPosition = p.dataPosition(); // save off position within the Parcel

        serial = p.readInt();
        error = p.readInt();

        RILRequest rr;

        rr = mRequestList.get(serial);
        if (rr == null || error != 0 || p.dataAvail() <= 0) {
            p.setDataPosition(dataPosition);
            return super.processSolicited(p, type);
        }

        try { switch (rr.mRequest) {
            case RIL_REQUEST_OPERATOR:
                String operators[] = (String [])responseStrings(p);

                riljLog("Operator response");

                if (operators == null || operators.length < 0) {
                    riljLog("Operators is empty or null");
                } else {
                    riljLog("Length of operators:" + operators.length);
                    for (int i = 0; i < operators.length; i++) {
                        riljLog("Operator[" + i + "]:" + operators[i]);
                    }
                }

                if (!isGSM) {
                    riljLog("Forcing operator name using build property ro.cdma.home.operator.alpha");
                    operators[0] = SystemProperties.get("ro.cdma.home.operator.alpha");
                }

                if (RILJ_LOGD) riljLog(rr.serialString() + "< " + requestToString(rr.mRequest)
                                       + " " + retToString(rr.mRequest, operators));

                if (rr.mResult != null) {
                    AsyncResult.forMessage(rr.mResult, operators, null);
                    rr.mResult.sendToTarget();
                }
                mRequestList.remove(serial);
                break;
            case RIL_REQUEST_VOICE_REGISTRATION_STATE:
                String voiceRegStates[] = (String [])responseStrings(p);

                riljLog("VoiceRegistrationState response");

                if (voiceRegStates == null || voiceRegStates.length < 0) {
                    riljLog("VoiceRegStates is empty or null");
                } else {
                    riljLog("Length of voiceRegStates:" + voiceRegStates.length);
                    for (int i = 0; i < voiceRegStates.length; i++) {
                        riljLog("VoiceRegStates[" + i + "]:" + voiceRegStates[i]);
                    }
                }

                if (RILJ_LOGD) riljLog(rr.serialString() + "< " + requestToString(rr.mRequest)
                                       + " " + retToString(rr.mRequest, voiceRegStates));

                if (rr.mResult != null) {
                    AsyncResult.forMessage(rr.mResult, voiceRegStates, null);
                    rr.mResult.sendToTarget();
                }
                mRequestList.remove(serial);
                break;
            case RIL_REQUEST_DATA_REGISTRATION_STATE:
                String dataRegStates[] = (String [])responseStrings(p);

                riljLog("DataRegistrationState response");

                if (dataRegStates == null || dataRegStates.length < 0) {
                   riljLog("DataRegStates is empty or null");
                } else {
                   riljLog("Length of dataRegStates:" + dataRegStates.length);
                   for (int i = 0; i < dataRegStates.length; i++) {
                      riljLog("DataRegStates[" + i + "]:" + dataRegStates[i]);
                   }
                }

                if (RILJ_LOGD) riljLog(rr.serialString() + "< " + requestToString(rr.mRequest)
                                       + " " + retToString(rr.mRequest, dataRegStates));

                if (rr.mResult != null) {
                    AsyncResult.forMessage(rr.mResult, dataRegStates, null);
                    rr.mResult.sendToTarget();
                }
                mRequestList.remove(serial);
                break;
            default:
                p.setDataPosition(dataPosition);
                return super.processSolicited(p, type);
        }} catch (Throwable tr) {
                // Exceptions here usually mean invalid RIL responses

                Rlog.w(RILJ_LOG_TAG, rr.serialString() + "< "
                        + requestToString(rr.mRequest)
                        + " exception, possible invalid RIL response", tr);

                if (rr.mResult != null) {
                    AsyncResult.forMessage(rr.mResult, null, tr);
                    rr.mResult.sendToTarget();
                }
                return rr;
        }

        return rr;
    }

    private void
    fixNitz(Parcel p) {
        int dataPosition = p.dataPosition();
        String nitz = p.readString();
        long nitzReceiveTime = p.readLong();

        String[] nitzParts = nitz.split(",");
        if (nitzParts.length >= 4) {
            // 0=date, 1=time+zone, 2=dst, 3(+)=garbage that confuses ServiceStateTracker
            nitz = nitzParts[0] + "," + nitzParts[1] + "," + nitzParts[2];
            p.setDataPosition(dataPosition);
            p.writeString(nitz);
            p.writeLong(nitzReceiveTime);
            // The string is shorter now, drop the extra bytes
            p.setDataSize(p.dataPosition());
        }
    }

    @Override
    protected void
    processUnsolicited (Parcel p, int type) {
        Object ret;
        int dataPosition = p.dataPosition(); // save off position within the Parcel
        int response = p.readInt();

        switch(response) {
            case RIL_UNSOL_RIL_CONNECTED:
                ret = responseInts(p);
                setRadioPower(false, null);
                setPreferredNetworkType(mPreferredNetworkType, null);
                setCdmaSubscriptionSource(mCdmaSubscription, null);
                if(mRilVersion >= 8)
                    setCellInfoListRate(Integer.MAX_VALUE, null);
                notifyRegistrantsRilConnectionChanged(((int[])ret)[0]);
                break;
            case RIL_UNSOL_NITZ_TIME_RECEIVED:
                fixNitz(p);
                p.setDataPosition(dataPosition);
                super.processUnsolicited(p, type);
                break;
            case RIL_UNSOL_RESPONSE_IMS_NETWORK_STATE_CHANGED:
                ret = responseVoid(p);
                break;
            case RIL_UNSOL_DEVICE_READY_NOTI:
                ret = responseVoid(p);
                break;
            case RIL_UNSOL_AM:
                ret = responseString(p);
                break;
            case RIL_UNSOL_WB_AMR_STATE:
                ret = responseInts(p);
                break;
            case RIL_UNSOL_RESPONSE_HANDOVER:
                ret = responseVoid(p);
                break;
            case RIL_UNSOL_ON_SS_SAMSUNG:
                p.setDataPosition(dataPosition);
                p.writeInt(RIL_UNSOL_ON_SS);
                break;
            case RIL_UNSOL_STK_CC_ALPHA_NOTIFY_SAMSUNG:
                p.setDataPosition(dataPosition);
                p.writeInt(RIL_UNSOL_STK_CC_ALPHA_NOTIFY);
                break;
            case RIL_UNSOL_UICC_SUBSCRIPTION_STATUS_CHANGED_SAMSUNG:
                p.setDataPosition(dataPosition);
                p.writeInt(RIL_UNSOL_UICC_SUBSCRIPTION_STATUS_CHANGED);
                break;
            default:
                // Rewind the Parcel
                p.setDataPosition(dataPosition);

                // Forward responses that we are not overriding to the super class
                super.processUnsolicited(p, type);
                return;
        }
    }

    @Override
    protected void notifyRegistrantsCdmaInfoRec(CdmaInformationRecords infoRec) {
        final int response = RIL_UNSOL_CDMA_INFO_REC;

        if (infoRec.record instanceof CdmaSignalInfoRec) {
            CdmaSignalInfoRec sir = (CdmaSignalInfoRec) infoRec.record;
            if (sir != null
                    && sir.isPresent
                    && sir.signalType == SignalToneUtil.IS95_CONST_IR_SIGNAL_IS54B
                    && sir.alertPitch == SignalToneUtil.IS95_CONST_IR_ALERT_MED
                    && sir.signal == SignalToneUtil.IS95_CONST_IR_SIG_IS54B_L) {

                Rlog.d(RILJ_LOG_TAG, "Dropping \"" + responseToString(response) + " "
                        + retToString(response, sir)
                        + "\" to prevent \"ring of death\" bug.");
                return;
            }
        }

        super.notifyRegistrantsCdmaInfoRec(infoRec);
    }

    private void
    dialEmergencyCall(String address, int clirMode, Message result) {
        RILRequest rr;

        rr = RILRequest.obtain(RIL_REQUEST_DIAL_EMERGENCY, result);
        rr.mParcel.writeString(address);
        rr.mParcel.writeInt(clirMode);
        rr.mParcel.writeInt(0);        // CallDetails.call_type
        rr.mParcel.writeInt(3);        // CallDetails.call_domain
        rr.mParcel.writeString("");    // CallDetails.getCsvFromExtra
        rr.mParcel.writeInt(0);        // Unknown

        if (RILJ_LOGD) riljLog(rr.serialString() + "> " + requestToString(rr.mRequest));

        send(rr);
    }

    @Override
    public void getRadioCapability(Message response) {
        riljLog("getRadioCapability: returning static radio capability");
        if (response != null) {
            Object ret = makeStaticRadioCapability();
            AsyncResult.forMessage(response, ret, null);
            response.sendToTarget();
        }
    }

    protected Object
    responseFailCause(Parcel p) {
        int numInts;
        int response[];

        numInts = p.readInt();
        response = new int[numInts];
        for (int i = 0 ; i < numInts ; i++) {
            response[i] = p.readInt();
        }
        LastCallFailCause failCause = new LastCallFailCause();
        failCause.causeCode = response[0];
        if (p.dataAvail() > 0) {
          failCause.vendorCause = p.readString();
        }
        return failCause;
    }

    // This call causes ril to crash the socket, stopping further communication
    @Override
    public void
    getHardwareConfig (Message result) {
        riljLog("getHardwareConfig: not supported");
        if (result != null) {
            CommandException ex = new CommandException(
                CommandException.Error.REQUEST_NOT_SUPPORTED);
            AsyncResult.forMessage(result, null, ex);
            result.sendToTarget();
        }
    }

    @Override
    public void setDataAllowed(boolean allowed, Message result) {
        if (SystemProperties.get("persist.radio.multisim.config").equals("dsds")) {
            int req = 123;
            RILRequest rr;
            if (allowed) {
                req = 116;
                rr = RILRequest.obtain(req, result);
            } else {
                rr = RILRequest.obtain(req, result);
                rr.mParcel.writeInt(1);
                rr.mParcel.writeInt(allowed ? 1 : 0);
            }

            send(rr);
        }
    }

    @Override
    public void startLceService(int reportIntervalMs, boolean pullMode, Message response) {
        riljLog("startLceService: not supported");
        if (response != null) {
            CommandException ex = new CommandException(
                CommandException.Error.REQUEST_NOT_SUPPORTED);
            AsyncResult.forMessage(response, null, ex);
            response.sendToTarget();
        }
    }

    /**
    * @hide
    */
    public void getModemActivityInfo(Message response) {
        riljLog("getModemActivityInfo: not supported");
        if (response != null) {
            CommandException ex = new CommandException(
                CommandException.Error.REQUEST_NOT_SUPPORTED);
            AsyncResult.forMessage(response, null, ex);
            response.sendToTarget();
        }
    }

    @Override
    public void setUiccSubscription(int appIndex, boolean activate, Message result) {
        // Note: This RIL request is also valid for SIM and RUIM (ICC card)
        RILRequest rr = RILRequest.obtain(115, result);

        if (RILJ_LOGD) riljLog(rr.serialString() + "> " + requestToString(rr.mRequest)
                + " appIndex: " + appIndex + " activate: " + activate);

        rr.mParcel.writeInt(mInstanceId);
        rr.mParcel.writeInt(appIndex);
        rr.mParcel.writeInt(mInstanceId);
        rr.mParcel.writeInt(activate ? 1 : 0);

        send(rr);
    }
}
