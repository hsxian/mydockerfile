#!/bin/bash

user=`whoami`
#echo $user
if [ "$user" == "spark" ];then
    count=`ps -ef |grep QuorumPeerMain |grep -v "grep" |wc -l`
    if [ 0 == $count ];then
        read -p"Start zookeep，you can choice a host name to continue (master/slave01/slave02)?" choice
        case "$choice" in 
            master ) /usr/local/bash/master-start.sh;;
            slave01 ) /usr/local/bash/slave01-start.sh;;
            slave02 ) /usr/local/bash/slave02-start.sh;;
            #su - spark -s /usr/local/bash/master-start.sh;;
            #y|Y ) echo "yes";;
            #n|N ) echo "no";;
            * ) echo -e "\033[31minvalid\033[0m";;
        esac
    else
        echo -e "\033[33mzookeep was started...\033[0m"
    fi
fi