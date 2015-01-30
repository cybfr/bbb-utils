#!/bin/bash
apt-get install -y \
avahi-daemon bind9 btrfs-tools cloudprint-service \
cron-apt curl dnsutils fail2ban hplip \
locales logcheck lynx manpages nscd nslcd ntp ntpdate \
openbsd-inetd openssl-blacklist screen slpd slptool \
watchdog
apt-get install  isc-dhcp-server
