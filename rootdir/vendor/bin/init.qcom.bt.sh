#!/vendor/bin/sh

LOG_TAG="qcom-bluetooth"
LOG_NAME="${0}:"

loge ()
{
  /vendor/bin/log -t $LOG_TAG -p e "$LOG_NAME $@"
}

logi ()
{
  /vendor/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

failed ()
{
  loge "$1: exit code $2"
  exit $2
}

# Note that "hci_qcomm_init -e" prints expressions to set the shell variables
# BTS_DEVICE, BTS_TYPE, BTS_BAUD, and BTS_ADDRESS.

setprop vendor.bluetooth.status off

eval $(/vendor/bin/hci_qcomm_init -e && echo "exit_code_hci_qcomm_init=0" || echo "exit_code_hci_qcomm_init=1")

case $exit_code_hci_qcomm_init in
  0) logi "Bluetooth QSoC firmware download succeeded, $BTS_DEVICE $BTS_TYPE $BTS_BAUD $BTS_ADDRESS";;
  *) failed "Bluetooth QSoC firmware download failed" $exit_code_hci_qcomm_init;
     setprop vendor.bluetooth.status off
     exit $exit_code_hci_qcomm_init;;
esac

setprop vendor.bluetooth.status on

exit 0
