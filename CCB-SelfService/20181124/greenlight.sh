#!/bin/bash
######################脚本注释#############################
# 文件名： greenlight.sh[绿灯测试]                        #
# 功  能： 绿灯检测Nginx及应用                            #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元： BTFX1_WB                                       #
# 备  注： 运行绿灯脚本前确保[BTFX1_WB]能解析产品域名     #
###########################################################
URL_LIST="domlc forfaiting factoring"
run_code=0

verifyResult() {
if [ $run_code -ne 0 ]; then
    echo "================== ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]"$2" is failed =================="
    echo
    exit 1
else
    echo "================== INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]"$2" is successful =================="
    exit 0
fi
}

for URL in $URL_LIST; do
    echo "Starting ["$URL"] greenlight test..."
    echo "Get ["$URL"] Java version..."
    state=`curl -s http://$URL.blockchain.ccb.com:8080/api/systemVersion? --connect-timeout 1|awk -F'[""]' '{print $4}'`
    echo "The ["$URL"] Java version: ["$state"]"
    if [ "$state" = "" ];then
        echo "----------------------------------------------------------------------"
        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Failed to get the [${URL}] Java version"
        echo "----------------------------------------------------------------------"
        run_code=`expr $run_code + 1`
    else
        echo "----------------------------------------------------------------------"
        echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]The "$URL" Java version is ["$state"]"
        echo "----------------------------------------------------------------------"
    fi
done
echo $run_code
verifyResult $run_code "Greenlight"
