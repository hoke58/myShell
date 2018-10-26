#!/bin/sh
######################脚本注释#############################
# 文件名： BTFO4_AP_SERVICE.sh                            #
# 功  能： BTFO4_AP服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180520"               #修改时间
DEPLOY_UNION="BTFO4_AP"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"          #编写人邮箱
###########################################################
APP_USER=blockchain
CACHE_EXE_DIR=$HOME/hazelcast/bin
PID_FILE=$CACHE_EXE_DIR/hazelcast_instance.pid

para1=$1
if [ "${para1}" = "start" ]; then
	cd ${CACHE_EXE_DIR}
	${CACHE_EXE_DIR}/start.sh >/dev/null 2>&1
	sleep 5
	echo "----------------------------------------------------------------------"
	echo "显示Hazelcast进程"
	ps -ef | grep -w blockchain | grep hazelcast
	cnt=`ps -ef | grep -w blockchain | grep hazelcast | wc -l`
	if [ $cnt -ne 1 ];then
		echo "ERROR: [`hostname`][`date +%Y-%m-%d_%H%:M:%S`]Hazelcast进程[${cnt}],启动失败!"
		exit 1
	else
		echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Hazelcast进程[${cnt}],启动成功"
	fi
	echo "------------------------------------------------------------------------------"
elif [ "${para1}" == "stop" ]; then
	cd ${CACHE_EXE_DIR}
	${CACHE_EXE_DIR}/stop.sh >/dev/null 2>&1
	sleep 5
	echo "------------------------------------------------------------------------------"
	echo "显示Hazelcast进程"
	ps -ef | grep -w blockchain | grep hazelcast
	cnt=`ps -ef | grep -w blockchain | grep hazelcast | wc -l`
	if [ $cnt -ne 0 ];then
		echo "ERROR: [`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Hazelcast进程[${cnt}],停止失败!"
		exit 1
	else
		echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Hazelcast进程[${cnt}],停止成功"
	fi
	echo "------------------------------------------------------------------------------"
else
	echo "ERROR: [`hostname`][`date +%Y-%m-%d_%H%M:%S`]执行参数输入错误!"
	exit 1
fi
exit 0