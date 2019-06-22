#!/bin/bash

set timeout 30
spawn ssh-keygen
expect "Enter file in which to save the key*"
send "\r"
expect "Enter passphrase*"
send "\r"
expect "Enter same passphrase again*"
send "\r"
expect "Your identification has been saved in*"
expect "Your public key has been saved in"
interact
