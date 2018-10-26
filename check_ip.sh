#!/bin/bash

regex_ip="(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])(\.(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])){3}"
if [ ! -n "$1" ] ;then  
    echo "Usage:check_ip.sh [CHECK_PATH]"  
else  
    grep -rE "$regex_ip" $1
fi  
