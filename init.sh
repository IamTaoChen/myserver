#!/bin/bash
###
 # @Descripttion: 
 # @version: 
 # @Author: Tao Chen
 # @Date: 2023-04-15 05:58:41
 # @LastEditors: Tao Chen
 # @LastEditTime: 2023-04-17 12:20:30
### 

ROOT=$(dirname $(readlink -f $0))

chmod +x $ROOT/*.sh

ALL_SHELLS=`ls -l "${ROOT}/" | awk '/^-.*[0-9][0-9][0-9]-[A-Za-z]+\.sh$/ {print $NF}' `

for SHELL_FILE in ${ALL_SHELLS[@]}
do
    echo ">Execute ${SHELL_FILE}"
    eval $ROOT/$SHELL_FILE
done