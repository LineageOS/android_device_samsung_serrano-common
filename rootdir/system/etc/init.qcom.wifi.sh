#!/system/bin/sh
# Copyright (c) 2010-2012, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Credits for the original MAC routine goes to: lbdroid

# No path is set up at this point so we have to do it here.
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

STATUS=`getprop persist.qcom.wifi_mac.init`

if [ "$STATUS" != "complete" ] || [ ! -f "$DEST" ]; then

# Load correct MAC address
DEST="/system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin_"
NVSOURCE="/system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin"
MACSOURCE="/efs/wifi/.mac.info"

MACADDR=""

mv $NVSOURCE $DEST

MACADDR=`cat $MACSOURCE`

# get the bytes individually. Edit for alternative input format
# if needed for other devices.
B1=`echo $MACADDR | cut -d\: -f1`
B2=`echo $MACADDR | cut -d\: -f2`
B3=`echo $MACADDR | cut -d\: -f3`
B4=`echo $MACADDR | cut -d\: -f4`
B5=`echo $MACADDR | cut -d\: -f5`
B6_1=`echo $MACADDR | cut -d\: -f6`

# Now prima calls for 4 unique mac addresses. What it typically does
# is it takes the last byte and increments it by 0-->3 to generate
# the four. Rather than complicated math on ascii representations of
# hexidecimal digits, we are going to ONLY manipulate the final digit
# not the entire final byte. We do this by looking up the position of
# the final digit in a lookup string, and then taking the next three
# characters. Because we only need 4 out of 16, this will suffice.
B6a=`echo $B6_1 | cut -c1`
B6b=`echo $B6_1 | cut -c2`
LOOKUP="0123456789abcdef012"

IDX=`expr index "$LOOKUP" "$B6b"`
B6_2=$B6a`echo $LOOKUP | cut -c$((IDX+1))`
B6_3=$B6a`echo $LOOKUP | cut -c$((IDX+2))`
B6_4=$B6a`echo $LOOKUP | cut -c$((IDX+3))`

# The actual edit.
hexdump -Cv $DEST | sed -e "s/^00000000  \(.*\)00 00 00 00 00 00  |/00000000  \1$B1 $B2 $B3 $B4 $B5 $B6_1  |/" | sed -e "s/^00000010  .*  |/00000010  $B1 $B2 $B3 $B4 $B5 $B6_2 $B1 $B2  $B3 $B4 $B5 $B6_3 $B1 $B2 $B3 $B4  |/" | sed -e "s/^00000020  00 03\(.*\)/00000020  $B5 $B6_4\1/" | hexdump -R > $NVSOURCE

setprop persist.qcom.wifi_mac.init complete
fi

# Run audio init script
/system/bin/sh /system/etc/init.qcom.audio.sh
