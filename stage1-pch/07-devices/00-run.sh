#!/bin/bash -e

apt update
apt install -y device-tree-compiler

# compile the overlay
dtc -O dtb -I dts -b 0 -@ -o "${ROOTFS_DIR}/boot/overlays/devicetree-rpi_cm.dtbo" files/devicetree-rpi_cm.dts

# add overlay to config.txt
if ! grep -q "dtoverlay=devicetree-rpi_cm" "${ROOTFS_DIR}/boot/config.txt" ; then
  echo "dtoverlay=devicetree-rpi_cm" >> "${ROOTFS_DIR}/boot/config.txt"
fi
