# TWRP Device tree for a55x
## Samsung Galaxy A55 5G SM-A556E (a55x)
For unofficial TWRP build release, go to [releases](https://github.com/Lyinceer/Custom-Recovery-Builder/releases).

## Clone Steps
* Device Tree (Make sure you are in root directory of TWRP source.):
```
git clone https://github.com/Lyinceer/twrp_device_samsung_a55x.git -b twrp-12.1 device/samsung/a55x
```
* Build (Make sure you are in root directory of TWRP source.)
```
source build/envsetup.sh; export ALLOW_MISSING_DEPENDENCIES=true; lunch twrp_a55x-eng; mka vendorbootimage
```