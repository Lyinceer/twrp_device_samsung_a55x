#!/system/bin/sh
# Copyright 2025 © Lyinceer
# Licensed under CC BY-NC-SA 4.0
# https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode

# Checks if /data is already decrypted
mount /vendor

FSTAB_PATH="/vendor/etc/fstab.s5e8845"

if [ -f "$FSTAB_PATH" ] && ! grep -q fileencryption "$FSTAB_PATH"; then
  echo "[+] Already patched. Skipping nuker."
  umount /vendor
  exit 0
fi

umount /vendor

sleep 5

# Format userdata
umount /data
sleep 5
make_f2fs -f /dev/block/by-name/userdata
sleep 5
mount /data

# Detect active slot
SLOT=$(/system/bin/detect_slot.sh) || exit 1

VENDOR_IMG=/dev/block/mapper/vendor_${SLOT}
SUPER_IMG=/dev/block/by-name/super

[ -b "$VENDOR_IMG" ] || exit 1
[ -b "$SUPER_IMG" ] || exit 1

# Prepare workspace
rm -rf /data/local/tmp
mkdir -p /data/local/tmp/lpunpack /data/local/tmp/unpack

# Dump current super
dd if="$SUPER_IMG" of="/data/local/tmp/super.img" bs=1M || exit 1

# Unpack super image
/system/bin/lpunpack /data/local/tmp/super.img /data/local/tmp/lpunpack || exit 1

# Rename vendor image
cp /data/local/tmp/lpunpack/vendor_${SLOT}.img /data/local/tmp/lpunpack/vendor.img

# Extract EROFS filesystem
/system/bin/extract.erofs64 -i /data/local/tmp/lpunpack/vendor.img -x -f -o /data/local/tmp/unpack || exit 1

# Modify fstab if present
FSTAB=$(find /data/local/tmp/unpack/vendor/ -name fstab.s5e8845 | head -n1)
[ -f "$FSTAB" ] || exit 1

/system/bin/busybox sed -i \
  -e 's#^/dev/block/by-name/metadata.*#/dev/block/by-name/metadata\t/metadata\tf2fs\tnoatime,nosuid,nodev,discard,sync,fsync_mode=strict,data_flush\twait,formattable,first_stage_mount,check#' \
  -e 's#^/dev/block/by-name/userdata.*#/dev/block/by-name/userdata\t/data\tf2fs\tnoatime,nosuid,nodev,discard,usrquota,grpquota,fsync_mode=nobarrier,reserve_root=32768,resgid=5678\tlatemount,wait,check,quota,checkpoint=fs,reservedsize=128M,fscompress#' \
  "$FSTAB"

# Extract UUID and TIMESTAMP
FS_OPTIONS=$(find /data/local/tmp/unpack/config -name vendor_fs_options | head -n1)
UUID=$(awk '/-U/ { for(i=1;i<=NF;i++) if($i=="-U") print $(i+1) }' "$FS_OPTIONS")
TIMESTAMP=$(awk '/-T/ { for(i=1;i<=NF;i++) if($i=="-T") print $(i+1) }' "$FS_OPTIONS")

# Rebuild vendor image
/system/bin/mkfs.erofs \
  --mount-point=vendor \
  -z lz4 \
  -U "$UUID" \
  -T "$TIMESTAMP" \
  --file-contexts=/data/local/tmp/unpack/config/vendor_file_contexts \
  --fs-config-file=/data/local/tmp/unpack/config/vendor_fs_config \
  /data/local/tmp/vendor_mod.img \
  /data/local/tmp/unpack/vendor

# Replace vendor in unpack dir
cp /data/local/tmp/vendor_mod.img /data/local/tmp/lpunpack/vendor_${SLOT}.img

# Verify no inlinecrypt remains
/system/bin/extract.erofs64 -i /data/local/tmp/lpunpack/vendor_${SLOT}.img -x -o /data/local/tmp/verify
FSTAB_VERIFY=$(find /data/local/tmp/verify -name fstab.s5e8845 | head -n1)
grep -q inlinecrypt "$FSTAB_VERIFY" && exit 1

# Generate lpmake args
/system/bin/gen_lpmake_args.sh /data/local/tmp/lpunpack /dev/block/by-name/super > /data/local/tmp/lpmake_args.txt
LPMARGS=$(cat /data/local/tmp/lpmake_args.txt)
SUPER_SIZE=$(/system/bin/busybox blockdev --getsize64 /dev/block/by-name/super)
METASLOTS=$(/system/bin/lpdump /dev/block/by-name/super | awk '/Metadata slot count/ {print $NF}')
[ -z "$METASLOTS" ] && METASLOTS=2

# Repack super image
/system/bin/lpmake \
  --metadata-size 65536 \
  --metadata-slots "$METASLOTS" \
  --super-name super \
  --device super:$SUPER_SIZE \
  $LPMARGS \
  --output /data/local/tmp/super_fixed.img || exit 1

# Flash repacked super
dd if=/data/local/tmp/super_fixed.img of=/dev/block/by-name/super bs=1M || exit 1
sync

# Final cleanup
rm -rf /data/local/tmp/*
rm -rf /tmp/*
mkdir -p /data/media

exit 0
