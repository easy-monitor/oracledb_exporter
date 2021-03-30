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

install_path="${install_base}/${app_folder}"
sdk_path=$(ls ${install_path}/src/*.zip)

unzip ${sdk_path} -d $install_path/src/oracle_instantclient_basiclite
mv $install_path/src/instantclient_18_5 mv $install_path/src/oracle_instantclient_basiclite
rm -rf sdk_path