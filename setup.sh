#!/bin/bash

# todo check for root
# todo loop over requirements,txt for installation

######
# make general symlink
######

sudo ln -s /home/pi/guestwlan /var/guestwlan

######
# setup hostapd
######

sudo apt-get install hostapd
HAPD=/etc/default/hostapd

echo -e "\n# added by guestwlan setup" | sudo tee -a $HAPD
cat config-files/etc-default-hostapd-append | sudo tee -a $HAPD
echo "# END guestwlan setup" | sudo tee -a $HAPD
sudo ln -s /var/guestwlan/config-files/etc-hostapd-hostapd.conf /etc/hostapd/hostapd.conf

######
# setup dnsmasq
######

sudo pt-get install dnsmasq
sudo ln -s /var/guestwlan/config-files/etc-dnsmasq.d-guestwlan /etc/dnsmasq.d/guestwlan

######
# setup wlan interface
######

sudo ln -s /var/guestwlan/config-files/etc-network-interfaces.d-guestwlan /etc/network/interfaces.d/guestwlan

######
# setup ipv4 forward
######

sudo ln -s /var/guestwlan/config-files/etc-sysctl.d-60-guestwlan.conf /etc/sysctl.d/60-guestwlan.conf

######
# make local config
######

cp config.template config

# END
