#!/bin/sh

discovery(){
Queue=(`rabbitmqctl list_queues |grep -v List |awk '{print $1}'`)
len=${#Queue[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$len;i++)); do
    printf '\n\t\t{'
    printf "\"{#MQ_NAME}\":\"${Queue[$i]}\"}"
    if [ $i -lt $[$len-1] ];then
        printf ','
    fi
done
printf  "\n\t]\n"
printf "}\n"
}
messages(){
    QUEUE=sys_xyzQueue
    ROW=`rabbitmqctl list_queues |grep -n $QUEUE  |awk -F : '{print $1}'`
    MESSAGES=`rabbitmqctl list_queues messages |awk 'NR=="'''$ROW'''"{print}'`
    echo $MESSAGES
}
ready(){
    QUEUE=sys_xyzQueue
    ROW=`rabbitmqctl list_queues |grep -n $QUEUE  |awk -F : '{print $1}'`
    READY=`rabbitmqctl list_queues messages_ready |awk 'NR=="'''$ROW'''"{print}'`
    echo $READY
}
 unack(){
    QUEUE=sys_xyzQueue
    ROW=`rabbitmqctl list_queues |grep -n $QUEUE  |awk -F : '{print $1}'`
    UNACK=`rabbitmqctl list_queues  messages_unacknowledged |awk 'NR=="'''$ROW'''"{print}'`
    echo $UNACK
}
 
if [ $1 == "discovery" ]; then
    discovery
elif [ $1 == "messages" ]; then
    messages $2
elif [ $1 == "ready" ]; then
    ready $2
elif [ $1 == "unack" ]; then
    unack $2
fi