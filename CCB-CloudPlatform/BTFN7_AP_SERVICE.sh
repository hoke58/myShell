#!/bin/sh
######################脚本注释#############################
# 文件名： BTFN7_AP_SERVICE.sh                            #
# 功  能： BTFN7服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180520"               #修改时间
DEPLOY_UNION="BTFN7"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"   #编写人邮箱
###########################################################
v_process=`ps -ef|grep -i mongos|grep -v "grep"|awk '{print $2}'`
MONGOS_CFG_PATH=/home/ap/blockchain/mongodb/conf/sharding-mongos.conf

if [ "$1" == "start" ];then
        echo "----------------------------------------------------------------------"
        if [ ${v_process} ];then
                echo "WARNING: The mongos daemon is started!Please check it"
                echo "----------------------------------------------------------------------"
                exit 1
        else
                mongos -f $MONGOS_CFG_PATH
                state=`ps -ef|grep -i mongos|grep -v "grep"|awk '{print $2}'`
                echo "### 显示 mongos process ###"
                echo "MONGOS_PROCESS: [${state}]"
                if [ ! -n ${state} ];then
                        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MONGOS_PROCESS进程:${state},启动失败"
                        exit 1
                else
                        echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MONGOS_PROCESS进程:${state},启动成功"
                fi
        fi
        echo "----------------------------------------------------------------------"
elif [ "$1" == "stop" ];then
        echo "------------------------------------------------------------------------------"
        if [ -z ${v_process} ];then
                echo "WARNING: The mongos daemon don't exist!"
                echo "------------------------------------------------------------------------------"
                exit 1
        else
                kill -2 ${v_process}
                state=`ps -ef|grep -i mongos|grep -v "grep"|awk '{print $2}'`
                if [ ${state} ];then
                        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MONGOS_PROCESS进程:${state},停止失败"
                        exit 1
                else
                        echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MONGOS_PROCESS进程:${v_process},停止成功"
                fi
        fi
        echo "------------------------------------------------------------------------------"
fi
exit 0