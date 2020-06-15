#!/bin/bash
NginxPath=/home/blockchain/nginx
HomePath=/home/blockchain/
dateTime=$(date +%Y%m%d)

backupNginx() {
cd $HomePath
mkdir -p backup/$dateTime
mv $NginxPath/conf/nginx.conf $HomePath/backup/$dateTime
mv $NginxPath/conf/vhost $HomePath/backup/$dateTime
}

updateNginxConf() {
cd $HomePath
#tar xvf nginxconf.tar
mv nginxconf/nginx.conf $NginxPath/conf/
mv nginxconf/vhost $NginxPath/conf/
}

testNginx() {
cd $NginxPath/sbin/
resault=$(./nginx -t)
if ${resault#successful};then
    reloadNginx
else
    echo "###ERROR请检查/home/blockchain/nginx/conf/nginx.conf配置文件###"
fi
}

reloadNginx() {
echo '---reload Nginx---'
cd $NginxPath/sbin/
./nginx -s reload
}

rollbakNginx() {
mv $NginxPath/conf/nginx.conf $NginxPath/conf/nginx.conf-bak
mv $NginxPath/conf/vhost $NginxPath/conf/vhost-bak
cp $HomePath/backup/$dateTime/nginx.conf $NginxPath/conf/
cp -r $HomePath/backup/$dateTime/vhost $NginxPath/conf/
testNginx
}

checkport() {
echo "58.49.63.14:15001连通性检查，0为通，非0为不通"
curl -LSs --connect-timeout 3 58.49.63.14:15001 &>/dev/null
echo $?

echo "58.49.63.14:4040连通性检查，0为通，非0为不通"
curl -LSs --connect-timeout 3 58.49.63.14:4040 &>/dev/null
echo $?

echo "10.200.201.127:13022连通性检查，0为通，非0为不通"
curl -LSs --connect-timeout 3 10.200.201.127:13022 &>/dev/null
echo $?
}

startNginx() {
cd $NginxPath/sbin/
./nginx
}

case $1 in 
	test|t)
	testNginx
	;;
	update|up)
	backupNginx
	updateNginxConf
	testNginx
	checkport
	;;
	rollbak|roll)
	rollbakNginx
	checkport
	;;
	check)
	checkport
	;;
	start)
	startNginx
	checkport
	;;
	reload)
	testNginx
	checkport
	;;
	*)
	echo "请输入参数：test（测试配置文件） update（配置升级） rollbak（配置回滚）"
	;;
esac

#echo '---backupNginx---'
#backupNginx
#echo '---updateNginxConf---'
#updateNginxConf
#echo '---testNginx---'
#testNginx
