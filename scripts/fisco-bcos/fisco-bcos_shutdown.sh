#!/bin/sh

# 脚本所在路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 配置文件路径
CONFIG_FILE="${SCRIPT_DIR}/../config.properties"

CHAIN_TYPE="fisco-bcos"

# 检查配置文件是否存在
if [ -f "$CONFIG_FILE" ]; then
  DATADIR=$(grep "^${CHAIN_TYPE}.data_dir" "$CONFIG_FILE" | cut -d'=' -f2)

  echo "DATADIR=${DATADIR}"
else
  echo "Configuration file not found!"
  exit 1
fi

# step1. 打开目录
cd $DATADIR

# step2. 运行脚本，停止所有节点
bash nodes/127.0.0.1/stop_all.sh

# step3. 删除数据目录
rm -rf $DATADIR

# step4. 检查节点进程
ps aux |grep -v grep |grep fisco-bcos