#!/sbin/sh

# Mount the vendor_boot partition to /tmp/vendor
mkdir -p "/tmp/vendor"
mount -t ext4 -o ro "/dev/block/by-name/vendor_boot" "/tmp/vendor" 2> /dev/null

if [ $? -ne 0 ]; then
    # If mounting as EXT4 failed, assume EroFS and try mounting with EroFS
    echo "I:postrecoveryboot: EXT4 mount failed! Mounting as EroFS." >> /tmp/recovery.log
    mount -t erofs "/dev/block/by-name/vendor_boot" "/tmp/vendor"
fi

# Check if recovery installation script exists in vendor
if [ -f "/tmp/vendor/bin/install-recovery.sh" ]; then
    RECOVERY_HASH=$(sha1sum "/dev/block/by-name/vendor_boot" | cut -d ' ' -f 1)
    EXPECTED_RECOVERY_HASH=$(sed -n '5p' "/tmp/vendor/bin/install-recovery.sh" | cut -d ':' -f 4 | sed 's/ .*//')

    if [ "$RECOVERY_HASH" == "$EXPECTED_RECOVERY_HASH" ]; then
        echo "I:postrecoveryboot: Repacking vendor_boot to prevent stock ROM from replacing TWRP." >> /tmp/recovery.log
        mkdir -p "/tmp/out"
        cd "/tmp/out"
        cat "/dev/block/by-name/vendor_boot" > "/tmp/out/vendor_boot.img"
        magiskboot unpack "/tmp/out/vendor_boot.img"
        magiskboot repack "/tmp/out/vendor_boot.img"
        magiskboot cleanup
        mv -f "/tmp/out/new-vendor_boot.img" "/tmp/out/vendor_boot.img"
        dd if="/tmp/out/vendor_boot.img" of="/dev/block/by-name/vendor_boot"
        cd "/"
        rm -r "/tmp/out"
    fi
fi

# Clean up and unmount the vendor partition
umount "/tmp/vendor"
rm -r "/tmp/vendor"

exit 0