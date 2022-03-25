#!/bin/bash
set -e
if [[ -d "/data" ]];then
    if [[ ! -d "/data/piwigo" ]];then
        tar -zxvf /piwigo.tar.gz -C /data;
    fi
fi
if [[ -d "/data/piwigo" ]];then
    if [[ ! -d "/var/www/html" ]];then
        ln -s /data/piwigo /var/www/html
    fi
fi

if [[ "$@" == "command-default" ]];then
    exec runit
else
    exec "$@"
fi