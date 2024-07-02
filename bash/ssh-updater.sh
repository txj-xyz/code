#!/bin/bash

declare -x SSH_UPDATER_DOWNLOAD_VERSION="9.8p1"

function update_ssh_version {
    clear
    echo -e "\n\t-------------------"
    echo -e "\tCurrent SSH Version"
    echo -e "\t-------------------"
    ssh -V
    echo -e "\t-------------------"

    sleep 5;

    echo -e "\t-------------------"
    echo -e "\tUpdating package manager"
    echo -e "\t-------------------"
    apt update
    echo -e "\t-------------------"
    
    
    echo -e "\t-------------------"
    echo -e "\tUpdating ssh-server"
    echo -e "\tVersion: '$SSH_UPDATER_DOWNLOAD_VERSION'"
    echo -e "\t-------------------"
    apt install make build-essential zlib1g-dev libssl-dev libpam0g-dev libselinux1-dev libkrb5-dev wget -y

    if [ $? -ne 0 ]; then
        echo -e "\e[31m[FATAL]\e[0m Failed to install dependencies for OpenSSH installer"
        return 1
    fi

    mkdir /var/lib/sshd > /dev/null 2>&1
    chmod -R 700 /var/lib/sshd/
    chown -R root:sys /var/lib/sshd/
    wget -c https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${SSH_UPDATER_DOWNLOAD_VERSION}.tar.gz
    tar -xzf openssh-${SSH_UPDATER_DOWNLOAD_VERSION}.tar.gz
    cd openssh-${SSH_UPDATER_DOWNLOAD_VERSION}/
    ./configure --with-md5-passwords --with-pam --with-selinux --with-privsep-path=/var/lib/sshd/ --sysconfdir=/etc/ssh

    if [ $? -ne 0 ]; then
        echo -e "\e[31m[FATAL]\e[0m Failed to update SSH due to and issue with './configure'"
        return 1
    fi

    make
    make install
    echo -e "\t-------------------"

    echo -e "\t----------------------"
    echo -e "\tBacking up SSH files"
    echo -e "\t----------------------"
    if [ ! -e /usr/sbin/sshd ]; then
        echo -e "\e[31m[FATAL]\e[0m Failed to locate '/usr/sbin/sshd'\n"
        echo "Exiting Script in 3 seconds...."
        sleep 3;
        return 1
    elif [ ! -e /usr/local/sbin/sshd ]; then
        echo -e "\e[31m[FATAL]\e[0m Failed to locate '/usr/local/sbin/sshd'\n"
        echo "Exiting Script in 3 seconds...."
        sleep 3;
        return 1
    fi

    sudo mkdir -p /opt/ssh_backups/backups
    echo -e "\t --- Moving SSH backup to '/opt/ssh_backups/backups/' ---"
    sudo mv -v /usr/sbin/sshd /opt/ssh_backups/backups/sshd.bak
    sudo cp -v /usr/local/sbin/sshd /usr/sbin/sshd
    echo -e "\t-------------------"


    echo -e "\t----------------------"
    echo -e "\tCleaning up temp files"
    echo -e "\t----------------------"
    sudo rm -Rvf $PWD/openssh-*
    echo -e "\t-------------------"

    echo -e "\t----------------------"
    echo -e "\tRestarting SSH Service"
    echo -e "\t----------------------"
    service ssh restart
    service sshd restart
    echo -e "\t-------------------"
}

update_ssh_version
