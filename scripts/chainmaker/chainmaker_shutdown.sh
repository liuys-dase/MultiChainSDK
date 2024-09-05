#!/bin/sh

# 脚本所在路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 配置文件路径
CONFIG_FILE="${SCRIPT_DIR}/../config.properties"

CHAIN_TYPE="chainmaker"

# 检查配置文件是否存在
if [ -f "$CONFIG_FILE" ]; then
  DATADIR=$(grep "^${CHAIN_TYPE}.data_dir" "$CONFIG_FILE" | cut -d'=' -f2)

  echo "DATADIR=${DATADIR}"
else
  echo "Configuration file not found!"
  exit 1
fi

# step1. 进入目录
cd $DATADIR/chainmaker-go/scripts

# step2. 停止节点集群
./cluster_quick_stop.sh

# step3. 检查节点进程
ps -ef|grep chainmaker | grep -v grep