# 搭建 spark 大数据集群

## 说明

本 dockerfile 为了搭建一个带有 Hadoop、ZooKeeper、Hbase、Spark 的大数据节点镜像，可以用于大数据集群的搭建。

## 依赖及其环境

本 docker 镜像基于装有 ssh 服务的 centos 镜像，可在[centos-ssh](../centos-ssh/)中 build 得到该镜像。

本镜像所需软件可到互联网直接下载，放到 dockerfile 文件旁即可。清单如下：

1. [jdk-8u201-linux-x64.tar](https://java.com/en/download/linux_manual.jsp)
2. [hadoop-3.2.0.tar.gz](http://hadoop.apache.org/)
3. [scala-2.11.12.tgz](https://www.scala-lang.org/download/)
4. [spark-2.4.0-bin-hadoop2.7](https://spark.apache.org/downloads.html)
5. [zookeeper-3.4.13.tar.gz](https://zookeeper.apache.org/releases.html)
6. [hbase-2.1.3-bin.tar.gz](https://hbase.apache.org/downloads.html)(pyspark Write hbase only hbase version 1.2.8)
7. [spark-examples_2.11-1.6.0-typesafe-001.jar](https://jar-download.com/?search_box=spark-examples)

以上版本如需升级，请注意各个组件之间的依赖关系。

## 构建及安装

### 1.编译 dockerfile

```bash
docker build -t="bigdata-cluster" .
```

### 2.创建 docker 子网

```bash
docker network create -o "com.docker.network.bridge.name"="bd-cluster" --subnet 172.20.0.0/16 bd-cluster
```

### 3.启动三个 docker 节点

```bash
docker run --privileged -d -P -p 50070:50070 -p 50075:50075 -p 8088:8088 -p 8091:8091 -p 16010:16010 -p 2181:2181 -p 9000:9000 -p 8900:8080 -p 9090:9090 --name master -h master --ip 172.20.0.7 --add-host slave01:172.20.0.8 --add-host slave02:172.20.0.9 --net bd-cluster bigdata-cluster

docker run --privileged -d -P  --name slave01 -h slave01 --add-host master:172.20.0.7 --ip 172.20.0.8 --add-host slave02:172.20.0.9 --net bd-cluster bigdata-cluster

docker run --privileged -d -P  --name slave02 -h slave02 --add-host master:172.20.0.7 --ip 172.20.0.9 --add-host slave01:172.20.0.8 --net bd-cluster bigdata-cluster
```

### 4.启动容器终端配置 ssh 登录

```bash
#切换到spark用户
su - spark
#生成spark账号的key，执行后会有多个输入提示，不用输入任何内容，全部直接回车即可
# ssh-keygen # dockerfile 文件中已经生成
#拷贝到其他节点
ssh-copy-id -i /home/spark/.ssh/id_rsa -p 22 spark@master
ssh-copy-id -i /home/spark/.ssh/id_rsa -p 22 spark@slave01
ssh-copy-id -i /home/spark/.ssh/id_rsa -p 22 spark@slave02
#验证是否设置成功
ssh slave01
```

### _！！！写在步骤 5 和步骤 6 之前_

- _步骤 5 和 6 可以由在 root 下执行脚本取代，意即可以把脚本设在各自节点上开机启动_
  - _在 master 上执行/usr/local/bash/master-start.sh_
  - _在 slave01 上执行/usr/local/bash/slave01-start.sh_
  - _在 slave92 上执行/usr/local/bash/slave02-start.sh_
- 亦可以链接脚本自动运行

  ```bash
  #连接到切换用户时执行。由于开机启动脚本会出错，故而没有采用开机运行的方式
  ln -s /usr/local/bash/judezookeep.sh /etc/profile.d/
  ```

### 5.配置 zookpeer 标识文件

#### 5.1.在 master 节点创建标识为 1 的 myid

```bash
mkdir -p /usr/local/zookeeper/data
echo "1" > /usr/local/zookeeper/data/myid
```

#### 5.2.在 slave01 节点创建标识为 2 的 myid

```bash
mkdir -p /usr/local/zookeeper/data
echo "2" > /usr/local/zookeeper/data/myid
```

#### 5.3.在 slave02 节点创建标识为 3 的 myid

```bash
mkdir -p /usr/local/zookeeper/data
echo "3" > /usr/local/zookeeper/data/myid
```

### 6.启动集群

#### 6.1.每个容器下都要启动 zookpeer

```bash
cd /usr/local/zookeeper/bin
./zkServer.sh  start
```

#### 6.2.在 master 上启动 HDFS,Yarn,HBase 集群

```bash
# 启动Hdfs
/usr/local/hadoop/sbin/start-dfs.sh
#启动yarn
/usr/local/hadoop/sbin/start-yarn.sh
#启动hbase
/usr/local/hbase/bin/start-hbase.sh
#启动spark
/usr/local/spark/sbin/start-all.sh
```

#### 6.3.在 slave 上启动 HDFS,Yarn 集群

```bash
# 启动Hdfs
/usr/local/hadoop/sbin/start-dfs.sh
#启动yarn
/usr/local/hadoop/sbin/start-yarn.sh
```
