#!/bin/bash
######################脚本注释#############################
# 文件名： update_before_dist.sh[版本发布前-执行脚本]     #
# 功  能： mongodump specific collections, Oracle dump    #
# 作  者： Hoke                                           #
# 时  间： 20200402                                       #
# 单  元： BTFN7_AP, BTFL1_AP                   #
# 数据库： 文件存储服务只能在Mongo-routers[BTFN7_AP]的第  #
#          1台[by18btfn7ap1001]执行，Oracle只能在         #
#          [BTFL1_AP]的第1台[by18btfl1ap1001]执行         #
###########################################################

DATETIME=`date +%Y%m%d%H`
MYNAME=${0##*/}
MODE=$2
##### permission modify ######
BACK_PATH=$HOME/app-pkg/_backup
MONGO_USER="mongouser"
MONGO_PW="mongouser123"
MONGO_DB="mongo"
MONGO_COLLECTIONS=(
hbcc_cloud_organization
hbcc_cloud_Safebox
hbcc_cloud_api_token
)
################################

Help(){
    cat <<EOL
提示:
  1. 数据库备份路径： $BACK_PATH;

  2. 文件存储服务在Mongo-routers[BTFN7_AP]的第1台[by18btfn7ap1001]执行;

  3. Oracle只能在[BTFL1_AP]的第1台[by18btfl1ap1001]执行

用法: $MYNAME [选项]...

选项:
  -m, --mongo           MongoDB 备份或恢复
  -o, --oracle          备份OracleDB
  -h, --help            显示帮助信息并退出

错误码：
  0  正常
  1  命令参数错误
  2  备份文件失败
EOL
}

Oracle(){
#sqlplus bcrh/bcrh#2014@11.161.173.67:1521/btfljpd0
Oruser=bcrh
Orpass=bcrh#2014
Orsid=11.161.173.67:1521/btfljpd0
exp $Oruser/$Orpass@$Orsid grants=y owner=$Oruser file=$BACK_PATH/BC_OracleBak_$DATETIME.dmp log=$BACK_PATH/BC_OracleBak_$DATETIME.log
tar zcvf $BACK_PATH/BC_OracleBak_$DATETIME.tgz -C $BACK_PATH BC_OracleBak_$DATETIME.dmp
if [ -s "$BACK_PATH/BC_OracleBak_$DATETIME.tgz" ]; then
    echo "================== INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Oracle备份成功 =================="
    echo
    exit 0
else
    echo "================== ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Oracle备份失败 =================="
    exit 2
fi
}

MongoDB(){
    v_process=`ps -ef|grep -i mongos | grep -v "grep" | awk '{print $2}'`
    mongo_port=`netstat -lntp|grep $v_process | awk -F ':' '{print $2}' | awk '{print $1}'`
    if [ -z ${v_process} ]; then
        echo "----------------------------------------------------------------------"
        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]The MongoDB process is'n exist! DB backup failed!"
        echo "----------------------------------------------------------------------"
        exit 1
    fi
    if [ $MODE == "backup" ]; then
        for i in ${MONGO_COLLECTIONS[@]}; do
        mongodump --port $mongo_port --username=$MONGO_USER --password=$MONGO_PW --archive=$BACK_PATH/$i-$DATETIME.tgz --gzip --db=$MONGO_DB --collection=$i
        [ $? -eq 0 ] || exit 2
        done
    elif [ $MODE == "restore" ]; then
        for i in ${MONGO_COLLECTIONS[@]}; do
        mongorestore --port $mongo_port --username=$MONGO_USER --password=$MONGO_PW --archive=$BACK_PATH/$i-$DATETIME.tgz --gzip --db=$MONGO_DB
        [ $? -eq 0 ] || exit 2
        done
    fi
}
mkdir -p $BACK_PATH
LONGOPTS="mongo,oracle,help"
CMD=$(getopt -o moh --long $LONGOPTS -n "$myname" -- "$@") || exit 1

eval set -- "$CMD"

while true; do
    case "$1" in
        -m|--mongo|--MONGO)
        MongoDB
        shift  
        ;;
        --ORACLE|--oralce|-o)
        if [ "$hostname" = "by18btfl1ap1001" ]; then
            Oracle
        else
            echo "-------------------------------------------------------------------------------------------------"
            echo "WARN:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]Oracle请在[BTFL1_AP]的第1台[by18btfl1ap1001]上执行!"
            echo "-------------------------------------------------------------------------------------------------"
            exit 1
        fi
        ;;
        -h|--help)
        Help
        exit 0
        shift
        ;;
        --)
        shift
        break
    esac
done