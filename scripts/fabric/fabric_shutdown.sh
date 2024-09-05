#!/bin/bash
# 脚本所在路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 配置文件路径
CONFIG_FILE="${SCRIPT_DIR}/../config.properties"

CHAIN_TYPE="fabric"

# 检查配置文件是否存在
if [ -f "$CONFIG_FILE" ]; then
  # 从.properties文件中读取变量
  DATADIR=$(grep "^${CHAIN_TYPE}.data_dir" "$CONFIG_FILE" | cut -d'=' -f2)

  # 验证读取的变量值
  echo "DATADIR=${DATADIR}"
else
  echo "Configuration file not found!"
  exit 1
fi


echo "Shutting down the network..."
cd ${DATADIR}/fabric-samples/test-network && ./network.sh down

if [ $? -ne 0 ]; then
    echo "Failed to shut down the network. Please check the network status."
    exit 1
fi

# echo "Removing the directory at ${DATADIR}..."
# rm -rf ${DATADIR}

# if [ -d "$DATADIR" ]; then
#     echo "Failed to remove the directory at ${DATADIR}."
#     exit 1
# else
#     echo "Cleanup complete."
# fi

echo "Cleanup complete."