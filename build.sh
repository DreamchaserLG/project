#!/bin/sh
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ "$1" = "build" ];then
    cd "$PROJECT_DIR"
    echo "执行成功"
fi
