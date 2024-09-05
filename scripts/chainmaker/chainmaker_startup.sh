#!/bin/sh
# https://docs.chainmaker.org.cn/v3.0.0/html/quickstart/%E9%80%9A%E8%BF%87%E5%91%BD%E4%BB%A4%E8%A1%8C%E4%BD%93%E9%AA%8C%E9%93%BE.html

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

# step1. 创建并打开目录
mkdir -p $DATADIR && cd $DATADIR

# step2. 源码下载
# 下载源码
git clone -b v3.0.0 --depth=1 https://git.chainmaker.org.cn/chainmaker/chainmaker-go.git
git clone -b v3.0.0  --depth=1 https://git.chainmaker.org.cn/chainmaker/chainmaker-cryptogen.git

# step3. 源码编译
cd chainmaker-cryptogen
make

# step4. 配置文件生成
# 将编译好的chainmaker-cryptogen，软连接到chainmaker-go/tools目录
cd ../chainmaker-go/tools
ln -s ../../chainmaker-cryptogen/ .

# 采用原始的身份模式，即证书模式（PermissionedWithCert）
# 进入脚本目录
cd ../scripts

# 生成单链4节点集群的证书和配置
# ./prepare.sh 4 1
yes "" | head -n 4 | ./prepare.sh 4 1


# step4. 编译及安装包制作
./build_release.sh

# step5. 启动节点集群
# 执行cluster_quick_start.sh脚本，会解压各个安装包，调用bin目录中的start.sh脚本，启动chainmaker节点
./cluster_quick_start.sh normal

# 启动成功后，将*.tar.gz备份，以免下次启动再次解压缩时文件被覆盖
mkdir -p ../build/bak
mv ../build/release/*.tar.gz ../build/bak

# step6. 查看节点启动使用正常
# 查看进程是否存在
ps -ef|grep chainmaker | grep -v grep
