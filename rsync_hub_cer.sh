#!/bin/bash
######################脚本注释#############################
# 文件名： rsync_hub_cer.sh                               #
# 功  能： rysnc hub.finrunchain.com TLS  cert            #
# 作  者： hoke                                           #
# 时  间： 20191018                                       #
###########################################################
#######color code########
RED="31m"      # Error message
GREEN="32m"    # Success message
YELLOW="33m"   # Warning message
BLUE="36m"     # Info message 
###############################
get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^127\.|^255\.|^0\." | head -n 1 )
    [ ! -z ${IP} ] && echo ${IP} || echo
}

colorEcho(){
    COLOR=$1
    echo -e "\033[${COLOR}${@:2}\033[0m"
}
TLS_CERT=/home/hoke/harbor/hub.finrunchain.com/fullchain.pem
EXPIRED=`openssl x509 -in ${TLS_CERT} -noout -enddate | awk -F= '{print $2}'`
END_TIMESTAMP=`date -d "$EXPIRED" +"%s"`
CURRENT_TIMESTAMP=`date +"%s"`
SERVERCHAN_SCKEY=SCU38708T6a6ef2a90890cce5b531a2fec30de1335c2eb15b53c66

colorEcho ${BLUE} "[$(date)]: Comparing timestamps is $((END_TIMESTAMP-CURRENT_TIMESTAMP))"
if [[ $END_TIMESTAMP -le $CURRENT_TIMESTAMP ]]; then
    colorEcho ${YELLOW} "Certificate is expired, rsync TLS cert."
    curl -s "http://sc.ftqq.com/$SERVERCHAN_SCKEY.send?text=【证书到期】" -d "&desp=host:$(get_ip)-[hub.finrunchain.com] valid until ${EXPIRED}"
    rsync -avz --delete root@ali_ansible:/www/server/panel/vhost/ssl/hub.finrunchain.com /home/hoke/harbor
    docker restart nginx > /dev/null
else
    colorEcho ${BLUE} "certification valid until ${EXPIRED}"
fi