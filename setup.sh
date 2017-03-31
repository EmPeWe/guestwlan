#!/bin/bash

VARSYMLINK=/var/guestwlan
VARCONF=$VARSYMLINK/config-files
DHAPD=/etc/default/hostapd

# TODO check for root
# TODO loop over requirements,txt for installation

######
# make general symlink
######

sudo ln -s /home/pi/guestwlan $VARSYMLINK

######
# setup bridge wlan interface
######

sudo apt-get install bridge-utils
sudo ln -s $VARCONF/etc-network-interfaces.d-guestwlan /etc/network/interfaces.d/guestwlan

######
# setup hostapd
######

sudo apt-get install hostapd

echo -e "\n# added by guestwlan setup" | sudo tee -a $DHAPD
cat config-files/etc-default-hostapd-append | sudo tee -a $DHAPD
echo "# END guestwlan setup" | sudo tee -a $DHAPD
cp config-files/etc-hostapd-hostapd.conf.template config-files/etc-hostapd-hostapd.conf
sudo ln -s $VARCONF/etc-hostapd-hostapd.conf /etc/hostapd/hostapd.conf
# TODO ask for custom SSID and change it in hostapd.conf
# TODO ask for Realtek chip, download from Adafruit, set the correct driver in hostapd.conf
# TODO maybe checking dmsg, lsmod or lsusb

######
# setup dnsmasq for client DHCP
######

sudo apt-get install dnsmasq
sudo ln -s $VARCONF/etc-dnsmasq.d-guestwlan /etc/dnsmasq.d/guestwlan

######
# setup ipv4 forward
######

sudo ln -s $VARCONF/etc-sysctl.d-60-guestwlan.conf /etc/sysctl.d/60-guestwlan.conf

######
# set iptables rule
######

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo apt-get iptables-persistent
# dpkg-reconfigure iptables-persistent

######
# setup keygen symlink
######

sudo ln -s $VARSYMLINK/wlankeygen /usr/local/bin/wlankeyken

######
# make local config
######

cp config.template config

######
# setup qrencode
######

sudo apt-get install qrencode

######
# setup graphicsmagick
######

sudo apt-get install graphicsmagick

######
# setup nginx for iOS devices
######

sudo apt-get install nginx-light
# TODO set mime-type
# application/x-apple-aspen-config mobileconfig;

######
# restart system
######

sudo reboot

# END
