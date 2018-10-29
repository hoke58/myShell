#!/bin/bash
######################脚本注释#############################
# 文件名： update_before_start.sh[应用启动前]             #
# 功  能： rabbitmq设置mirror策略                         #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元： BTFO5_AP[仅主机: by18btfo5ap1001 上执行]       #
###########################################################
mq_container=`docker ps -aq -f name=mq`

# Set Check shell
policy_check=`docker exec ${mq_container} rabbitmqctl list_policies | awk 'NR>1 {print $2}'`

check_messages(){
if [ `docker exec ${mq_container} rabbitmqctl list_queues messages | sed -n '/[1-9]/p' | wc -l` -ne 0 ]; then
    echo "-------------------------------------------------------------------------------------------------"
    echo "WARN: [`hostname`][`date +%Y-%m-%d_%H:%M:%S`]MQ 队列中有拥塞消息，请人工介入"
    echo "-------------------------------------------------------------------------------------------------"
    exit 1
fi
}

if [ "$policy_check" = "ha-all" ]; then
    echo "-------------------------------------------------------------------------------------------------"
    echo "WARN: [`hostname`][`date +%Y-%m-%d_%H:%M:%S`]RabbitMQ mirror-policy has been set [ha-all], nothing to do."
    echo "-------------------------------------------------------------------------------------------------"
    exit 1
else
    check_messages
    docker exec ${mq_container} rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'
    echo "-------------------------------------------------------------------------------------------------"
    echo "IFNO: [`hostname`][`date +%Y-%m-%d_%H:%M:%S`]RabbitMQ mirror-policy has been set successfully."
    echo "-------------------------------------------------------------------------------------------------"
    exit 0
fi