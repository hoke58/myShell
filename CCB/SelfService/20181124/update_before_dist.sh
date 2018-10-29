#!/bin/bash
######################脚本注释#############################
# 文件名： update_before_dist.sh[版本发布前-执行脚本]     #
# 功  能： MongoDB备份, Oracle备份                        #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元： BTFN7_AP, BTFO3_AP, BTFL1_AP                   #
# 数据库： 文件存储服务只能在Mongo-routers[BTFN7_AP]的第  #
#          1台[by18btfn7ap1001]执行，Oracle只能在         #
#          [BTFL1_AP]的第1台[by18btfl1ap1001]执行         #
###########################################################

BACK_PATH=$HOME/app-pkg/_backup
DATETIME=`date +%Y%m%d%H`
MYNAME=${0##*/}

Monggo_Cert(){
echo "-------------------------------------------------------------------------------------------------"
echo "WARN:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]文件存储服备份请在[BTFN7_AP]的第1台[by18btfn7ap1001]上执行!"
echo "-------------------------------------------------------------------------------------------------"
exit 1
}

Help(){
    cat <<EOL
提示:
  1. 数据库备份路径： $BACK_PATH;

  2. 文件存储服务只能在Mongo-routers[BTFN7_AP]的第1台[by18btfn7ap1001]执行;

  3. Oracle只能在[BTFL1_AP]的第1台[by18btfl1ap1001]执行

用法: $MYNAME [选项]...

选项:
  -m, --mongo           备份MongoDB
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
    v_process=`ps -ef|grep -i mongo | grep -v "grep" | awk '{print $2}'`
    mongo_port=`netstat -lntp|grep $v_process | awk -F ':' '{print $2}' | awk '{print $1}'`
    mongo_pw="ccb@#Hope123"
    if [ -z ${v_process} ];then
        echo "----------------------------------------------------------------------"
        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]The MongoDB process is'n exist! DB backup failed!"
        echo "----------------------------------------------------------------------"
        exit 1
    else
        mongodump --port $mongo_port --out $BACK_PATH/MongoBak_$DATETIME --username=root --password=$mongo_pw
        if [ -d $BACK_PATH/MongoBak_$DATETIME ]; then
            tar zcvf $BACK_PATH/MongoBak_$DATETIME.tgz -C $BACK_PATH MongoBak_$DATETIME
            #\rm -rf $BACK_PATH/MongoBak_$DATETIME
            echo "================== INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MongoDB备份成功 =================="
            echo
            exit 0
        else
            echo "================== ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MongoDB备份失败 =================="
            exit 1
        fi
    fi
}

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