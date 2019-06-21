#!/bin/bash


mkdir -p /usr/local/zookeeper3.4.13/data
echo "2" > /usr/local/zookeeper3.4.13/data/myid

#每个容器下都要启动 zookpeer
/usr/local/zookeeper3.4.13/bin/zkServer.sh  start
echo -e "\033[32msleep 1m\033[0m"
sleep 1m
echo "........"

#启动Hdfs
/usr/local/hadoop/sbin/start-dfs.sh

#启动yarn
/usr/local/hadoop/sbin/start-yarn.sh