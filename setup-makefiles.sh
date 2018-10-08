#!/bin/bash

export DEVICE_COMMON=serrano-common
export VENDOR=samsung

OUTDIR=vendor/$VENDOR/$DEVICE_COMMON
MAKEFILE=../../../$OUTDIR/$DEVICE_COMMON-vendor-blobs.mk

(cat << EOF) > $MAKEFILE
# Copyright (C) 2013-2016, The CyanogenMod Project
# Copyright (C) 2017, The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE_COMMON/setup-makefiles.sh

PRODUCT_COPY_FILES += \\
EOF

LINEEND=" \\"
COUNT=`wc -l ../../$VENDOR/$DEVICE_COMMON/proprietary-files.txt | awk {'print $1'}`
DISM=`egrep -c '(^#|^$)' ../../$VENDOR/$DEVICE_COMMON/proprietary-files.txt`
COUNT=`expr $COUNT - $DISM`
for FILE in `egrep -v '(^#|^$)' ../../$VENDOR/$DEVICE_COMMON/proprietary-files.txt`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
  # Split the file from the destination (format is "file[:destination]")
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  if [[ ! "$FILE" =~ ^-.* ]]; then
    FILE=`echo ${PARSING_ARRAY[0]} | sed -e "s/^-//g"`
    DEST=${PARSING_ARRAY[1]}
    if [ -n "$DEST" ]; then
        FILE=$DEST
    fi
    echo "    $OUTDIR/proprietary/$FILE:system/$FILE$LINEEND" >> $MAKEFILE
  fi
done
(cat << EOF) >> $MAKEFILE
EOF

(cat << EOF) > ../../../$OUTDIR/BoardConfigVendor.mk
# Copyright (C) 2013-2016, The CyanogenMod Project
# Copyright (C) 2017, The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE_COMMON/setup-makefiles.sh
EOF

(cat << EOF) > ../../../$OUTDIR/$DEVICE_COMMON-vendor.mk
# Copyright (C) 2013-2016, The CyanogenMod Project
# Copyright (C) 2017, The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE_COMMON/setup-makefiles.sh

# Pick up overlay for features that depend on non-open-source files
DEVICE_PACKAGE_OVERLAYS += vendor/$VENDOR/$DEVICE_COMMON/overlay

\$(call inherit-product, vendor/$VENDOR/$DEVICE_COMMON/$DEVICE_COMMON-vendor-blobs.mk)
EOF

(cat << EOF) > ../../../$OUTDIR/BoardConfigVendor.mk
# Copyright (C) 2013-2016, The CyanogenMod Project
# Copyright (C) 2017, The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE_COMMON/setup-makefiles.sh
EOF

(cat << EOF) > ../../../$OUTDIR/Android.mk
# Copyright (C) 2013-2016, The CyanogenMod Project
# Copyright (C) 2017, The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE_COMMON/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

ifeq (\$(BOARD_VENDOR),samsung)
ifneq (\$(filter serrano3gxx serranodsdd serranodsub serranoltebmc \\
                serranoltespr serranolteusc serranoltexx,\$(TARGET_DEVICE)),)

endif
endif
EOF
