#!/bin/bash

mkdir -p /usr/local/zookeeper/data
echo "3" > /usr/local/zookeeper/data/myid

#每个容器下都要启动 zookpeer
/usr/local/zookeeper/bin/zkServer.sh  start
echo -e "\033[32msleep 1m\033[0m"
sleep 1m
echo "........"

#启动Hdfs
/usr/local/hadoop/sbin/start-dfs.sh

#启动yarn
/usr/local/hadoop/sbin/start-yarn.sh