#!/bin/sh                                                                                                                                                   
######################脚本注释#############################
# 文件名： BTFN2_AP_SERVICE.sh                            #
# 功  能： BTFN2服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180522"               #修改时间
DEPLOY_UNION="BTFN2_AP"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"          #编写人邮箱
###########################################################
STATUS=`docker ps -a |grep "orderer" |awk -F 'ago         ' '{print $2}'|awk '{print $1}'`
NAMES=`docker ps -a | grep -o 'orderer[0-3]' |awk '{print $0}'`

if [ "$1" == "start" ];then
    echo "--------------------------------------------------------------------------------------"
    if [ "${STATUS}" == "Up" ];then
        echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The orderer container is started!Please check it"
        echo "-------------------------------------------------------------------------------"
        exit 1
    else
        docker start $NAMES
        state=`docker ps -a |grep "orderer" |awk -F 'ago         ' '{print $2}'|awk '{print $1}'`
        echo "### 显示 orderer container status ###"
        if [ "${state}" != "Up" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]ORDERER_CONTAINER状态:"${STATUS}",启动失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]ORDERER_CONTAINER状态:"${state}",启动成功"
        fi
    fi
    echo "---------------------------------------------------------------------------------------"
elif [ "$1" == "stop" ];then
    echo "-------------------------------------------------------------------------------"
    if [ "${STATUS}" == "Exited" ];then
        echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The orderer container is Exited! Please check it"
        echo "-------------------------------------------------------------------------------"
        exit 1
    else
        docker stop $NAMES
        state=`docker ps -a |grep "orderer" |awk -F 'ago         ' '{print $2}'|awk '{print $1}'`
        if [ "${state}" != "Exited" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]ORDERER0_CONTAINER状态:${state},停止失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]ORDERER0_CONTAINER状态:${state},停止成功"
        fi
    fi
    echo "------------------------------------------------------------------------------------"
fi
exit 0
