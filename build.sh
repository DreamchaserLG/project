#!/bin/sh
if [ "$1" = "build" ];then
    mkdir /home/changsheng/project/project65391/project
    cp -a /home/changsheng/project/project65391/server/. /home/changsheng/project/project65391/project/
    cd /home/changsheng/project/project65391/project
    rm -rf /home/changsheng/project/project65391/server
    echo "执行成功"
fi
