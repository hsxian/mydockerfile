# docker 搭建 spark 大数据集群

## 说明

本dockerfile为了搭建一个带有Hadoop、ZooKeeper、Hbase、Spark的大数据节点镜像，可以用于大数据集群的搭建。

## 依赖及其环境

1. 本 docker 镜像基于装有 ssh 服务的 centos 镜像，可在[centos-ssh](../centos-ssh/README.md)中build得到该镜像。
