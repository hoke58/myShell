#!/bin/sh
######################脚本注释#############################
# 文件名： version_backup.sh[版本备份]                    #
# 功  能： 版本备份                                       #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元： ALL                                            #
# 数据库： 文件存储服务只能在Mongo-routers[BTFN7_AP]的第  #
#          1台[by18btfn7ap1001]执行，Oracle只能在         #
#          [BTFL1_AP]的第1台[by18btfl1ap1001]执行         #
###########################################################
BACK_PATH=$HOME/app-pkg/_backup
DEPLOY_UNIT=$1
DATETIME=`date +%Y%m%d%H`

verifyResult() {
if [ $1 -ne 0 ]; then
    echo "================== ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]"$2"备份脚本执行失败 =================="
    echo
    exit 1
else
    echo "================== INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]"$2"备份脚本执行成功 =================="
    exit 0
fi
}

Archived() {
for i in $Archived_LIST; do
#    echo $i
    tar zcvf $BACK_PATH/$i-$DATETIME.tgz -C $HOME $i ;
#    echo "${BACK_PATH}/${i}-$DATETIME.tgz"
    if [ -f "${BACK_PATH}/$i-$DATETIME.tgz" ]; then
        echo "================== INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]"$i"备份成功 =================="
        echo
    else
        echo "================== ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]"$i"备份失败 =================="
        exit 1
    fi
done
}

Monggo_Cert(){
echo "-------------------------------------------------------------------------------------------------"
echo "WARN:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]文件存储服备份请在[BTFN7_AP]的第1台[by18btfn7ap1001]上执行!"
echo "-------------------------------------------------------------------------------------------------"
exit 1
}

Temp(){
echo "-------------------------------------------------------------------------------------------------"
echo "INFO:未在变更范围或无需备份"
echo "-------------------------------------------------------------------------------------------------"
}

Oracle(){
#sqlplus bcrh/bcrh#2014@11.161.173.67:1521/btfljpd0
Oruser=bcrh
Orpass=bcrh#2014
Orsid=11.161.173.67:1521/btfljpd0
exp $Oruser/$Orpass@$Orsid grants=y owner=$Oruser file=$BACK_PATH/BC_OracleBak_$DATETIME.dmp log=$BACK_PATH/BC_OracleBak_$DATETIME.log
tar zcvf $BACK_PATH/BC_OracleBak_$DATETIME.tgz -C $BACK_PATH BC_OracleBak_$DATETIME.dmp
if [ -f "$BACK_PATH/BC_OracleBak_$DATETIME.tgz" ]; then
    echo "================== INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Oracle备份成功 =================="
    echo
    exit 0
else
    echo "================== ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Oracle备份失败 =================="
    exit 1
fi
}

if [ ! $DEPLOY_UNIT ];then
    echo "-------------------------------------------------------------------------------------------------"
    echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]请输入备份单元名称     eg: ./version_backup.sh BTFL3"
    echo "-------------------------------------------------------------------------------------------------"
    exit 1
else
    case $DEPLOY_UNIT in
        BTFL3_AP|BTFL3|btfl3)
        Archived_LIST="forfaiting_portal factor_portal xyz_portal plugin"
        Archived
        res=$?
        verifyResult $res "金融应用服务"
        ;;
        BTFN1_AP|BTFN1|btfn1)
        Temp
        res=$?
        verifyResult $res "区块链队列"
        ;;
        BTFN2_AP|BTFN2|btfn2)
        Temp
        res=$?
        verifyResult $res "区块链排序"
        ;;
        BTFN3_AP|BTFN3|btfn3)
        Temp
        res=$?
        verifyResult $res "区块链对等"
        ;;
        BTFN4_AP|BTFN4|btfn4)
        Temp
        res=$?
        verifyResult $res "区块链仲裁"
        ;;
        BTFN5_AP|BTFN5|btfn5)
        # "Mong-shard1"
        Monggo_Cert
        ;;
        BTFN6_AP|BTFN6|btfn6)
        # "Mongo-config"
        Monggo_Cert
        ;;
        BTFN7_AP|BTFN7|btfn7)
        if [ "$hostname" = "by18btfn7ap1001" ]; then
            sh ./MongoCert_Backup.sh backup
            res=$?
            verifyResult $res "Mongo-router"
        else
            Monggo_Cert
        fi
        ;;
        BTFN8_AP|BTFN8|btfn8)
        # "Mongo-shard2"
        Monggo_Cert
        ;;
        BTFN9_AP|BTFN9|btfn9)
        # "Mongo-shard3"
        Monggo_Cert
        ;;
        BTFO1_AP|BTFO1|btfo1)
        Temp
        res=$?
        verifyResult $res "区块链API"
        ;;
        BTFO2_AP|BTFO2|btfo2)
        Archived_LIST="hbcc_cloud hbcc_processers hbcc_agent"
        Archived
        res=$?
        verifyResult $res "电子保险箱"
        ;;
        BTFO3_AP|BTFO3|btfo3)
        Temp
        res=$?
        verifyResult $res "链块加速"
        ;;
        BTFO4_AP|BTFO4|btfo4)
        Temp
        res=$?
        verifyResult $res "缓存"
        ;;
        BTFO5_AP|BTFO5|btfo5)
        Temp
        res=$?
        verifyResult $res "RabbitMQ"
        ;;
        BTFWB_AP|BTFWB|btfwb)
        Archived_LIST="ng_xyz ng_forfaiting ng_factor"
        Archived
        res=$?
        verifyResult $res "Nginx"
        ;;
        BTFX1_WB|BTFX1|btfx1)
        Temp
        res=$?
        verifyResult $res "外网HAPROXY"
        ;;
        BTFX2_WB|BTFX2|btfx2)
        Temp
        res=$?
        verifyResult $res "内网HAPROXY"
        ;;
        ORACLE|oralce)
        if [ "$hostname" = "by18btfl1ap1001" ]; then
            Oracle
        else
            echo "-------------------------------------------------------------------------------------------------"
            echo "WARN:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Oracle请在[BTFL1_AP]的第1台[by18btfl1ap1001]上执行!"
            echo "-------------------------------------------------------------------------------------------------"
            exit 1
        fi
        ;;
        *)
        echo "-------------------------------------------------------------------------------------------------"
        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]参数无效，请正确输入应用单元名称     eg: ./version_backup.sh BTFL3"
        echo "-------------------------------------------------------------------------------------------------"
        exit 1
    esac
fi
