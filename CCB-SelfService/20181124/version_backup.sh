#!/bin/sh
######################脚本注释#############################
# 文件名： version_backup.sh[版本备份]                    #
# 功  能： 备份前后端版本                                 #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元：  BTFL3_AP、BTFWB                               #
###########################################################
BACK_PATH=/home/ap/blockchain/app-pkg/_backup
APP_PATH=/home/ap/blockchain
WORK_PATH=$APP_PATH/$1
: ${WORK_PATH:=$APP_PATH}
case $1 in
    forfaiting_portal | factor_portal | xyz_portal | hbcc_cloud)
        tar zcvf $BACK_PATH/$1$(date +%m%d%H%M).tgz $APP_PATH/$1
        ;;
    ng_xyz | ng_forfaiting | ng_factor)
        echo $1
        tar zcvf $BACK_PATH/$1$(date +%m%d%H%M).tgz $APP_PATH/$1
        ;;
    *)
        tar zcvf $BACK_PATH/$(date +%m%d%H%M).tgz $WORK_PATH
esac
if [ -f ${BACK_PATH}/$1$(date +%m%d%H)*.tgz ];then
    echo "----------------------------------------------------------------------"
    echo "INFO:${1}已备份成功！"
    echo "----------------------------------------------------------------------"
    exit 0
else
    echo "----------------------------------------------------------------------"
    echo "ERROR:${1}备份失败！"
    echo "----------------------------------------------------------------------"
    exit 1
fi
