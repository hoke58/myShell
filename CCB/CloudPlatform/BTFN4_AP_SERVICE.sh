#!/bin/sh                                                                                                                                                                                   
######################脚本注释#############################
# 文件名： BTFN4_AP_SERVICE.sh                            #
# 功  能： BTFN4服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180522"               #修改时间
DEPLOY_UNION="BTFN4_AP"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"          #编写人邮箱
###########################################################
v_status=`docker ps -a |grep "fabric-zookeeper" |awk -F 'ago         ' '{print $2}'|awk -F '  ' '{print $1}'`
NAMES=`docker ps -a | grep -o 'zkconf_zookeeper[0-5]_1' |awk '{print $0}'`
STATUS=`docker ps -a |grep "fabric-zookeeper" |awk -F 'ago         ' '{print $2}'|awk -F ' ' '{print $1}'`
if [ "$1" == "start" ];then
    echo "--------------------------------------------------------------------------------------"
    if [ "${STATUS}" == "Up" ];then
        echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The zookeeper container is started!Please check it"
        echo "-------------------------------------------------------------------------------"
        exit 1
    else
        docker start $NAMES
        state=`docker ps -a |grep "fabric-zookeeper" |awk -F 'ago         ' '{print $2}'|awk -F ' ' '{print $1}'`
        echo "### 显示 zookeeper container status ###"
        echo "ZOOKEEPER_CONTAINER_STATUS: ["${state}"]"
        if [ "${state}" != "Up" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]ZOOKEEPER_CONTAINER状态:"${v_status}",启动失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]ZOOKEEPER_CONTAINER状态:"${state}",启动成功"
        fi
    fi
    echo "---------------------------------------------------------------------------------------"
elif [ "$1" == "stop" ];then
    echo "-------------------------------------------------------------------------------"
    if [ "${STATUS}" == "Exited" ];then
                echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The zookeeper container is Exited! Please check it"
        echo "-------------------------------------------------------------------------------"
                exit 1
    else
        docker stop $NAMES
        state=`docker ps -a |grep "fabric-zookeeper" |awk -F 'ago         ' '{print $2}'|awk -F ' ' '{print $1}'`
        echo "ZOOKEEPER_CONTAINER_STATUS: ["${state}"]"
        if [ "${state}" != "Exited" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]ZOOKEEPER_CONTAINER状态:${state},停止失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]ZOOKEEPER_CONTAINER状态:${state},停止成功"
        fi
    fi
    echo "------------------------------------------------------------------------------------"
fi
exit 0
