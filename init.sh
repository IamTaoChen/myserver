#!/bin/bash

ROOT=$(dirname $(readlink -f $0))

ALL_SHELLS=`ls -l "${ROOT}/" | awk '/^-.*[0-9][0-9][0-9]-[A-Za-z]+\.sh$/ {print $NF}' `

for SHELL_FILE in ${ALL_SHELLS[@]}
do
    echo ">Execute ${SHELL_FILE}"
    exec $ROOT/$SHELL_FILE
done