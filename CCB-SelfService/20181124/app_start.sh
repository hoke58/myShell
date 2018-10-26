#!/bin/sh
######################脚本注释#############################
# 文件名： app_start.sh[应用启动]                         #
# 功  能： 检查应用进程是否正常                           #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元： ALL                                            #
###########################################################
BASH_PATH=$HOME/bin/usr
DEPLOY_UNIT=$1

verifyResult() {
if [ $1 -ne 0 ]; then
    echo "================== ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]"$2"启动失败 =================="
    echo
    exit 1
fi
}

if [ ! $DEPLOY_UNIT ];then
    bash ${BASH_PATH}/BTF[L-N,O,W,X]*_SERVICE.sh start
    res=$?
    verifyResult $res "服务"
    echo "----------------------------------------------------------------------"
    echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]应用启动脚本运行成功"
    echo "----------------------------------------------------------------------"
    exit 0
else
    case $DEPLOY_UNIT in
        BTFL3_AP|BTFL3|btfl3)
        bash ${BASH_PATH}/BTFL3_AP_SERVICE.sh start
        res=$?
        verifyResult $res "金融应用服务"
        ;;
        BTFN1_AP|BTFN1|btfn1)
        bash ${BASH_PATH}/BTFN1_AP_SERVICE.sh start
        res=$?
        verifyResult $res "区块链队列"
        ;;
        BTFN2_AP|BTFN2|btfn2)
        bash ${BASH_PATH}/BTFN2_AP_SERVICE.sh start
        res=$?
        verifyResult $res "区块链排序"
        ;;
        BTFN3_AP|BTFN3|btfn3)
        bash ${BASH_PATH}/BTFN3_AP_SERVICE.sh start
        res=$?
        verifyResult $res "区块链对等"
        ;;
        BTFN4_AP|BTFN4|btfn4)
        bash ${BASH_PATH}/BTFN4_AP_SERVICE.sh start
        res=$?
        verifyResult $res "区块链仲裁"
        ;;
        BTFN5_AP|BTFN5|btfn5)
        bash ${BASH_PATH}/BTFN5_AP_SERVICE.sh start
        res=$?
        verifyResult $res "Mong-shard1"
        ;;
        BTFN6_AP|BTFN6|btfn6)
        bash ${BASH_PATH}/BTFN6_AP_SERVICE.sh start
        res=$?
        verifyResult $res "Mongo-config"
        ;;
        BTFN7_AP|BTFN7|btfn7)
        bash ${BASH_PATH}/BTFN7_AP_SERVICE.sh start
        res=$?
        verifyResult $res "Mongo-router"
        ;;
        BTFN8_AP|BTFN8|btfn8)
        bash ${BASH_PATH}/BTFN8_AP_SERVICE.sh start
        res=$?
        verifyResult $res "Mongo-shard2"
        ;;
        BTFN9_AP|BTFN9|btfn9)
        bash ${BASH_PATH}/BTFN9_AP_SERVICE.sh start
        res=$?
        verifyResult $res "Mongo-shard3"
        ;;
        BTFO1_AP|BTFO1|btfo1)
        bash ${BASH_PATH}/BTFO1_AP_SERVICE.sh start
        res=$?
        verifyResult $res "区块链API"
        ;;
        BTFO2_AP|BTFO2|btfo2)
        bash ${BASH_PATH}/BTFO2_AP_SERVICE.sh start
        res=$?
        verifyResult $res "电子保险箱"
        ;;
        BTFO3_AP|BTFO3|btfo3)
        bash ${BASH_PATH}/BTFO3_AP_SERVICE.sh start
        res=$?
        verifyResult $res "链块加速"
        ;;
        BTFO4_AP|BTFO4|btfo4)
        bash ${BASH_PATH}/BTFO4_AP_SERVICE.sh start
        res=$?
        verifyResult $res "缓存"
        ;;
        BTFO5_AP|BTFO5|btfo5)
        bash ${BASH_PATH}/BTFO5_AP_SERVICE.sh start
        res=$?
        verifyResult $res "RabbitMQ"
        ;;
        BTFWB_AP|BTFWB|btfwb)
        bash ${BASH_PATH}/BTFWB_AP_SERVICE.sh start
        res=$?
        verifyResult $res "Nginx"
        ;;
        BTFX1_WB|BTFX1|btfx1)
        bash ${BASH_PATH}/BTFX1_WB_SERVICE.sh start
        res=$?
        verifyResult $res "外网HAPROXY"
        ;;
        BTFX2_WB|BTFX2|btfx2)
        bash ${BASH_PATH}/BTFX2_WB_SERVICE.sh start
        res=$?
        verifyResult $res "内网HAPROXY"
        ;;
        *)
        echo "-------------------------------------------------------------------------------------------------"
        echo "Invalid arguments 请正确输入应用单元名称     eg: ./app_start.sh BTFL3"
        echo "-------------------------------------------------------------------------------------------------"
        exit 1
    esac
    echo "----------------------------------------------------------------------"
    echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]"$2"应用启动脚本运行成功"
    echo "----------------------------------------------------------------------"
    exit 0
fi