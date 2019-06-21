#!/bin/bash
set timeout 30
spawn su - $1
expect "[Pp]assword:"
send "$2"
interact