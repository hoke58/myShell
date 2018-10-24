#!/bin/sh
######################脚本注释#############################
# 文件名： BTFO2_AP_SERVICE.sh                            #
# 功  能： BTFO2服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180523"               #修改时间
DEPLOY_UNION="BTFO2_AP"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"          #编写人邮箱
###########################################################
CONF_FILE=/home/ap/blockchain/supervisor/supervisord.conf
para1=$1
APP_NAMES=hbcc_cloud

if [ "${para1}" == "start" ];then
	origin_state=`supervisorctl -c ${CONF_FILE} status|grep $APP_NAMES |awk '{print $2}'`
	echo "-------------------------------------------------------------------------------------------------"
	if [ $origin_state == "RUNNING" ]; then
		echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: The ${APP_NAMES}应用 is started!Please check it"
		echo "-------------------------------------------------------------------------------------------------"
		exit 1
	else
		supervisorctl -c ${CONF_FILE} start ${APP_NAMES}
		for (( i = 1; i <= 10; i++ )) do echo -n "."; sleep 1; done
		echo ""
		state=`supervisorctl -c ${CONF_FILE} status|grep $APP_NAMES |awk '{print $2}'`
		if [ "${state}" != "RUNNING" ];then
			echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]${APP_NAMES}应用状态:"${state}",启动失败"
			exit 1
		else
			echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]${APP_NAMES}应用状态:"${state}",启动成功"
		fi
	fi
	echo "-------------------------------------------------------------------------------------------------"
elif [ "${para1}" == "stop" ];then
	origin_state=`supervisorctl -c ${CONF_FILE} status|grep $APP_NAMES |awk '{print $2}'`
	echo "-------------------------------------------------------------------------------------------------"
	if [ $origin_state == "STOPPED" ];then
		echo "[`date +%Y-%m-%d_%H:%M:%S`]WARNING: ${APP_NAMES}应用 is STOPPED! Please check it"
		echo "-------------------------------------------------------------------------------------------------"
		exit 1
	else
		supervisorctl -c ${CONF_FILE} stop ${APP_NAMES}
		for (( i = 1; i <= 5; i++ )) do echo -n "."; sleep 1; done
		echo ""
		state=`supervisorctl -c ${CONF_FILE} status|grep $APP_NAMES |awk '{print $2}'`
		if [ "${state}" != "STOPPED" ];then
			echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]应用状态:"${state}",停止失败"
			exit 1
		else
			echo "INFO:[`hostname`][`date +%Y-%m-%d_%H%M:%S`]应用状态:"${state}",停止成功"
		fi
	fi
	echo "-------------------------------------------------------------------------------------------------"
elif [ "${para1}" == "status" ];then
	echo "-------------------------------------------------------------------------------------------------"
	supervisorctl -c ${CONF_FILE} status 
	echo "-------------------------------------------------------------------------------------------------"
fi
exit 0
