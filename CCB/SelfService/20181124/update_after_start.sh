#!/bin/bash 
cat << EOF
######################脚本注释#############################
# 文件名： update_after_start.sh[应用启动后]              #
# 功  能： 增加外网Haproxy的hosts条目                     #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元： BTFX1_WB                                       #
# 备  注： 该脚本需使用[root]权限执行                     #
###########################################################
EOF
URL_LIST="domlc forfaiting factoring"
WUSHU_F5="10.5.200.77"
run_code=0

green_check(){
    local curl_8080=`curl -s http://$URL.blockchain.ccb.com:8080/api/systemVersion? --connect-timeout 1| awk -F'[""]' '{print $4}' | wc -l`
    local curl_80=`curl -s http://$URL.blockchain.ccb.com:80/api/systemVersion? --connect-timeout 1| awk -F'[""]' '{print $4}' | wc -l`
    if [ $curl_8080 -eq 1 -o $curl_80 -eq 1 ]; then
        echo "-------------------------------------------------------------------------------------------------"
        echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]\""$URL"\"DNS可以正常解析"
        echo "-------------------------------------------------------------------------------------------------"
    else
        echo "-------------------------------------------------------------------------------------------------"
        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]"$URL"DNS无法解析,请检查/etc/hosts"
        echo "`cat /etc/hosts|grep $URL`"
        echo "-------------------------------------------------------------------------------------------------"
        let run_code++      
    fi
}

#check privilege 
if [  "$(id -nu)" != "root" ]; then 
    echo "-------------------------------------------------------------------------------------------------"
    echo "WARN:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]请使用[root]权限执行脚本"
    echo "-------------------------------------------------------------------------------------------------"
    exit 1
fi
for URL in $URL_LIST; do
    ping $URL.blockchain.ccb.com -c 1 -W 1
    res=$?
    if [ $res -eq 2 ]; then
        cp /etc/hosts /etc/hosts.$(date +%Y%m%d%H%M)
        echo $WUSHU_F5 $URL.blockchain.ccb.com >> /etc/hosts
        green_check
    else
        ip=`ping $URL.blockchain.ccb.com -c 1 -W 1 |awk -F '[()]' 'NR==1{print $2}'`
        echo ""$URL".blockchain.ccb.com IP: "$ip""
        green_check
    fi
done
#echo $run_code
exit $run_code
