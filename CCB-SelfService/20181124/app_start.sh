#!/bin/sh
######################脚本注释#############################
# 文件名： app_start.sh[自服务启动脚本]                   #
# 功  能： 检查应用进程是否正常                           #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元：  BTFL3_AP、BTFWB_                              #
###########################################################
BASH_PATH=$HOME/bin/usr
APP_NAMES=$1
if [ ! $APP_NAMES ];then
    bash ${BASH_PATH}/BTF[L-N,O,W,X]*.sh start
    if [ $? -eq 0 ];then
        echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]服务启动成功"
        echo "----------------------------------------------------------------------"
        exit 0
    else
        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]服务启动失败"
        echo "----------------------------------------------------------------------"
        exit 1
    fi
else 
    bash ${BASH_PATH}/BTF[L-N,O,W,X]*.sh start ${APP_NAMES}
    if [ $? -eq 0 ];then
        echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]${APP_NAMES}服务启动成功"
        echo "----------------------------------------------------------------------"
        exit 0
    else
        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]${APP_NAMES}服务启动失败"
        echo "----------------------------------------------------------------------"
        exit 1
    fi
    echo "----------------------------------------------------------------------"
fi
exit 0
