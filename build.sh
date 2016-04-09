#!/usr/bin/env bash
# sudo apt-get update
# sudo apt-get install git-core build-essential libssl-dev libncurses5-dev unzip gawk
# sudo apt-get install subversion mercurial
git clone https://git.openwrt.org/openwrt.git
cd openwrt
wget https://raw.githubusercontent.com/titobrasolin/openwrt/master/feeds.conf
./scripts/feeds update -a
./scripts/feeds install -a
curl https://dev.openwrt.org/raw-attachment/ticket/19872/qt_not_available_from_nokia.patch \
  | patch -d feeds -p0
mv -b .config .config.old
wget https://raw.githubusercontent.com/titobrasolin/openwrt/master/.config
time make -j1 V=s
