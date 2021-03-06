#!/bin/bash
process=`ps -ef | grep -i forfaiting-service-ws | grep -v "grep" | awk '{print $2}'`
apphome="/home/blockchain/forfaiting_portal/forfaiting-service-ws"
jarname="forfaiting-service-ws-*.jar"
#rootpath="/data/app/forfaiting-service-ws/"
file="${apphome}/etc/tmp/pid"
if [ "$1" = "start" ];then
{
  if [ "${process}" != ""  ];then
  {
#    file="${rootpath}etc/tmp/pid"
    pid=$(cat ${file})
    echo "-----The process is running! PID:${pid}-----"
  }
  else
  {
  cd ${apphome}/bin/
  java -Droot.path=${apphome}/ -Djava.ext.dirs=${apphome}/lib -cp ${apphome}/lib/${jarname} com.hoperun.qkl.fft.ws.Launcher >/dev/null 2>&1 &  
  time=15
  i=1
  while [[ ! -f "${apphome}/logs/fft.log" ]] && [[ "$i" -ne "$time" ]]
  do
	let "i++"
    sleep 1
  done
  tail -f ${apphome}/logs/fft.log
  }
  fi
  }
elif [ "$1" = "stop" ];then
{
  if [[ -f ${file} ]] && [[ "${process}" != "" ]];then
  {
    pid=$(cat ${file})
    echo "-----Shuting Down! PID:${pid}-----"
    kill -9 ${pid}
    rm -rf ${file}
    process2=`ps -ef | grep -i forfaiting-service-ws | grep -v "grep" | awk '{print $2}'`
    if [ "${process2}" != "" ];then
    {
      kill -9 ${process2}
      echo "-----Shuting down extra processes!-----"
    }
    fi
    echo "-----Successful-----"
  }
  else
    echo "-----The program is not running!-----"
  fi
}
else
  echo "-----Please add parameter 'start' or 'stop'-----"
fi