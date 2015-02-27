#!/bin/bash

if [ $(id -u) -ne 0 ]; then
 echo "ERR: This script has to be run as root"
 exit 1
fi

X=$(dpkg -S php5-cli) 
[ $? -ne 0 ] && apt-get install -y --no-install-recommends php5-cli
X=$(dpkg -S screen)
[ $? -ne 0 ] && apt-get install -y --no-install-recommends screen

mkdir -p /usr/local/sbin
cp -v ./ubuntu-kernel-remove /usr/local/sbin
chmod 755 /usr/local/sbin/ubuntu-kernel-remove

$(grep '/usr/local/sbin/ubuntu-kernel-remove' /etc/rc.local)
[ $? -eq 0 ] && echo && echo "Done." && exit 0
echo
echo Adding /usr/local/sbin/ubuntu-kernel-remove to /etc/rc.local
echo

sed -i '/^exit 0$/ s/exit 0/screen -d -m \/usr\/local\/sbin\/ubuntu-kernel-remove -a -s\nexit 0/g' /etc/rc.local

if [ $? -ne 0 ]; then
 echo Installation failed!
 exit 1
fi

echo Done.
exit 0
