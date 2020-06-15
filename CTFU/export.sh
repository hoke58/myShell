#!/bin/bash
######################脚本注释#############################
# 文件名： export.sh                                      #
# 功  能： CTFU数据库导出                                 #
# 作  者： hoke                                           #
# 时  间： 20190328                                       #
###########################################################
cur_dir=`pwd`
current_time=$(date '+%Y%m%d')
export_path=data_export-${current_time}
pgmount=`docker inspect runchain_postgresql |grep  "/bitnami:rw" |awk -F ':' '{print $1}'|awk -F '"' '{print $NF}'`
mongomout=`docker inspect runchain_mongodb |grep ":/opt/mongodb/data"|awk -F ':' '{ print $1 }'|awk -F '"' '{ print $NF }'`

ExportPG(){
if [ -f $pgmount/pgexport.sh ]; then
    rm -rf $pgmount/pgexport.sh
fi
    cat > $pgmount/pgexport.sh<<-EOF
#!/bin/bash
export PGPASSWORD=hbcc_passwd
cd /bitnami
pg_dump hbcc -p 5432 -U postgres -f /bitnami/postgres-export.sql
EOF
chmod +x $pgmount/pgexport.sh
docker exec -i -u root runchain_postgresql chown 1001 /bitnami/pgexport.sh
if [ -f $pgmount/postgres-export.sql ]; then
    rm -rf $pgmount/postgres-export.sql
fi
docker exec -i -u root runchain_postgresql /bitnami/pgexport.sh
}
ExportMongo(){
if [ -d $mongomout/export ]; then
    rm -rf $pgmount/export
fi
mkdir $pgmount/export
docker exec -i runchain_mongodb /opt/mongodb/bin/mongodump --port 27010 -d mongo --out /opt/mongodb/data/export -u mongouser -p mongouser123
sleep 1
docker exec -i runchain_mongodb /opt/mongodb/bin/mongodump --port 27010 -d mongocloud --out /opt/mongodb/data/export -u mongouser -p mongouser123
}
Chown_files(){
uid=$(id -u)
gid=$(id -g)
docker exec -i -u root runchain_postgresql chown $uid:$gid /bitnami
docker exec -i -u root runchain_postgresql chown $uid:$gid /bitnami/postgres-export.sql
docker exec -i -u root runchain_mongodb chown -R $uid:$gid /opt/mongodb/data
}

ExportPG
ExportMongo
Chown_files
if [ ! -d ${export_path} ]; then
    mkdir -p $export_path
fi
mv $pgmount/postgres-export.sql $export_path
mv $mongomout/export $export_path/mongodb