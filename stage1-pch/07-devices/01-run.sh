#!/bin/bash -e

# install compiliation packages
apt install -y make gcc bison flex libssl-dev

KERNEL_PACKAGE_VERSION=$(dpkg --root="${ROOTFS_DIR}" -s raspberrypi-kernel | grep '^Version:' | cut -c 10-)

KERNEL_SRC_DIR=$(mktemp -d)
git clone --depth=1 --branch raspberrypi-kernel_${KERNEL_PACKAGE_VERSION} https://github.com/raspberrypi/linux "${KERNEL_SRC_DIR}"

# cross-compile as described at https://www.raspberrypi.org/documentation/linux/kernel/building.md
TOOLS_DIR=$(mktemp -d)
git clone --depth=1 https://github.com/raspberrypi/tools "${TOOLS_DIR}"
export PATH="$PATH:${TOOLS_DIR}/arm-bcm2708/arm-linux-gnueabihf/bin"

(
  cd "${KERNEL_SRC_DIR}"

  KERNEL_VERSION=$(make kernelversion)

  # get kernel configuration
  # enable SND_SOC_TLV320AIC3X module
  ./scripts/extract-ikconfig "${ROOTFS_DIR}/lib/modules/${KERNEL_VERSION}-v7+/kernel/kernel/configs.ko" \
      | sed 's/^# CONFIG_SND_SOC_TLV320AIC3X is not set$/CONFIG_SND_SOC_TLV320AIC3X=m/' \
      > .config

  # compile the sound modules
  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- oldconfig scripts prepare modules_prepare
  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- M=sound/soc/codecs modules

  # TODO: WARNING: Symbol version dump ./Module.symvers is missing?

  # install the module; depmod run in sibling chroot script
  install -m 644 sound/soc/codecs/snd-soc-tlv320aic3x.ko "${ROOTFS_DIR}/lib/modules/${KERNEL_VERSION}-v7+/kernel/sound/soc/codecs"
)
