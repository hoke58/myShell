#!/bin/sh
######################脚本注释#############################
# 文件名： BTFWB_AP_SERVICE.sh                            #
# 功  能： BTFWB服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180519"               #修改时间
DEPLOY_UNION="BTFWB_AP"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"   #编写人邮箱
###########################################################
v_pid_file="$HOME/nginx/logs/nginx.pid"
NGINX_PROG="$HOME/nginx/sbin/nginx"
NGINX_CONF_FILE="$HOME/nginx/conf/nginx.conf"

if [ "$1" == "start" ];then
    echo "----------------------------------------------------------------------"
    if [ -f ${v_pid_file} ];then
        echo "WARNING: The nginx daemon is started!Please check it"
        echo "----------------------------------------------------------------------"
        exit 1
    else
#        echo $NGINX_PROG -c $NGINX_CONF_FILE
        $NGINX_PROG -c $NGINX_CONF_FILE
        state=$(cat ${v_pid_file})
#        echo "### 显示 nginx process ###"
#        echo "NGINX_PROCESS: [${state}]"
        if [ ! -n ${state} ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]NGINX_PROCESS进程:${state},启动失败"
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]NGINX_PROCESS进程:${state},启动成功"
        fi
    fi
        echo "----------------------------------------------------------------------"
elif [ "$1" == "stop" ];then
    echo "------------------------------------------------------------------------------"
    pid=$(cat ${v_pid_file})
    if [ -z ${pid} ];then
        echo "WARNING: The nginx daemon don't exist!"
        echo "------------------------------------------------------------------------------"
        exit 1
    else
        kill -15 ${pid}
        sleep 5
        state=${v_pid_file}
        if [ -f ${state} ];then
            echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]NGINX_PROCESS进程:${pid},停止失败"
            rm -rf ${v_pid_file}
            exit 1
        else
            echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]NGINX_PROCESS进程:${pid},停止成功"
        fi
    fi
        echo "------------------------------------------------------------------------------"
fi
exit 0
