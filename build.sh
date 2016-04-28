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
echo "src-git xorg https://github.com/titobrasolin/openwrt-feeds-xorg.git" >> feeds.conf

echo "============================================================================="
echo "$(date -u) - Updating package feeds."
echo "============================================================================="
./scripts/feeds update -a
./scripts/feeds install -a

curl https://raw.githubusercontent.com/titobrasolin/openwrt/master/diffconfig > .config
make defconfig
# https://wiki.openwrt.org/doc/faq/development#building_on_multi-core_cpu
time make -j$(($(nproc)+1)) # V=s
