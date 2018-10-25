#!/bin/sh
######################脚本注释#############################
# 文件名： update_after_dist.sh[版本发布后-执行脚本]      #
# 功  能： 修改pulgin的配置                               #
# 作  者： hoke                                           #
# 时  间： 20181025                                       #
# 单  元： BTFL3_AP                                       #
###########################################################
plugin_cfg=$HOME/plugin/api-gw-plugin/config/application_custom.properties

if [ `grep 59e208034ff2393f226e1734 "$plugin_cfg" | wc -l ` -eq 0 ];then
    sed -i 's!^urlProperties\.orgId.*!urlProperties.orgId=59e208034ff2393f226e1734!g' $plugin_cfg
    cat >> $plugin_cfg << EOF
urlProperties.orgListUrl=http://hbcccloud.blockchain.ccb.com:4040/api/organization/certificate/tree
urlProperties.reportBLDetailsUrl=http://11.168.216.64:6060/api/report/details
urlProperties.reportLCDetailsUrl=http://11.168.216.64:5050/api/report/details
EOF
    echo "-------------------------------------------------------------------------------------------------"
    echo "INFO: Plugin configuration modified successfully."
    echo "-------------------------------------------------------------------------------------------------"
    exit 0
else
    echo "-------------------------------------------------------------------------------------------------"
    echo "ERROR: 已修改过参数，请勿重复执行"
    echo "-------------------------------------------------------------------------------------------------"
    exit 1
fi