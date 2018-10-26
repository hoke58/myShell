#!/bin/sh
######################脚本注释#############################
# 文件名： BTFX2_WB_SERVICE.sh                            #
# 功  能： BTFX2服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180517"               #修改时间
DEPLOY_UNION="BTFX2_WB"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"   #编写人邮箱
###########################################################
v_process=`ps -ef|grep -i haproxy.pid|grep -v "grep"|awk '{print $2}'`
HAPROXY_CFG_PATH=/etc/haproxy/haproxy.cfg
HAPROXY_PID_PATH=$HOME/haproxy/haproxy.pid

if [ "$1" == "start" ];then
	echo "----------------------------------------------------------------------"
	if [ ${v_process} ];then
		echo "WARNING: The haproxy daemon is started!Please check it"
		echo "----------------------------------------------------------------------"
		exit 1
	else
		haproxy -f $HAPROXY_CFG_PATH -p $HAPROXY_PID_PATH
		state=`ps -ef|grep -i haproxy.pid | grep -v "grep" | awk '{print $2}' | wc -l`
		echo "### 显示 haproxy process ###"
		echo "HAPROXY_PROCESS: [${state}]"
		if [ ${state} -ne 1 ];then
			echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]HAPROXY_PROCESS进程[${state}],启动失败"
			exit 1
		else
			echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]HAPROXY_PROCESS进程[${state}],启动成功"
		fi
	fi
	echo "----------------------------------------------------------------------"
elif [ "$1" == "stop" ];then
	echo "------------------------------------------------------------------------------"
	if [ -z ${v_process} ];then
                echo "WARNING: The haproxy daemon don't exist!"
		echo "------------------------------------------------------------------------------"
                exit 1
	else
		kill -15 ${v_process}
		state=`ps -ef|grep -i haproxy.pid|grep -v "grep"|awk '{print $2}' |wc -l`
		if [ ${state} -ne 0 ];then
			echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]HAPROXY_PROCESS进程[${state}],停止失败"
			exit 1
		else
			echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]HAPROXY_PROCESS进程[${state}],停止成功"
		fi
	fi
	echo "------------------------------------------------------------------------------"
fi
exit 0