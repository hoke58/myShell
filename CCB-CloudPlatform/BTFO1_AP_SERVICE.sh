#!/bin/sh                                                                                                                                                   
######################脚本注释#############################
# 文件名： BTFO1_AP_SERVICE.sh                            #
# 功  能： BTFO1服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180522"               #修改时间
DEPLOY_UNION="BTFO1_AP"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"          #编写人邮箱
###########################################################
EXIT_API_STATUS=`docker ps -a |grep apiserver_fft |grep Exited |awk -F ' ' '{print $7}'`
EXIT_EVENT_STATUS=`docker ps -a |grep eventserver_fft |grep Exited |awk -F ' ' '{print $7}'`
NAMES_API=apiserver_fft
NAMES_EVENT=eventserver_fft
#NAMES=`docker ps -a | grep -o 'apiserver_f.*' |awk '{print $0}'`
UP_API_STATUS=`docker ps -a |grep apiserver_fft | awk '/Up /{print $7}'`
UP_EVENT_STATUS=`docker ps -a |grep eventserver_fft | awk '/Up /{print $7}'`
v_api_status=`docker ps -a |grep "apiserver_fft" |awk -F 'ago         ' '{print $2}'|awk '{print $1}'`
v_event_status=`docker ps -a |grep "eventserver_fft" |awk -F 'ago         ' '{print $2}'|awk '{print $1}'`
startEvent(){
    if [ "${UP_EVENT_STATUS}" == "Up" ];then
        echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The FFT_EVENT container is started!Please check it"
        echo "-------------------------------------------------------------------------------"
        exit 1
    else
        docker start $NAMES_EVENT
        state=`docker ps -a |grep "eventserver_fft" |awk -F 'ago         ' '{print $2}'|awk '{print $1}'`
        echo "### 显示 event_fft container status ###"
        echo "EVENT_FFT_CONTAINER_STATUS: ["${state}"]"
        if [ "${state}" != "Up" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]EVENT_FFT_CONTAINER状态:"${v_status}",启动失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]EVENT_FFT_CONTAINER状态:"${state}",启动成功"
        fi
    fi
}
stopEvent(){
    if [ "${EXIT_EVENT_STATUS}" == "Exited" ];then
                echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The event_fft container is Exited! Please check it"
        echo "-------------------------------------------------------------------------------"
                exit 1
    else
        docker stop $NAMES_EVENT
        state=`docker ps -a |grep eventserver_fft |grep Exited |awk -F ' ' '{print $7}'`
        echo "EVENT_FFT_CONTAINER_STATUS: ["${state}"]"
        if [ "${state}" != "Exited" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]EVENT_FFT_CONTAINER状态:${state},停止失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]EVENT_FFT_CONTAINER状态:${state},停止成功"
        fi
    fi
}
if [ "$1" == "start" ];then
    echo "--------------------------------------------------------------------------------------"
    if [ "${UP_API_STATUS}" == "Up" ];then
        echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The API_FFT container is started!Please check it"
        startEvent
        echo "-------------------------------------------------------------------------------"
        exit 1
    else
        docker start $NAMES_API
        state=`docker ps -a |grep "apiserver_fft" |awk -F 'ago         ' '{print $2}'|awk '{print $1}'`
        echo "### 显示 api_fft container status ###"
        echo "API_FFT_CONTAINER_STATUS: ["${state}"]"
        if [ "${state}" != "Up" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]API_FFT_CONTAINER状态:"${v_status}",启动失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]API_FFT_CONTAINER状态:"${state}",启动成功"
            startEvent
        fi
    fi
    echo "--------------------------------------------------------------------------------------"
elif [ "$1" == "stop" ];then
    echo "-------------------------------------------------------------------------------"
    if [ "${EXIT_API_STATUS}" == "Exited" ];then
        echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The api_fft container is Exited! Please check it"
        stopEvent 
        echo "-------------------------------------------------------------------------------"
                exit 1
    else
        docker stop $NAMES_API
        state=`docker ps -a |grep apiserver_fft |grep Exited |awk -F ' ' '{print $7}'`
        echo "API_FFT_CONTAINER_STATUS: ["${state}"]"
        if [ "${state}" != "Exited" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]API_FFT_CONTAINER状态:${state},停止失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]API_FFT_CONTAINER状态:${state},停止成功"
        fi
    fi
    stopEvent
    echo "------------------------------------------------------------------------------------"
fi
exit 0
