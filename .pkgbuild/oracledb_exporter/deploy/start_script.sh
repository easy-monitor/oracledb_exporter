#!/bin/bash
# Name    : start_script.py
# Date    : 2016.03.28
# Func    : 启动脚本
# Note    : 注意：当前路径为应用部署文件夹

#############################################################
# 初始化环境

# 用户自定义
app_folder="oracledb_exporter"                 # 项目根目录
process_name="oracledb_exporter"       # 进程名

install_base="/data/exporter"          # 安装根目录

#############################################################
# 通用前置
# ulimit 设定
ulimit -n 100000
export LD_LIBRARY_PATH=/usr/local/easyops/ens_client/sdk:${LD_LIBRARY_PATH}

# 执行准备
install_path="${install_base}/${app_folder}"
if [[ ! -d ${install_path} ]]; then
    echo "${install_path} is not exist"
    exit 1
fi

# 指标文件
default_metric_path="$install_path/conf/default-metrics.toml"

# 自定义指标
custom_metric_path="$install_path/conf/custom-metrics.toml"
custom_metric_flag=""
if [[ -f ${custom_metric_path} ]]; then
    custom_metric_flag="--custom.metrics custom_metric_path"
fi

# 连接oracle依赖的sdk
sdk_path=$install_path/src/oracle_instantclient_basiclite
if [[ ! -d ${sdk_path} ]]; then
  cd $install_path/src/
  system_architecture=$(uname -m)
  if [ system_architecture == "arm64" ]; then
    zip_path=$(ls ${install_path}/src/instantclient-basic-linux.arm64.zip)
    unzip ${zip_path}
    mv $install_path/src/instantclient_19_19 $sdk_path
  else
    zip_path=$(ls ${install_path}/src/instantclient-basic-linux.zip)
    unzip ${zip_path}
    mv $install_path/src/instantclient_18_5 $sdk_path
  fi
fi

export LD_LIBRARY_PATH=$sdk_path:$LD_LIBRARY_PATH

# 启动命令
start_cmd="./bin/oracledb_exporter --web.listen-address=0.0.0.0:9161 --default.metrics $default_metric_path $custom_metric_flag >/dev/null 2>log/${app_folder}.log &"


# 日志目录
log_path="${install_path}/log"
mkdir -p ${log_path}


#############################################################

# 启动程序
echo "start by cmd: ${start_cmd}"
cd ${install_path} && eval "${start_cmd}"
if [[ $? -ne 0 ]];then
    echo "start error, exit"
    exit 1
fi
#############################################################
