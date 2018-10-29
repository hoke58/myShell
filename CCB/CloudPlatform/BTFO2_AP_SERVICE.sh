#!/bin/sh
######################脚本注释#############################
# 文件名： BTFO2_AP_SERVICE.sh                            #
# 功  能： BTFO2服务起停脚本                              #
###########################################################
VERSION="2"                            #版本号
MODIFIED_TIME="20181013"               #修改时间
DEPLOY_UNION="BTFO2_AP"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"          #编写人邮箱
###########################################################
CONF_FILE=$HOME/supervisor/supervisord.conf
APP_NAMES=$2
: ${APP_NAMES:=all}
if [ "$1" == "start" ];then
    echo "-------------------------------------------------------------------------------------------------"
    if [ "${APP_NAMES}" == "all" ];then
        supervisorctl -c ${CONF_FILE} start ${APP_NAMES}
        sleep 3s
        state=`supervisorctl -c ${CONF_FILE} status|awk '{print $2}'`
        for state in ${state[@]}
        do
            [ "${state}" != "RUNNING" ] && echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]应用状态:"${state}",启动失败" && exit 1
            [ "${state}" == "RUNNING" ] && echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]应用状态:"${state}",启动成功" 
        done
        echo "-------------------------------------------------------------------------------------------------"
        exit 0
    else
        supervisorctl -c ${CONF_FILE} start ${APP_NAMES}
        state=`supervisorctl -c ${CONF_FILE} status|grep $2 |awk '{print $2}'`
        if [ "${state}" != "RUNNING" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]${APP_NAMES}应用状态:"${STATUS}",启动失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]${APP_NAMES}应用状态:"${state}",启动成功"
        fi
        exit 0
    fi
    echo "-------------------------------------------------------------------------------------------------"
elif [ "$1" == "stop" ];then
    echo "-------------------------------------------------------------------------------------------------"
    if [ "${APP_NAMES}" == "all" ];then
        supervisorctl -c ${CONF_FILE} stop ${APP_NAMES}
        state=`supervisorctl -c ${CONF_FILE} status|awk '{print $2}'`
        for state in ${state[@]}
        do  
            [ "$state" == "STOPPED" ] && echo "INFO:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]应用状态:"${state}",停止成功"
            [ "$state" != "STOPPED" ] && echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]应用状态:"${state}",停止失败" && exit 1
        done                                                                                                                                                                               
        echo "-------------------------------------------------------------------------------------------------"
        exit 0
    else
        supervisorctl -c ${CONF_FILE} stop ${APP_NAMES}
        sleep 3s
        state=`supervisorctl -c ${CONF_FILE} status|grep $2 |awk '{print $2}'`
        if [ "${state}" != "STOPPED" ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]${APP_NAMES}应用状态:"${state}",停止失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]${APP_NAMES}应用状态:"${state}",停止成功"
        fi
    fi
    echo "-------------------------------------------------------------------------------------------------"
fi
exit 0
