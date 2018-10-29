#!/bin/bash
cat << EOF
# author by hoke
# this script is only for Redhat&CentOS 7 by root
# Redhat&CentOS 7 系统环境标准化
# 字符集 - zh_CN.UTF-8
# 修改时区同步时间 - Asia/Shanghai | 10.10.255.202
# yum仓库 - yum/epel/docker本地源 & makecache
# 安装常用软件包 - vim man中文版
# Selinux - disabled
# firewalld & iptables - stop & remove
# NetworkManager - stop & remove & rm -rf 
# 创建用户及工作目录用户 - user:group & sudo
# 设置文件句柄 & 用户进程
# SSHD - 优化参数，免密
# 标准化vim
# 标准化全局变量
# 优化内核
EOF
#标准化变量
create_workdir="/opt"
basesoft="gcc gcc-c++ ntp lrzsz tree telnet sysstat iptraf  python-devel openssl-devel zlib-devel nmap screen vim bind-utils git unzip man-pages-zh-CN.noarch wget net-tools"
system_user="blockchain"
user_id="1501"
gid="1500"
system_user_password="blockchain@2018"
ssh_port="2222"
ntp_server="10.10.255.202"
public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDIh8JDs7aD3Fb65zAPx8XEcE4bN+PeFltxnB5zEL8x7m2Dq+ByhSCy6rJQFNkSDOcvzFP2zwZkH/gEHHGAbNJfzNU4Su4j5d/eRVD5nlXPpp8eegZgFlqVPNsWZDuy8gfwMhHevCF+0gwXJI0RRuJZuVExAe+fd3EptfcvK45TBw== hoke@Hoke-xps14"

# Set Check shell
system_user_check=`cat /etc/passwd |grep ${system_user} |wc -l`
system_kernel_check=`grep "hoke" /etc/sysctl.conf|wc -l`
system_profile_check=`grep "hoke" /etc/profile|wc -l`

# Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

checkos(){
local result=''
if [[ `cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'` -eq 7 ]] && [[ $EUID -eq 0 ]];then
    result="centos7"
fi
if [ "$result" = "centos7" ]; then
    return 0
else
    return 1
fi
}


#设置字符集
initCN_UTF8(){
    if [ `grep zh_CN.UTF-8 /etc/locale.conf|wc -l` -eq 1 ]; then
    echo -e "当前系统已为中文字符集\n"
else
    \cp /etc/locale.conf /etc/locale.conf.$(date +%F)
    sed -i 's#LANG="en_US.UTF-8"#LANG="zh_CN.UTF-8"#' /etc/locale.conf
    source /etc/locale.conf
    echo -e "${green}[info]: 标准化中文字符集成功${plain}\n"
fi
sleep 1
}

#设置时区同步时间
initTimezone(){
if [ `date -R |grep 0800 |wc -l` -gt 0 ]; then
    echo -e "当前系统时区正确"
else
    rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
fi
ntpdate ${ntp_server} && clock -w >/dev/null 2>&1
if [ `cat  /etc/crontab | grep ntpdate | wc -l` -gt 0 ] ; then
    echo -e "当前系统已设置时间同步服务器\n"
else 
    echo "0 0 * * * root /usr/sbin/ntpdate ${ntp_server}" >> /etc/crontab 
    systemctl restart crond.service
    echo -e "${green}[info]: 标准化时区和时间同步成功${plain}\n"
fi
sleep 1
}

#标准化yum
initYum(){
if [ ! -f "/etc/yum.repos.d/old/CentOS-Base.repo" ];then
    mkdir /etc/yum.repos.d/old && mv /etc/yum.repos.d/C* /etc/yum.repos.d/old/
    \cp /etc/yum.repos.d/old/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
    sed -e 's!^mirrorlist=!#mirrorlist=!g' \
    -e 's!^#baseurl=!baseurl=!g' \
    -e 's!//mirror.centos.org!//10.10.255.201:8081/repository!g' \
    -i /etc/yum.repos.d/CentOS-Base.repo
    yum clean all >/dev/null 2>&1
    yum makecache >/dev/null 2>&1
    echo -e "${green}[info]: 标准化 YUM 仓库成功${plain}"
else
    echo -e "当前系统已设置过 YUM 仓库"
fi

if [ ! -f "/etc/yum.repos.d/epel.repo" ];then
    yum -y install epel-release >/dev/null 2>&1
    sed -e 's!^mirrorlist=!#mirrorlist=!g' \
    -e 's!^#baseurl=!baseurl=!g' \
    -e 's!//download\.fedoraproject\.org/pub!//10.10.255.201:8081/repository!g' \
    -i /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo
    echo -e "${green}[info]: 标准化 EPEL 仓库成功${plain}"
else
    echo -e "当前系统已安装过 EPEL 仓库"
fi

if [ ! -f "/etc/yum.repos.d/docker-ce.repo" ];then
    yum install wget -y >/dev/null 2>&1
    cat >> /etc/yum.repos.d/docker-ce.repo << EOF
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=http://10.10.255.201:8081/repository/docker-ce/linux/centos/7/"$basearch"/stable
enabled=1
gpgcheck=1
gpgkey=http://10.10.255.201:8081/repository/docker-ce/linux/centos/gpg
 
[docker-ce-edge]
name=Docker CE Edge - $basearch
baseurl=http://10.10.255.201:8081/repository/docker-ce/linux/centos/7/$basearch/edge
enabled=0
gpgcheck=1
gpgkey=http://10.10.255.201:8081/repository/docker-ce/linux/centos/gpg
EOF
    echo -e "${green}[info]: 标准化 DOCKER 仓库成功${plain}\n"
else
    echo -e "当前系统已安装过 DOCKER 仓库\n"
fi
yum makecache fast >/dev/null 2>&1
sleep 1
}

#安装常用软件
install_basesoft(){
yum -y install ${basesoft} >/dev/null 2>&1
echo -e "${green}[info]: 安装常用软件成功${plain}\n"
sleep 1
}

#disabled Selinux
initSelinux(){
if [[ `getenforce` == "Enforcing" ]] ; then
    setenforce 0
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    echo -e "${green}[info]: SELINUX 禁用成功${plain}\n"
else
    echo -e "当前系统已禁用 SELINUX\n"
fi
sleep 1
}

#标准化防火墙
initFirewall(){
if [[ `systemctl status firewalld | awk -F ' ' 'NR==3 {print $2}'` == 'active' ]] ; then
    systemctl stop firewalld >/dev/null 2>&1
    systemctl disable firewalld >/dev/null 2>&1
    yum remove firewalld -y >/dev/null 2>&1
    echo -e "${green}[info]: 停止运行 Firewalld 且卸载成功${plain}"
elif [[ `systemctl status firewalld | awk -F ' ' 'NR==3 {print $2}'` == 'inactive' ]] ; then 
    systemctl disable firewalld >/dev/null 2>&1
    yum remove firewalld -y >/dev/null 2>&1
    echo -e "${green}[info]: Firewalld 卸载成功${plain}"
else
    echo -e "当前系统未安装 Firewalld"
fi
 
    if [[ `systemctl status iptables | awk -F ' ' 'NR==3 {print $2}'` == 'active' ]]; then
    systemctl enable iptables >/dev/null 2>&1
    echo -e "iptables 正在运行\n"
else
    yum install iptables iptables-services -y >/dev/null 2>&1
    systemctl enable iptables >/dev/null 2>&1
    #\cp /etc/sysconfig/iptables /etc/sysconfig/iptables.`date +%F`
    #sed -i "s/22/ ${ssh_port} /g" /etc/sysconfig/iptables
    systemctl start iptables >/dev/null 2>&1
    echo -e "${green}[info]: 标准化 iptables 成功${plain}\n"
fi
sleep 1
}

#卸载NetworkManager
initNetwok(){
if [[ `systemctl status NetworkManager | awk -F ' ' 'NR==3 {print $2}'` == 'active' ]]; then
    systemctl stop NetworkManager && systemctl disable NetworkManager >/dev/null 2>&1
    yum remove NetworkManager -y >/dev/null 2>&1
    rm -rf /var/lib/NetworkManager
    echo -e "${green}[info]: 停止运行 NetworkManager 且卸载成功${plain}\n"
elif [[ `systemctl status NetworkManager | awk -F ' ' 'NR==3 {print $2}'` == 'inactive' ]]; then 
    systemctl disable NetworkManager >/dev/null 2>&1
    yum remove NetworkManager -y >/dev/null 2>&1
    rm -rf /var/lib/NetworkManager
    echo -e "${green}[info]: NetworkManager 卸载成功${plain}\n"
else
    rm -rf /var/lib/NetworkManager
    echo -e "当前系统已设置过 NetworkManager\n"
fi
sleep 1
}

#创建用户及工作目录
create_user(){
if [  ${system_user_check} -eq 0 ];then
    useradd ${system_user} -u ${user_id}
    echo "${system_user_password}" | passwd --stdin ${system_user} && history -c 
    echo "" >>  /etc/sudoers
    echo "#set sudo authority" >>  /etc/sudoers
    echo "${system_user}    ALL=(ALL)       NOPASSWD:ALL" >>  /etc/sudoers
    [ ! -d ${create_workdir} ] && mkdir -p ${create_workdir} 
    echo -e "${green}[info]: 创建用户成功且设置 sudo 权限${plain}\n"
else
    [ ! -d ${create_workdir} ] && mkdir -p ${create_workdir} 
    echo -e "当前系经存在 ${system_user} 用户，请手动检查sudo权限\n"
fi
sleep 1
}

#设置文件句柄&用户进程
openfile(){
if [[ `ulimit -a |grep "open files"|awk '{print $4}'` -lt 655350 || `ulimit -a |grep "max user processes"|awk '{print $5}'` -lt 655350 ]];then
    \cp /etc/security/limits.conf /etc/security/limits.conf.$(date +%F)
    \cp /etc/security/limits.d/20-nproc.conf /etc/security/limits.d/20-nproc.conf.$(date +%F)
    cat >> /etc/security/limits.conf << EOF
#copyright by hoke
* soft nproc 655350
* hard nproc 655350
* soft nofile 655350
* hard nofile 655350
EOF
    sed -i "s/^*/#*/" /etc/security/limits.d/20-nproc.conf
    sed -i "s/^root/#root/" /etc/security/limits.d/20-nproc.conf
    ulimit -HSn 655350
    ulimit -HSu 655350
    echo -e "${green}[info]: 优化文件句柄数&最大进程数成功${plain}"
else
    echo -e "当前系统文件句柄数&最大进程数已设置过"
fi
sleep 1
}

#set ssh
initSsh(){
if [[ `grep ^Port /etc/ssh/sshd_config |awk '{print $2}'` = '${ssh_port}' ]]; then
    echo -e "当前系统已设置过 SSH\n"
else
    [ ! -f /etc/ssh/sshd_config.$(date +%F) ] && \cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$(date +%F)
    sed -i "s/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/" /etc/ssh/sshd_config
    sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config
    sed -i "s%#Port 22%Port ${ssh_port} %g" /etc/ssh/sshd_config
    #sed -i "s%#PermitRootLogin yes%PermitRootLogin no%g" /etc/ssh/sshd_config
    #sed -i "s%#PermitEmptyPasswords no%PermitEmptyPasswords no%g" /etc/ssh/sshd_config
    systemctl restart sshd >/dev/null 2>&1
    [ ! -f /etc/sysconfig/iptables.$(date +%F) ] && \cp /etc/sysconfig/iptables /etc/sysconfig/iptables.$(date +%F)
    sed -i "s/22/ ${ssh_port} /g" /etc/sysconfig/iptables
    systemctl restart iptables >/dev/null 2>&1
    if [[ ! -d /root/.ssh ]]; then
        mkdir /root/.ssh
        chmod 700  /root/.ssh
    fi
    echo "${public_key}" >> /root/.ssh/authorized_keys
    chmod 644  /root/.ssh/authorized_keys
    echo -e "${green}[info]: 标准化 SSH 成功${plain}\n"
fi
sleep 1
}

#标准化vim
initVim(){
if [ ! -f /root/.vimrc ]; then
    cat >> /root/.vimrc << EOF
syntax enable
syntax on
set ruler
set number
set cursorline
set cursorcolumn
set hlsearch
set incsearch
set ignorecase
set nocompatible
set wildmenu
set paste
set expandtab
set laststatus=2
set tabstop=4
set shiftwidth=4
set softtabstop=4
set helplang=cn
set gcr=a:block-blinkon0
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
highlight CursorLine   cterm=NONE ctermbg=blue ctermfg=white guibg=NONE guifg=NONE
highlight CursorColumn cterm=NONE ctermbg=black ctermfg=white guibg=NONE guifg=NONE
EOF
    [ ! -f /home/${system_user}/.vimrc ] && \cp /root/.vimrc /home/${system_user}/
    chown ${system_user}:${system_user} /home/${system_user}/.vimrc
    echo -e "${green}[info]: 标准化 vim 成功${plain}\n"
else
    echo -e "当前系统已配置过 vim\n"
fi
}

#标准化全局变量
initProfile(){
if [[ ! -f /etc/profile.$(date +%F) && ${system_profile_check} -eq 0 ]]; then
    \cp /etc/profile /etc/profile.$(date +%F)
    cat >> /etc/profile << EOF
#全局变量
#copyright by hoke
alias vi=vim
stty erase ^H
alias cman='man -M /usr/share/man/zh_CN'
export PS1='\[\e[1;35m\][\[\e[1;33m\]\u@\h \[\e[1;31m\]\w\[\e[1;35m\]]\\$ \[\e[0m\]'
#USER_IP="`who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'`"
#export HISTTIMEFORMAT="[%F %T][`whoami`][${USER_IP}] "
EOF
    source /etc/profile
    echo -e "${green}[info]: 标准化全局变量成功${plain}\n"
else
    echo -e "当前系统已设置过全局变量\n"
fi
}

#优化内核
initKernel(){
[ ! -f /etc/sysctl.conf.$(date +%F) ] && \mv /etc/sysctl.conf /etc/sysctl.conf.$(date +%F)
if [ ${system_kernel_check} -eq 0  ];then
    cat > /etc/sysctl.conf << EOF
#copyright by hoke
#最大使用物理内存,默认值60
vm.swappiness = 0                                  
#开启路由转发
net.ipv4.ip_forward = 1                            
# 避免放大攻击
net.ipv4.icmp_echo_ignore_broadcasts = 1
# 开启恶意icmp错误消息保护
net.ipv4.icmp_ignore_bogus_error_responses = 1
#决定检查过期多久邻居条目
net.ipv4.neigh.default.gc_stale_time=120           
#禁用反向路径过滤
net.ipv4.conf.all.rp_filter=0                      
net.ipv4.conf.default.rp_filter=0   
#只用最适合的网卡响应       
net.ipv4.conf.default.arp_announce = 2             
net.ipv4.conf.all.arp_announce=2                   
net.ipv4.conf.lo.arp_announce=2 
#timewait的数量,默认180000
net.ipv4.tcp_max_tw_buckets = 5000
#表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；
net.ipv4.tcp_tw_reuse = 1
#表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭，慎用。
#net.ipv4.tcp_tw_recycle = 0
#修改系統默认的TIMEOUT时间，默认60
net.ipv4.tcp_fin_timeout = 30

#开启SYN Cookies,防止SYN洪水
net.ipv4.tcp_syncookies = 1                        
#表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数。
net.ipv4.tcp_max_syn_backlog = 8192               
#TCP三次握手的syn/ack阶段，重试次数，缺省5，设为2-3
net.ipv4.tcp_synack_retries = 2                    
#表示当keepalive起用的时候，TCP发送keepalive消息的频度。缺省是2小时，改为20分钟。
net.ipv4.tcp_keepalive_time = 600
#关闭ipv6
net.ipv6.conf.all.disable_ipv6 = 1                 
net.ipv6.conf.default.disable_ipv6 = 1             
net.ipv6.conf.lo.disable_ipv6 = 1                  

#允许一个进程在VMAs(虚拟内存区域)拥有最大数量/proc/sys/vm/max_map_count
vm.max_map_count = 262144
#/proc/sys/net/core/somaxconn 默认128，系统中每一个端口最大的监听队列的长度
net.core.somaxconn = 4096
EOF
    /sbin/sysctl -p
    echo -e "${green}[info]: 优化内核参数成功${plain}"
else
    echo -e "当前系统已优化过内核参数"
fi
sleep 1
}

AStr="一键标准化"
BStr="标准化中文字符集"
CStr="标准化yum仓库"
DStr="安装常用软件"
EStr="禁用Selinux"
FStr="标准化防火墙"
GStr="标准化网络"
HStr="创建用户及工作目录用户"
IStr="标准化时区同步时间"
JStr="标准化SSH"
KStr="标准化vim"
LStr="标准化全局变量"
MStr="优化系统参数及内核"
QStr="按Q或任意键退出"

clear
echo -e "\e[1;32m+----------------- 欢迎对系统进行标准化设置！------------------+"
echo ""
echo "      A：${AStr}"
echo "      B：${BStr}"
echo "      C：${CStr}"
echo "      D：${DStr}"
echo "      E：${EStr}"
echo "      F：${FStr}"
echo "      G：${GStr}"
echo "      H：${HStr}"
echo "      I：${IStr}"
echo "      J：${JStr}"
echo "      K：${KStr}"
echo "      L：${LStr}"
echo "      M：${MStr}"
echo "      Q：${QStr}"
echo ""
echo -e "+----------------- \033[41;37m20秒后自动一键标准化\033[0m\e[1;32m -------------------------+\033[0m"

read -n1 -t20 -p "请输入[A-M]选项，默认选项[A]:" option
[ -z "${option}" ] && option="A"
flag=$(echo $option|egrep "[A-Ma-m]" |wc -l)
if [ $flag -ne 1 ];then
    echo -e "\n\n你输入的选项是：${red} ${option} ${plain}，即将退出Byebye..."
    exit 1
fi
echo -e "\n\n你输入的选项是：${red} ${option} ${plain} ，5秒之后开始运行\n"
sleep 5

if checkos result centos7; then
    case $option in
        A|a)
        initCN_UTF8
        initYum
        install_basesoft
        initSelinux
        initFirewall
        initNetwok
        create_user
        initTimezone
        initSsh
        initVim
        initProfile
        openfile
        initKernel
        ;;
        B|b)
        initCN_UTF8
        ;;
        C|c)
        initYum
        ;;
        D|d)
        install_basesoft
        ;;
        E|e)
        initSelinux
        ;;
        F|f)
        initFirewall
        ;;
        G|g)
        initNetwok
        ;;
        H|h)
        create_user
        ;;
        I|i)
        initTimezone
        ;;
        J|j)
        initSsh
        ;;
        K|k)
        initVim
        ;;
        L|l)
        initProfile
        ;;
        M|m)
        openfile
        initKernel
        ;;
    esac
else
    echo -e "${red}[error]: 此脚本仅支持 Redhat & CentOS 7 且必须使用 root 运行!${plain}" 
    exit 1
fi