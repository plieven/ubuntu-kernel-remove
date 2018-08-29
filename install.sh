#!/bin/bash

# Check if effective uid is root
if [ "${EUID}" -ne 0 ]; then
    echo "ERR: This script has to be run as root"
    exit 1
fi

. /etc/lsb-release
if [ "${DISTRIB_CODENAME}" = "trusty" ]; then
    if ! dpkg-query -s php5-cli > /dev/null 2>&1; then
        apt-get install -y --no-install-recommends php5-cli
    fi
else
    if ! dpkg-query -s php-cli > /dev/null 2>&1; then
        apt-get install -y --no-install-recommends php-cli
    fi
fi

if ! dpkg-query -s screen > /dev/null 2>&1; then
    apt-get install -y --no-install-recommends screen
fi

mkdir -p /usr/local/sbin
cp -v "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/ubuntu-kernel-remove" /usr/local/sbin/
chmod 755 /usr/local/sbin/ubuntu-kernel-remove

if grep -qs '/usr/local/sbin/ubuntu-kernel-remove' /etc/rc.local; then
    echo ""
    echo "Removing /usr/local/sbin/ubuntu-kernel-remove from /etc/rc.local.."
    echo ""
    sed -i 's/^screen -d -m \/usr\/local\/sbin\/ubuntu-kernel-remove -a -s$//g' /etc/rc.local
fi

echo ""
echo "Addding @reboot cronjob"
echo ""
echo "@reboot root /usr/local/sbin/ubuntu-kernel-remove -a -s" > /etc/cron.d/ubuntu-kernel-remove

if [ -e /etc/cron.d/cron-apt ]; then
    if ! grep -qs '/usr/local/sbin/ubuntu-kernel-remove' /etc/cron.d/cron-apt; then
        echo ""
        echo "Adding /usr/local/sbin/ubuntu-kernel-remove to /etc/cron.d/cron-apt..."
        echo ""
        if ! sed -i '/test -x \/usr\/sbin\/cron-apt && \/usr\/sbin\/cron-apt$/ s/cron-apt$/cron-apt \&\& \/usr\/local\/sbin\/ubuntu-kernel-remove -a -s/g' /etc/cron.d/cron-apt; then
            echo "Installation failed!"
            exit 1
        fi
    fi
fi

echo "Done."
exit 0
