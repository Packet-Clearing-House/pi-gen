#!/bin/bash -e

install -m 700 files/overlay "${ROOTFS_DIR}/etc/initramfs-tools/scripts/overlay"

# add overlay to the list of modules
if ! grep overlay "${ROOTFS_DIR}/etc/initramfs-tools/modules" > /dev/null; then
  echo overlay >> "${ROOTFS_DIR}/etc/initramfs-tools/modules"
fi

# fixed to the -v7+ version used by our pi boards
KERN=$(ls -1 "${ROOTFS_DIR}/usr/lib/modules" | grep -- "-v7+")

# generate initrd
on_chroot << EOF
  set -x
  update-initramfs -c -k "${KERN}"
EOF

# modify config.txt
sed -i "${ROOTFS_DIR}/boot/config.txt" -e "/initramfs.*/d"
echo "initramfs initrd.img-${KERN}" >> "${ROOTFS_DIR}/boot/config.txt"

# modify command line
if ! grep -q "boot=overlay" "${ROOTFS_DIR}/boot/cmdline.txt" ; then
  sed -i "${ROOTFS_DIR}/boot/cmdline.txt" -e "s/^/boot=overlay /"
fi
