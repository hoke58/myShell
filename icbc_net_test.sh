#!/bin/sh
######################脚本注释#############################
# 文件名： icbc_net_test.sh                               #
# 功  能： CTFU项目工行网络连通性测试                     #
###########################################################
HBCCCLOUD_PORT=14004
PID=`ps -ef |grep $HBCCCLOUD_PORT |grep -v grep |awk '{print $2}'`

if [ "$1" == "start" ];then
    python -m SimpleHTTPServer $HBCCCLOUD_PORT /dev/null 2>&1 &
elif [ "$1" == "stop" ];then
    kill -9 $PID
fi

