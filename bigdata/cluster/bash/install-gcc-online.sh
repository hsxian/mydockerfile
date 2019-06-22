#!/bin/bash

set timeout 30
spawn yum -y install gcc automake autoconf libtool make
expect "*Is this ok*"
send "y\r"
expect "Complete*"
send "\r"
interact