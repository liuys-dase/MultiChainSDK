#!/bin/sh
# https://docs.hyperchain.cn/document/detail?type=1&id=58
# https://docs.hyperchain.cn/docs/flato-solo/3.2-flato-tutorial
# https://github.com/hyperchain/hyperchain/releases

# step1. 运行 docker
docker pull hyperchaincn/solo:v2.0.0
docker run -d -p 8081:8081 hyperchaincn/solo:v2.0.0