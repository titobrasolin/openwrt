#!/usr/bin/env bash

OPENWRT_GIT_REPO=git://git.openwrt.org/openwrt.git
OPENWRT_GIT_BRANCH=master

# sudo apt-get update
# sudo apt-get install git-core build-essential libssl-dev libncurses5-dev unzip gawk
# sudo apt-get install subversion mercurial
# sudo apt-get install openjdk-7-jdk
# sudo apt-get install qt4-dev-tools

echo "============================================================================="
echo "$(date -u) - Cloning OpenWrt git repository."
echo "============================================================================="
git clone --depth 1 -b $OPENWRT_GIT_BRANCH $OPENWRT_GIT_REPO openwrt
cd openwrt
cp feeds.conf.default feeds.conf
echo "src-git xorg https://github.com/mkschreder/openwrt-xorg-feed.git" >> feeds.conf

echo "============================================================================="
echo "$(date -u) - Updating package feeds."
echo "============================================================================="
./scripts/feeds update -a

echo "============================================================================="
echo "$(date -u) - Downloading libmodbus patch."
echo "============================================================================="
curl https://github.com/titobrasolin/libmodbus/commit/b9d65dcbef2613c818ab420b6089d5d95b366d3a.patch \
   --create-dirs -o ./feeds/packages/libs/libmodbus/patches/010-modbus_reply_raw_response.patch

echo "============================================================================="
echo "$(date -u) - Installing package feeds."
echo "============================================================================="
./scripts/feeds install -a

echo "============================================================================="
echo "$(date -u) - Configuring and building."
echo "============================================================================="
curl https://raw.githubusercontent.com/titobrasolin/openwrt/master/diffconfig > .config
make defconfig
# https://wiki.openwrt.org/doc/faq/development#building_on_multi-core_cpu
time make -j$(($(nproc)+1)) # V=s
