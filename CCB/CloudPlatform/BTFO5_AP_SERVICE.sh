#!/bin/sh
######################脚本注释#############################
# 文件名： BTFO5_AP_SERVICE.sh                            #
# 功  能： BTFO5_AP服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180521"               #修改时间
DEPLOY_UNION="BTFO5_AP"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"          #编写人邮箱
###########################################################
CONTAINER_NAME=rabbitmq
CONTAINER_STATUS=`docker ps -a -f name=${CONTAINER_NAME} | awk 'NR==2 {print $7}'`

para1=$1
if [ "${para1}" = "start" ]; then
	if [ $CONTAINER_STATUS == 'Exited' ]; then
		docker start `docker ps -aq -f name=${CONTAINER_NAME}` >/dev/null 2>&1
		for (( i = 1; i <= 5; i++ )) do echo -n "."; sleep 1; done
		echo ""
		echo "----------------------------------------------------------------------"
		echo "显示Rabbitmq状态"
		cnt=`docker ps -q -f name=${CONTAINER_NAME} | wc -l`
		if [ $cnt -ne 1 ];then
			echo "ERROR: [`hostname`][`date +%Y-%m-%d_%H%:M:%S`]显示Rabbitmq状态[${cnt}],启动失败!"
			exit 1
		else
			echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]显示Rabbitmq状态[${cnt}],启动成功"
		fi
	else
		echo "WARNING:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]已经有一个Rabbitmq容器启动，请检查"
	fi
	echo "------------------------------------------------------------------------------"
elif [ "${para1}" == "stop" ]; then
	if [ $CONTAINER_STATUS != 'Exited' ]; then
		docker stop `docker ps -aq -f name=${CONTAINER_NAME}` >/dev/null 2>&1
		for (( i = 1; i <= 3; i++ )) do echo -n "."; sleep 1; done
		echo ""
		echo "----------------------------------------------------------------------"
		echo "显示Rabbitmq状态"
		cnt=`docker ps -q -f name=${CONTAINER_NAME} | wc -l`
		if [ $cnt -ne 0 ];then
			echo "ERROR: [`hostname`][`date +%Y-%m-%d_%H:%M:%S`]显示Rabbitmq状态[${cnt}],停止失败!"
			exit 1
		else
			echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]显示Rabbitmq状态[${cnt}],停止成功"
		fi
	else
		echo "----------------------------------------------------------------------"
		echo "WARNING:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Rabbitmq容器状态异常，请检查"
	fi
	echo "------------------------------------------------------------------------------"
elif [ "${para1}" == "status" ]; then
	echo "----------------------------------------------------------------------"
	echo "显示Rabbitmq状态"
	if [ $CONTAINER_STATUS == 'Exited' ]; then
		echo "ERROR: [`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Rabbitmq状态显示[${CONTAINER_STATUS}]!"
		exit 1
	else
		echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Rabbitmq状态显示[${CONTAINER_STATUS}]!"
	fi
	echo "------------------------------------------------------------------------------"
else
	echo "ERROR: [`hostname`][`date +%Y-%m-%d_%H%M:%S`]执行参数输入错误!"
	exit 1
fi
exit 0