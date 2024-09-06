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

# Check if nodeos command exists
if ! command -v nodeos &> /dev/null
then
    echo "nodeos not found, starting download and installation of eosio..."

    # Download eosio_2.1.0-1-ubuntu-20.04_amd64.deb
    wget https://github.com/EOSIO/eos/releases/download/v2.1.0/eosio_2.1.0-1-ubuntu-20.04_amd64.deb

    if [ $? -ne 0 ]; then
        echo "Download failed, please check the URL or your network connection."
        exit 1
    fi

    # Install the deb package using dpkg
    dpkg -i eosio_2.1.0-1-ubuntu-20.04_amd64.deb

    # Check for any missing dependencies and install them
    if [ $? -ne 0 ]; then
        echo "Dependency issues detected, attempting to fix..."
        apt-get install -f -y
        dpkg -i eosio_2.1.0-1-ubuntu-20.04_amd64.deb
    fi

    # Clean up the downloaded deb file
    rm eosio_2.1.0-1-ubuntu-20.04_amd64.deb

    echo "eosio successfully installed."
else
    echo "nodeos is already installed, skipping installation."
fi

rm -rf DATADIR && mkdir DATADIR
echo "
plugin = eosio::producer_plugin
plugin = eosio::producer_api_plugin
plugin = eosio::chain_api_plugin
plugin = eosio::history_api_plugin
plugin = eosio::http_plugin

http-server-address = 0.0.0.0:8888

access-control-allow-origin = *
access-control-allow-headers = Content-Type
access-control-allow-credentials = true
http-validate-host = false
" > DATADIR/config.ini

nodeos --config-dir DATADIR --data-dir DATADIR/data --contracts-console --verbose-http-errors --filter-on "*"
