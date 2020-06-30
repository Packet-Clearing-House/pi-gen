#!/bin/bash -e

install -m 644 files/console-setup "${ROOTFS_DIR}/etc/default/console-setup"

on_chroot << EOF
setupcon --force --save-only -v
EOF
