#!/bin/bash

# 脚本所在路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 配置文件路径
CONFIG_FILE="${SCRIPT_DIR}/../config.properties"

CHAIN_TYPE="fabric"

# 检查配置文件是否存在
if [ -f "$CONFIG_FILE" ]; then
  DATADIR=$(grep "^${CHAIN_TYPE}.data_dir" "$CONFIG_FILE" | cut -d'=' -f2)
  CHANNEL=$(grep "^${CHAIN_TYPE}.channel" "$CONFIG_FILE" | cut -d'=' -f2)
  WALLET_DIR=$(grep "^${CHAIN_TYPE}.wallet_dir" "$CONFIG_FILE" | cut -d'=' -f2)

  echo "DATADIR=${DATADIR}"
  echo "CHANNEL=${CHANNEL}"
  echo "WALLET_DIR=${WALLET_DIR}"
else
  echo "Configuration file not found!"
  exit 1
fi

echo "Creating root directory at ${DATADIR} "
mkdir -p "${DATADIR}" && cd "${DATADIR}" || exit

echo "Downloading Fabric binaries..."
if [ ! -f "$SCRIPT_DIR/install-fabric.sh" ]; then
    echo "install-fabric.sh not found in $SCRIPT_DIR. Downloading..."
    curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh
else
    echo "install-fabric.sh already exists in $SCRIPT_DIR. Skipping download."
    cp "$SCRIPT_DIR/install-fabric.sh" .
fi


echo "Running the install-fabric.sh script..."
if [ -d "$DATADIR/fabric-samples" ]; then
    echo "The fabric-samples directory already exists. Skipping installation."
else
    echo "The fabric-samples directory does not exist. Starting installation..."
    ./install_fabric.sh docker samples binary
fi

echo "Starting the Fabric network..."
cd fabric-samples/test-network
./network.sh up createChannel -c "$CHANNEL"
./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl go

# 新建钱包目录
rm -rf "${WALLET_DIR}" && mkdir -p "${WALLET_DIR}"
