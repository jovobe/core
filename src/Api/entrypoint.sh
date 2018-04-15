#!/bin/bash

USERNAME="bitwarden"
NOUSER=`id -u $USERNAME > /dev/null 2>&1; echo $?`
LUID=${LOCAL_UID:-999}

# Step down from host root
if [ $LUID == 0 ]
then
    LUID=999
fi

if [ $NOUSER == 0 ] && [ `id -u $USERNAME` != $LUID ]
then
    usermod -u $LUID $USERNAME
elif [ $NOUSER == 1 ]
then
    useradd -r -u $LUID -g $USERNAME $USERNAME
fi

if [ ! -d "/home/$USERNAME" ]
then
    mkhomedir_helper $USERNAME
fi

touch /var/log/cron.log
chown $USERNAME:$USERNAME /var/log/cron.log
chown -R $USERNAME:$USERNAME /app
chown -R $USERNAME:$USERNAME /jobs
mkdir -p /etc/bitwarden/core
mkdir -p /etc/bitwarden/logs
mkdir -p /etc/bitwarden/ca-certificates
chown -R $USERNAME:$USERNAME /etc/bitwarden

env >> /etc/environment
cron

cp /etc/bitwarden/ca-certificates/*.crt /usr/local/share/ca-certificates/ \
    && update-ca-certificates

ln -sf /usr/share/zoneinfo/$globalSettings__timezone /etc/localtime

gosu bitwarden:bitwarden dotnet /app/Api.dll
