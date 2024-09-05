#!/bin/sh
# https://fisco-bcos-doc.readthedocs.io/zh-cn/latest/docs/quick_start/air_installation.html

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

# step1. 安装ubuntu依赖
apt install -y curl openssl wget

# step2. 创建操作目录，下载安装脚本
# 创建操作目录
mkdir -p $DATADIR && cd $DATADIR

# 下载建链脚本
curl -#LO https://osp-1257653870.cos.ap-guangzhou.myqcloud.com/FISCO-BCOS/FISCO-BCOS/releases/v3.11.0/build_chain.sh && chmod u+x build_chain.sh

# step3. 搭建4节点非国密联盟链
bash build_chain.sh -l 127.0.0.1:4 -p 30300,20200

# step4. 启动FISCO BCOS链
# 启动所有节点
bash nodes/127.0.0.1/start_all.sh

# step5. 检查节点进程
ps aux |grep -v grep |grep fisco-bcos