#!/bin/sh
######################脚本注释#############################
# 文件名： version_check.sh[版本检查]                     #
# 功  能： 检查应用进程是否正常                           #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元： BTFL3_AP, BTFWB_AP, BTFO2_AP                   #
###########################################################
SUPERVISOR_CONF=$HOME/supervisor/supervisord.conf

# java check
java_check (){
if [ `supervisorctl -c ${SUPERVISOR_CONF} status | sed -n '/\bRUNNING/ p' | wc -l` -eq 4 ]; then
    echo "INFO: Java应用运行状态正常"
    exit 0
else
    echo "-------------------------------------------------------------------------------------------------"
    echo "ERROR: 以下Java应用状态异常，请检查"
    supervisorctl -c ${SUPERVISOR_CONF} status | grep -v RUNNING
    echo "-------------------------------------------------------------------------------------------------"
    exit 1
fi
}

# nginx check
nginx_check(){
if [ `netstat -lntp | grep nginx | wc -l` -gt 1 ]; then
    echo "INFO: Nginx运行状态正常"
    exit 0
else
    echo "-------------------------------------------------------------------------------------------------"
    echo "ERROR: Nginx运行状态异常，请检查"
    echo "-------------------------------------------------------------------------------------------------"
    supervisorctl -c ${SUPERVISOR_CONF} status | grep -v RUNNING
    exit 1
fi
}

if [ "$1" == "java" ]; then
    java_check
elif [ "$1" == "nginx" ]; then
    nginx_check
else
    echo "-------------------------------------------------------------------------------------------------"
    echo "Command Error  检查金融应用[BTFL3_AP, BTFO2_AP]     eg: ./version_check.sh java"
    echo "Command Error  检查金融前置[BTFWB_AP]               eg: ./version_check.sh nginx"
    echo "-------------------------------------------------------------------------------------------------"
    exit 1
fi
