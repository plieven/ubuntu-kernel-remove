#!/bin/bash

if [ $(id -u) -ne 0 ]; then
 echo "ERR: This script has to be run as root"
 exit 1
fi

. /etc/lsb-release
if [ "$DISTRIB_CODENAME" = "xenial" ]; then
 X=$(dpkg -S php7.0-cli)
 [ $? -ne 0 ] && apt-get install -y --no-install-recommends php7.0-cli
else
 X=$(dpkg -S php5-cli)
 [ $? -ne 0 ] && apt-get install -y --no-install-recommends php5-cli
fi

X=$(dpkg -S screen)
[ $? -ne 0 ] && apt-get install -y --no-install-recommends screen

mkdir -p /usr/local/sbin
cp -v "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"ubuntu-kernel-remove /usr/local/sbin
chmod 755 /usr/local/sbin/ubuntu-kernel-remove

X=$(grep '/usr/local/sbin/ubuntu-kernel-remove' /etc/rc.local)
if [ $? -ne 0 ]; then
 echo
 echo Adding /usr/local/sbin/ubuntu-kernel-remove to /etc/rc.local..
 echo

 sed -i '/^exit 0$/ s/exit 0/screen -d -m \/usr\/local\/sbin\/ubuntu-kernel-remove -a -s\nexit 0/g' /etc/rc.local

 if [ $? -ne 0 ]; then
  echo Installation failed!
  exit 1
 fi
fi

if [ -e /etc/cron.d/cron-apt ]; then
 X=$(grep '/usr/local/sbin/ubuntu-kernel-remove' /etc/cron.d/cron-apt)
 if [ $? -ne 0 ]; then
  echo
  echo Adding /usr/local/sbin/ubuntu-kernel-remove to /etc/cron.d/cron-apt...
  echo
  sed -i '/test -x \/usr\/sbin\/cron-apt && \/usr\/sbin\/cron-apt$/ s/cron-apt$/cron-apt \&\& \/usr\/local\/sbin\/ubuntu-kernel-remove -a -s/g' /etc/cron.d/cron-apt

  if [ $? -ne 0 ]; then
   echo Installation failed!
   exit 1
  fi
 fi
fi

echo Done.
exit 0
