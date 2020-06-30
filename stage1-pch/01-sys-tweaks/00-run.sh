#!/bin/bash -e

install -d "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d"
install -m 644 files/nodisallocate.conf "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/nodisallocate.conf"
install -m 644 files/autologin.conf "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/autologin.conf"

install -d "${ROOTFS_DIR}/etc/systemd/system/getty@tty2.service.d"
install -m 644 files/autologin.conf "${ROOTFS_DIR}/etc/systemd/system/getty@tty2.service.d/autologin.conf"

install -v -m 644 files/fstab "${ROOTFS_DIR}/etc/fstab"

on_chroot << EOF
echo "root:root" | chpasswd
EOF

on_chroot << EOF
systemctl set-default multi-user.target
EOF

# don't start getty on serial port
on_chroot << EOF
systemctl mask serial-getty@ttyAMA0
EOF
