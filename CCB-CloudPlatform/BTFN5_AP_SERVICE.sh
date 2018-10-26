#!/bin/sh
######################脚本注释#############################
# 文件名： BTFN5_AP_SERVICE.sh                            #
# 功  能： BTFN5服务起停脚本                              #
###########################################################
VERSION="1"                            #版本号
MODIFIED_TIME="20180523"               #修改时间
DEPLOY_UNION="BTFN5"                #部署单元
EDITER_MAIL="wuji.zh@ccb.com"   #编写人邮箱
###########################################################
v_process=`ps -ef|grep -i mongod|grep -v "grep"|awk '{print $2}'`
MONGO_REPLICA_CFG_PATH=$HOME/mongodb/conf/sharding-shard001.conf
PRIMARY_NODE=`mongo --port 17010 --authenticationDatabase=admin --quiet --eval 'rs.isMaster().ismaster'`
SECONDARY1=`mongo --port 17010 --username=root --password=ccb@#Hope123 --authenticationDatabase=admin --eval 'rs.status().members[1].health'|awk 'NR==4 {print $0}'`
SECONDARY2=`mongo --port 17010 --username=root --password=ccb@#Hope123 --authenticationDatabase=admin --eval 'rs.status().members[2].health'|awk 'NR==4 {print $0}'`

kill_process() {
    kill -2 ${v_process}
    sleep 3
    state=`ps -ef|grep -i mongod|grep -v "grep"|awk '{print $2}'`
    if [ ${state} ];then
        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MONGO_REPLICA_PROCESS进程:${state},停止失败"
        exit 1
    else
        echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MONGO_REPLICA_PROCESS进程:${v_process},停止成功"
    fi
}

if [ "$1" == "start" ];then
        echo "----------------------------------------------------------------------"
        if [ ${v_process} ];then
                echo "WARNING: The mongo_replica daemon is started!Please check it"
                echo "----------------------------------------------------------------------"
                exit 1
        else
                mongod -f $MONGO_REPLICA_CFG_PATH
                state=`ps -ef|grep -i mongod|grep -v "grep"|awk '{print $2}'`
                echo "### 显示 mongo replica process ###"
                echo "MONGO_REPLICA_PROCESS: [${state}]"
                if [ ! -n ${state} ];then
                        echo "ERROR:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MONGO_REPLICA_PROCESS进程:${state},启动失败"
                        exit 1
                else
                        echo "INFO:[`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MONGO_REPLICA_PROCESS进程:${state},启动成功"
                fi
        fi
        echo "----------------------------------------------------------------------"
elif [ "$1" == "stop" ];then
        echo "------------------------------------------------------------------------------"
        if [ -z ${v_process} ];then
            echo "WARNING: The mongo replica daemon don't exist!"
            echo "------------------------------------------------------------------------------"
            exit 1
        else
            if [ "$PRIMARY_NODE" == "false" ];then
                kill_process
            else
                if [ "${SECONDARY1}" -o "${SECONDARY2}" == "1" ];then
                    echo "WARNING:The 'SECONDARY' is running! Please stop it first!"
                    echo "------------------------------------------------------------------------------"
                    exit 1
                else
                    kill_process
                fi
            fi
        fi
        echo "------------------------------------------------------------------------------"
fi
exit 0
