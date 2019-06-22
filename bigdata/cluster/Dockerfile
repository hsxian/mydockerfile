# 构建Hadoop yarn spark Dockerfile文件内容

#基于centos-ssh构建
FROM centos-ssh

#创建spark账号
RUN useradd spark
RUN echo "spark:123" | chpasswd

#对于Hbase 修改 ulimit 限制
RUN echo "spark  -      nofile  32768 " >> /etc/security/limits.conf
RUN echo "spark  -      nproc   32000" >>  /etc/security/limits.conf
RUN echo "session required pam_limits.so" >>  /etc/pam.d/common-session 

#安装java
ADD jdk-8u201-linux-x64.tar.gz /usr/local/
RUN mv /usr/local/jdk1.8.0_201 /usr/local/jdk1.8

#配置JAVA环境变量
ENV JAVA_HOME /usr/local/jdk1.8
ENV PATH $JAVA_HOME/bin:$PATH

#配置所有用户的JAVA_HOME
ADD conf/profile/*.sh /etc/profile.d/
RUN source /etc/profile

#安装hadoop
ADD hadoop-3.2.0.tar.gz /usr/local
RUN mv /usr/local/hadoop-3.2.0 /usr/local/hadoop

#配置hadoop环境变量
ENV HADOOP_HOME /usr/local/hadoop
ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

#安装scala 注意Spark2.4.0对于Scala的版本要求是2.11.x
ADD scala-2.11.12.tgz /usr/local
RUN mv /usr/local/scala-2.11.12 /usr/local/scala

#配置scala环境变量
ENV SCALA_HOME /usr/local/scala
ENV PATH $SCALA_HOME/bin:$PATH

#安装spark
ADD spark-2.4.0-bin-hadoop2.7.tgz /usr/local
RUN mv /usr/local/spark-2.4.0-bin-hadoop2.7 /usr/local/spark

#配置spark环境变量
ENV SPARK_HOME /usr/local/spark
ENV PATH $SPARK_HOME/bin:$PATH

#安装ZooKeeper
ADD zookeeper-3.4.13.tar.gz /usr/local
RUN mv /usr/local/zookeeper-3.4.13 /usr/local/zookeeper

#配置ZooKeeper环境变量
ENV ZOOKEEPERE_HOME /usr/local/zookeeper
ENV PATH $ZOOKEEPERE_HOME/bin:$PATH

#安装HBase
#pyspark Write hbase only hbase version 1.2.8
ADD hbase-1.2.8-bin.tar.gz /usr/local
RUN mv /usr/local/hbase-1.2.8 /usr/local/hbase

#配置Hbase环境变量
ENV HBASE_HOME /usr/local/hbase
ENV PATH $HBASE_HOME/bin:$PATH

#创建ssh-key
USER spark
COPY ./bash/*.sh /usr/local/bash/
RUN expect /usr/local/bash/ssh-key.sh
USER root
RUN chmod +x /usr/local/bash/*.sh
RUN rm /usr/local/bash/ssh-key.sh

# bigdata configurations hdfs hbase zookeeper spark so on
ADD conf/hdfs_conf/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD conf/hdfs_conf/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD conf/hdfs_conf/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD conf/hdfs_conf/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD conf/hdfs_conf/slaves $HADOOP_HOME/etc/hadoop/slaves

ADD conf/spark_conf/spark-env.sh $SPARK_HOME/conf/spark-env.sh
ADD conf/spark_conf/slaves $SPARK_HOME/conf/slaves

ADD conf/zookeeper_conf/zoo.cfg $ZOOKEEPERE_HOME/conf/zoo.cfg

ADD conf/hbase_conf/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml
ADD conf/hbase_conf/regionservers $HBASE_HOME/conf/regionservers

RUN echo "export JAVA_HOME=/usr/local/jdk1.8" >> $HBASE_HOME/conf/hbase-env.sh
RUN echo "export HBASE_MANAGES_ZK=false" >> $HBASE_HOME/conf/hbase-env.sh

RUN echo "export JAVA_HOME=/usr/local/jdk1.8" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# 首次启动Hdfs，需要格式化（root执行）
RUN hdfs namenode -format

#配置Spark,在开始编程操作HBase数据库之前，需要对做一些准备工作。
RUN /usr/local/bash/cp-hbase2spark.sh
#在Spark 2.0版本上缺少相关把hbase的数据转换python可读取的jar包，需要我们另行下载。
COPY spark-examples_2.11-1.6.0-typesafe-001.jar /usr/local/spark/jars/hbase/

#更改hadoop和spark2.4.0目录所属用户
RUN chown -R spark:spark /usr/local/hadoop
RUN chown -R spark:spark /usr/local/spark
RUN chown -R spark:spark /usr/local/hbase
RUN chown -R spark:spark /usr/local/zookeeper


RUN yum install -y which sudo

WORKDIR /usr/local

#CMD ["/usr/sbin/sshd", "-D"]
#这句只能在ssh copy设置好后添加,否则ssh服务不支持
#RUN ln -s /usr/local/bash/judezookeep.sh /etc/profile.d/