/* //device/libs/telephony/ril_commands.h
**
** Copyright 2006, The Android Open Source Project
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
**     http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
*/
    {SAMSUNG_REQUEST_BASE, NULL, NULL}, // 10000
    {10001, dispatchVoid, responseVoid}, // 10001
    {RIL_REQUEST_GET_CELL_BROADCAST_CONFIG, dispatchVoid, responseVoid}, // 10002
    {10003, dispatchVoid, responseVoid}, // 10003
    {10004, dispatchVoid, responseVoid}, // 10004
    {RIL_REQUEST_SEND_ENCODED_USSD, dispatchVoid, responseVoid}, // 10005
    {RIL_REQUEST_SET_PDA_MEMORY_STATUS, dispatchVoid, responseVoid}, // 10006
    {RIL_REQUEST_GET_PHONEBOOK_STORAGE_INFO, dispatchVoid, responseVoid}, // 10007
    {RIL_REQUEST_GET_PHONEBOOK_ENTRY, dispatchVoid, responseVoid}, // 10008
    {RIL_REQUEST_ACCESS_PHONEBOOK_ENTRY, dispatchVoid, responseVoid}, // 10009
    {RIL_REQUEST_DIAL_VIDEO_CALL, dispatchVoid, responseVoid}, // 10010
    {RIL_REQUEST_CALL_DEFLECTION, dispatchVoid, responseVoid}, // 10011
    {10012, dispatchVoid, responseVoid}, // 10012
    {RIL_REQUEST_USIM_PB_CAPA, dispatchVoid, responseVoid}, // 10013
    {RIL_REQUEST_LOCK_INFO, dispatchVoid, responseVoid}, // 10014
    {10015, dispatchVoid, responseVoid}, // 10015
    {RIL_REQUEST_DIAL_EMERGENCY_CALL, dispatchDial, responseVoid}, // 10016
    {10017, dispatchVoid, responseVoid}, // 10017
    {RIL_REQUEST_STK_SIM_INIT_EVENT, dispatchVoid, responseVoid}, // 10018
    {RIL_REQUEST_GET_LINE_ID, dispatchVoid, responseVoid}, // 10019
    {RIL_REQUEST_SET_LINE_ID, dispatchVoid, responseVoid}, // 10020
    {RIL_REQUEST_GET_SERIAL_NUMBER, dispatchVoid, responseVoid}, // 10021
    {RIL_REQUEST_GET_MANUFACTURE_DATE_NUMBER, dispatchVoid, responseVoid}, // 10022
    {RIL_REQUEST_GET_BARCODE_NUMBER, dispatchVoid, responseVoid}, // 10023
    {RIL_REQUEST_UICC_GBA_AUTHENTICATE_BOOTSTRAP, dispatchVoid, responseVoid}, // 10024
    {RIL_REQUEST_UICC_GBA_AUTHENTICATE_NAF, dispatchVoid, responseVoid}, // 10025
    {10026, dispatchVoid, responseVoid}, // 10026
    {10027, dispatchVoid, responseVoid}, // 10027
    {10028, dispatchVoid, responseVoid}, // 10028
    {10029, dispatchVoid, responseVoid}, // 10029
    {10030, dispatchVoid, responseVoid}, // 10030
    {RIL_REQUEST_MODIFY_CALL_INITIATE, dispatchVoid, responseVoid}, // 10031
    {RIL_REQUEST_MODIFY_CALL_CONFIRM, dispatchVoid, responseVoid}, // 10032
    {RIL_REQUEST_SAFE_MODE, dispatchVoid, responseVoid}, // 10033
    {RIL_REQUEST_SET_VOICE_DOMAIN_PREF, dispatchVoid, responseVoid}, // 10034
    {RIL_REQUEST_PS_ATTACH, dispatchVoid, responseVoid}, // 10035
    {RIL_REQUEST_PS_DETACH, dispatchVoid, responseVoid}, // 10036
    {RIL_REQUEST_ACTIVATE_DATA_CALL, dispatchVoid, responseVoid}, // 10037
    {RIL_REQUEST_CHANGE_SIM_PERSO, dispatchVoid, responseVoid}, // 10038
    {RIL_REQUEST_ENTER_SIM_PERSO, dispatchVoid, responseVoid}, // 10039
    {RIL_REQUEST_GET_TIME_INFO, dispatchVoid, responseVoid}, // 10040
    {RIL_REQUEST_RIL_REQUEST_CDMA_SEND_SMS_EXPECT_MORE, dispatchVoid, responseVoid}, // 10041
    {RIL_REQUEST_OMADM_SETUP_SESSION, dispatchVoid, responseVoid}, // 10042
    {RIL_REQUEST_OMADM_SERVER_START_SESSION, dispatchVoid, responseVoid}, // 10043
    {RIL_REQUEST_OMADM_CLIENT_START_SESSION, dispatchVoid, responseVoid}, // 10044
    {RIL_REQUEST_OMADM_SEND_DATA, dispatchVoid, responseVoid}, // 10045
    {RIL_REQUEST_CDMA_GET_DATAPROFILE, dispatchVoid, responseVoid}, // 10046
    {RIL_REQUEST_CDMA_SET_DATAPROFILE, dispatchVoid, responseVoid}, // 10047
    {RIL_REQUEST_CDMA_GET_SYSTEMPROPERTIES, dispatchVoid, responseVoid}, // 10048
    {RIL_REQUEST_CDMA_SET_SYSTEMPROPERTIES, dispatchVoid, responseVoid}, // 10049
    {RIL_REQUEST_SEND_SMS_COUNT, dispatchVoid, responseVoid}, // 10050
    {RIL_REQUEST_SEND_SMS_MSG, dispatchVoid, responseVoid}, // 10051
    {RIL_REQUEST_SEND_SMS_MSG_READ_STATUS, dispatchVoid, responseVoid}, // 10052
    {RIL_REQUEST_MODEM_HANGUP, dispatchVoid, responseVoid}, // 10053
    {RIL_REQUEST_SET_SIM_POWER, dispatchVoid, responseVoid}, // 10054
    {RIL_REQUEST_SET_PREFERRED_NETWORK_LIST, dispatchVoid, responseVoid}, // 10055
    {RIL_REQUEST_GET_PREFERRED_NETWORK_LIST, dispatchVoid, responseVoid}, // 10056
    {RIL_REQUEST_HANGUP_VT, dispatchVoid, responseVoid}, // 10057
    {RIL_REQUEST_REQUEST_HOLD, dispatchVoid, responseVoid}, // 10058
    {RIL_REQUEST_SET_LTE_BAND_MODE, dispatchVoid, responseVoid}, // 10059
    {RIL_REQUEST_QUERY_LOCK_NETWORKS, dispatchVoid, responseVoid}, // 10060
