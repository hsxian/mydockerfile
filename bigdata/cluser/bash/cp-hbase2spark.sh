#!/bin/bash

set dir = `pwd`
cd /usr/local/spark2.4.0/jars/
mkdir  hbase
cd  hbase
cp  /usr/local/hbase2.1.3/lib/hbase*.jar  ./
cp  /usr/local/hbase2.1.3/lib/guava-11.0.2.jar  ./
cp  /usr/local/hbase2.1.3/lib/client-facing-thirdparty/htrace-core-3.1.0-incubating.jar  ./
cp  /usr/local/hbase2.1.3/lib/protobuf-java-2.5.0.jar  ./
cd $dir