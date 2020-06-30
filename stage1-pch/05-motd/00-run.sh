#!/bin/bash -e

rm -f "${ROOTFS_DIR}/etc/motd"
rm -f "${ROOTFS_DIR}/etc/update-motd.d/10-uname"

install -m 644 files/issue "${ROOTFS_DIR}/etc/issue"

touch "${ROOTFS_DIR}/root/.hushlogin"
