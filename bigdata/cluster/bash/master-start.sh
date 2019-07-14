#!/bin/bash
mkdir -p /usr/local/zookeeper/data
echo "1" > /usr/local/zookeeper/data/myid

#每个容器下都要启动 zookpeer
cd /usr/local/zookeeper/bin
./zkServer.sh  start
echo -e "\033[32msleep 1m\033[0m"
sleep 1m
echo "........"

#启动Hdfs
/usr/local/hadoop/sbin/start-dfs.sh

#启动hbase
/usr/local/hbase/bin/start-hbase.sh

#启动yarn
/usr/local/hadoop/sbin/start-yarn.sh
#启动spark
/usr/local/spark/sbin/start-all.sh
