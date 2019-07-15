#!/bin/bash

set dir = `pwd`
cd /usr/local/spark/jars/
mkdir  hbase
cd  hbase
cp  /usr/local/hbase/lib/hbase*.jar  ./
#cp  /usr/local/hbase/lib/guava-11.0.2.jar  ./
cp  /usr/local/hbase/lib/guava-12.0.1.jar  ./
cp  /usr/local/hbase/lib/htrace-core-3.1.0-incubating.jar  ./
cp  /usr/local/hbase/lib/protobuf-java-2.5.0.jar  ./
cd $dir