# docker 搭建 spark 大数据集群

## 说明

本 dockerfile 为了搭建一个带有 Hadoop、ZooKeeper、Hbase、Spark 的大数据节点镜像，可以用于大数据集群的搭建。

## 依赖及其环境

1. 本 docker 镜像基于装有 ssh 服务的 centos 镜像，可在[centos-ssh](../centos-ssh/)中 build 得到该镜像。
