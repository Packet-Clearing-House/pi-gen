#!/bin/bash -e

on_chroot << EOF
systemctl disable systemd-timesyncd
systemctl disable cron

systemctl disable apt-daily-upgrade.timer
systemctl disable apt-daily.timer
systemctl disable logrotate.timer
systemctl disable man-db.timer

systemctl mask systemd-tmpfiles-clean.timer
EOF
