#!/bin/bash

# 脚本所在路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 配置文件路径
CONFIG_FILE="${SCRIPT_DIR}/../config.properties"

CHAIN_TYPE="eos"

# 检查配置文件是否存在
if [ -f "$CONFIG_FILE" ]; then
  DATADIR=$(grep "^${CHAIN_TYPE}.data_dir" "$CONFIG_FILE" | cut -d'=' -f2)

  echo "DATADIR=${DATADIR}"
else
  echo "Configuration file not found!"
  exit 1
fi

pid=$(lsof -t -i:8888)

if [ -n "$pid" ]; then
    echo "Stopping process on port 8888 with PID: $pid"
    kill -9 $pid
    echo "Process $pid has been stopped."
else
    echo "No process is using port 8888."
fi

rm -rf $DATADIR