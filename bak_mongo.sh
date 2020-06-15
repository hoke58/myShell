#!/bin/bash

# 区块链生产环境 mongodb backup

export PATH=/home/blockchain/mongodb/bin:$PATH
current_time=$(date '+%Y%m%d')T$(date '+%H')
# 要备份的数据库名，多个数据库用空格分开
databases=(mongo mongocloud)
mongo_bakuser=mongouser
mongo_bakpw=mongouser123
# 备份文件要保存的目录
#org1_bakpath=/org01nas/${current_time}
org11_bakpath=/org11nas/${current_time}
org12_bakpath=/org12nas/${current_time}
org11_url=172.16.11.12:27017
org12_url=172.16.12.12:27017

BakMongo(){
if [ ! -d ${bakpath} ]; then
    mkdir -p $bakpath
fi
cd $bakpath

for db in ${databases[*]}; do
    mongodump  -h $url -d $db --out $bakpath -u $mongo_bakuser -p $mongo_bakpw
    nice -n 19 tar zcfv ${db}.tgz $db
    rm -rf $bakpath/$db
done
find $bakpath -mtime +14 -type d -user blockchain -exec rm -rf {} \;
}

if [ $1 -eq 11 ]; then
    bakpath=$org11_bakpath
    url=$org11_url
elif [ $1 -eq 12 ]; then    
    bakpath=$org12_bakpath
    url=$org12_url
else
    echo Error: 入参错误
    exit 1
fi
BakMongo