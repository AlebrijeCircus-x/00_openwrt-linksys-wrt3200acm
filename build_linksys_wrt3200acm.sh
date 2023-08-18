#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="22.03.3"
BOARD_NAME="mvebu"
BOARD_SUBNAME="cortexa9"
BUILDER="https://downloads.openwrt.org/releases/${BUILD_VERSION}/targets/${BOARD_NAME}/${BOARD_SUBNAME}/openwrt-imagebuilder-${BUILD_VERSION}-${BOARD_NAME}-${BOARD_SUBNAME}.Linux-x86_64.tar.xz"

BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/

# clean previous images
make clean

make image  	PROFILE="linksys_wrt3200acm"  		\
		PACKAGES="block-mount 			\
  			  kmod-fs-ext4 			\
       			  kmod-usb-storage 		\
	    		  blkid mount-utils 		\
	 		  swap-utils 			\
      			  e2fsprogs 			\
	   		  fdisk 			\
			  dnsmasq			\
			  auc 				\
			  base-files 			\
			  busybox 			\
			  ca-bundle 			\
			  dnsmasq 			\
			  dropbear 			\
			  fail2ban			\
			  firewall4 			\
			  fstools 			\
			  iwinfo 			\
			  kmod-btmrvl 			\
			  kmod-gpio-button-hotplug 	\
			  kmod-mwifiex-sdio 		\
			  kmod-mwlwifi 			\
			  kmod-nft-offload 		\
			  libustream-wolfssl 		\
			  logd				\ 
			  luci				\
     			  luci-base 			\
			  luci-app-firewall		\
			  luci-app-advanced-reboot	\
			  luci-app-attendedsysupgrade	\   	
			  luci-app-nextdns 		\
			  luci-app-opkg			\
			  luci-app-squid 		\
			  mtd 				\
			  mwlwifi-firmware-88w8964 	\
			  netifd 			\
			  nftables 			\
			  odhcp6c 			\	
			  odhcpd-ipv6only 		\
			  opkg 				\
			  ppp 				\
			  ppp-mod-pppoe 		\
			  procd 			\
			  procd-seccomp 		\
			  procd-ujail 			\
			  squid				\
			  squid-mod-cachemgr		\
			  uboot-envtools 		\
			  uci 				\
			  uclient-fetch 		\
			  urandom-seed 			\
			  urngd 			\
			  wpad-basic-wolfssl 		\
          	FILES="${BASEDIR}/files/" 		\
          	BIN_DIR="$OUTPUT"
