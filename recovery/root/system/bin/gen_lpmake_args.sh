#!/system/bin/sh

IMAGE_DIR="${1:-/data/local/tmp/lpunpack}"
SUPER_DEV="${2:-/dev/block/by-name/super}"
TOOLS="/system/bin"
BUSYBOX="$TOOLS/busybox"
DETECT_SLOT="$TOOLS/detect_slot.sh"

# Detect slot (_a or _b)
SLOT=$($DETECT_SLOT)
[ $? -ne 0 ] && echo "[-] Failed to detect slot" && exit 1
SUFFIX="_$SLOT"

# Prepare temp
TMPFILE="/tmp/lpdump.txt"
"$TOOLS/lpdump" "$SUPER_DEV" > "$TMPFILE" 2>/dev/null || {
  echo "[-] Failed to run lpdump" >&2
  exit 1
}

PARTITION_ARGS=""
GROUP_LIST=""
GROUP_SIZES_TMP="/tmp/group_sizes.tmp"
echo "" > "$GROUP_SIZES_TMP"

CURRENT_PART=""
while IFS= read -r line; do
  case "$line" in
    "  Name:"*)
      CURRENT_PART=$(echo "$line" | awk '{print $2}')
	  # Skip dyndata explicitly
      [ "$CURRENT_PART" = "dyndata" ] && continue
      ;;
    "  Group:"*)
      GROUP_NAME=$(echo "$line" | awk '{print $2}')

      # Skip if partition does not belong to active slot
      case "$CURRENT_PART" in
        *"$SUFFIX") ;;  # e.g. ends in _a
        *) continue ;;
      esac

      # Fix IMG path and PART_NAME before file check
      if [ "$CURRENT_PART" = "dyndata" ]; then
          PART_NAME="dyndata"
          IMG="$IMAGE_DIR/dyndata.img"
      else
          IMG="$IMAGE_DIR/${CURRENT_PART}.img"
          # SPARSE_IMG="$IMAGE_DIR/${CURRENT_PART}.sparse.img"

          if [[ "$CURRENT_PART" == *_a || "$CURRENT_PART" == *_b ]]; then
              PART_NAME="$CURRENT_PART"
          else
              PART_NAME="${CURRENT_PART}${SUFFIX}"
          fi

          if [ ! -f "$IMG" ]; then
            echo "[*] Skipping $CURRENT_PART ($IMG not found)" >&2
            continue
          fi

      fi

        SIZE=$($BUSYBOX stat -c %s "$IMG")
        ALIGNED="$SIZE"

        # Generate inactive slot suffix (e.g., b if current slot is a)
        ALT_SUFFIX="_$( [ "$SLOT" = "a" ] && echo "b" || echo "a" )"
        ALT_PART=$(echo "$PART_NAME" | sed "s/_$SLOT\$/${ALT_SUFFIX}/")

        PARTITION_ARGS="$PARTITION_ARGS  \\
  --partition ${PART_NAME}:readonly:${ALIGNED}:${GROUP_NAME} \\
  --image ${PART_NAME}=${IMG} \\
  --partition ${ALT_PART}:readonly:0:${GROUP_NAME} \\
"
        EXISTING=$(grep "^$GROUP_NAME " "$GROUP_SIZES_TMP" | awk '{print $2}')
        if [ -z "$EXISTING" ]; then
          echo "$GROUP_NAME $ALIGNED" >> "$GROUP_SIZES_TMP"
        else
          TOTAL=$($BUSYBOX expr "$EXISTING" + "$ALIGNED")
          sed -i "/^$GROUP_NAME /d" "$GROUP_SIZES_TMP"
          echo "$GROUP_NAME $TOTAL" >> "$GROUP_SIZES_TMP"
        fi
      ;;
  esac
done < "$TMPFILE"

GROUP_ARGS=""
while read -r GNAME GSIZE; do
  [ "$GNAME" = default ] && continue
  [ -n "$GNAME" ] && GROUP_ARGS="$GROUP_ARGS --group $GNAME:$GSIZE"
done < "$GROUP_SIZES_TMP"

rm -f "$TMPFILE" "$GROUP_SIZES_TMP"

# Final output
if [ -z "$PARTITION_ARGS" ]; then
  echo "[-] No valid partition images found." >&2
  exit 1
fi

echo "$GROUP_ARGS $PARTITION_ARGS"
exit 0
