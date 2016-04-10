#!/usr/bin/env bash

OPENWRT_GIT_REPO=git://git.openwrt.org/openwrt.git
OPENWRT_GIT_BRANCH=master

# sudo apt-get update
# sudo apt-get install git-core build-essential libssl-dev libncurses5-dev unzip gawk
# sudo apt-get install subversion mercurial

echo "============================================================================="
echo "$(date -u) - Cloning OpenWrt git repository."
echo "============================================================================="
git clone --depth 1 -b $OPENWRT_GIT_BRANCH $OPENWRT_GIT_REPO openwrt
cd openwrt
cp feeds.conf.default feeds.conf
echo "src-svn xorg svn://svn.mein.io/openwrt/feeds/xorg" >> feeds.conf

echo "============================================================================="
echo "$(date -u) - Updating package feeds."
echo "============================================================================="
./scripts/feeds update -a
./scripts/feeds install -a

curl https://dev.openwrt.org/raw-attachment/ticket/19872/qt_not_available_from_nokia.patch | patch -d feeds -p0
curl https://raw.githubusercontent.com/titobrasolin/openwrt/master/config.diff > .config
make defconfig
time make -j1 V=s