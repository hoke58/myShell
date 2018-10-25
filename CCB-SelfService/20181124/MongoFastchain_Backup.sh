#!/bin/sh
######################脚本注释#############################
# 文件名： BTFO3_AP_BACKUP.sh                            #
# 功  能： BTFO3数据库备份脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180827"               #修改时间
DEPLOY_UNION="BTFO3"                   #部署单元
EDITER_MAIL="wuji.zh@ccb.com"          #编写人邮箱
###########################################################
v_process=`ps -ef|grep -i mongod|grep -v "grep"|awk '{print $2}'`
BACK_PATH=/home/ap/blockchain/app-pkg/_backup
if [ "$1" == "backup" ];then
    echo "----------------------------------------------------------------------"
    if [ -z ${v_process} ];then
	echo "WARNING: The mongo_replica daemon is down!Please check it"
	echo "----------------------------------------------------------------------"
	exit 1
    else
	mongodump  --port 27010 --out $BACK_PATH/backup_$(date +%Y%m%d%H%M%S) --username=root --password=ccb@#Hope123
	state=`du -sh $BACK_PATH/backup_* | awk '{print $1}'`
        if [ ${state} ];then
	    echo "Mongodb backup successful!"
        else
            echo "WARNING: Mongodb backup failed!"
        fi
    fi
        echo "----------------------------------------------------------------------"
elif [ "$1" == "restore" ];then
    echo "------------------------------------------------------------------------------"
    if [! -n ${v_process} ];then
        echo "WARNING: The mongos process is'n exist! DB restore failed!"
        echo "------------------------------------------------------------------------------"
        exit 1  
    else
        mongorestore $BACK_PATH/backup_$(date +%Y%m%d) --port 27010 --username=root --password=ccb@#Hope123
        echo "INFO: Mongodb restored successful!"
        echo "------------------------------------------------------------------------------"
    fi
fi
