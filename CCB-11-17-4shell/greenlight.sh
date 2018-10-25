#!/bin/sh
######################脚本注释#############################
# 文件名： greenlight.sh[绿灯测试]                        #
# 功  能： 绿灯检测                                       #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元： BTFWB                                          #
###########################################################
URL=("domlc.blockchain.ccb.com" "forfaiting.blockchain.ccb.com" "factor.blockchain.ccb.com")
for url in ${URL[@]}
do
    curl -s http://${url}/api/systemVersion? --connect-timeout 1|awk -F'[""]' '{print $4}' >> ${url}.txt
    state= curl -s http://${url}/api/systemVersion? --connect-timeout 1|awk -F'[""]' '{print $4}'
    state=$(cat ${url}.txt)
#    echo ${state[0]}
    if [[ ${state} == "" ]];then
#    if [[ ! -n "${state[0]}" ]];then
        echo "----------------------------------------------------------------------"
        echo "WARNING: ${url}绿灯测试不可访问!"
        echo "----------------------------------------------------------------------"
        exit 1
    else
        echo "----------------------------------------------------------------------"
        echo "INFO: ${url}绿灯测试可访问!"
    fi
done
echo "2----------------------------------------------------------------------"
exit 0
