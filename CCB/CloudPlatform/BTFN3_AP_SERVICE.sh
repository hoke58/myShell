#!/bin/sh                                                                                                                                                   
######################脚本注释#############################
# 文件名： BTFN3_AP_SERVICE.sh                            #
# 功  能： BTFN3服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180522"               #修改时间
DEPLOY_UNION="BTFN3_AP"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"          #编写人邮箱
###########################################################
v_status=`docker ps -a |grep "peer node start" |awk -F 'ago         ' '{print $2}'|awk -F '  ' '{print $1}'`
NAMES=`docker ps -a | grep -o 'peer[0,3].blockchain.ccb.com' |awk 'NR==1 {print $0}'`
STATUS=`docker ps -a |grep "peer node start" |awk -F 'ago         ' '{print $2}'|awk '{print $1}'`
if [ "$1" == "start" ];then
    echo "--------------------------------------------------------------------------------------"
    if [ "${STATUS}" == "Up" ];then
        echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The peer container is started!Please check it"
        echo "-------------------------------------------------------------------------------"
        exit 1
    else
        docker start $NAMES
#        sleep 5
        state=`docker ps -a |grep "peer node start" |awk -F 'ago         ' '{print $2}'|awk '{print $1}'`
        echo "### 显示 peer container status ###"
        echo "PEER_CONTAINER_STATUS: ["${state}"]"
        if [ "${state}" != "Up" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]PEER_CONTAINER状态:"${v_status}",启动失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]PEER_CONTAINER状态:"${state}",启动成功"
        fi
    fi
    echo "---------------------------------------------------------------------------------------"
elif [ "$1" == "stop" ];then
    echo "-------------------------------------------------------------------------------"
    if [ "${STATUS}" == "Exited" ];then
                echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The peer container is Exited! Please check it"
        echo "-------------------------------------------------------------------------------"
                exit 1
    else
        docker stop $NAMES
#        sleep 5
        state=`docker ps -a |grep "peer node start" |awk -F 'ago         ' '{print $2}'|awk '{print $1}'`
    echo "${state}"
        if [ "${state}" != "Exited" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]PEER_CONTAINER状态:${state},停止失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]PEER_CONTAINER状态:${state},停止成功"
        fi
    fi
    echo "------------------------------------------------------------------------------------"
fi
exit 0
