#!/usr/bin/env bash
# sudo apt-get update
# sudo apt-get install git-core build-essential libssl-dev libncurses5-dev unzip gawk
# sudo apt-get install subversion mercurial
git clone https://git.openwrt.org/openwrt.git
cd openwrt
wget https://raw.githubusercontent.com/titobrasolin/openwrt/master/feeds.conf
./scripts/feeds update -a
./scripts/feeds install -a
cd feeds
wget https://dev.openwrt.org/raw-attachment/ticket/19872/qt_not_available_from_nokia.patch
patch -p0 < qt_not_available_from_nokia.patch
cd ..
mv .config .config.old.1
wget https://raw.githubusercontent.com/titobrasolin/openwrt/master/.config
make
