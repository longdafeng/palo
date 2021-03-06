#!/usr/bin/env bash

# Copyright (c) 2017, Baidu.com, Inc. All Rights Reserved

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

export PALO_HOME=`cd "$curdir/.."; pwd`

# export env variables from be.conf
#
# UDF_RUNTIME_DIR
# LOG_DIR
export UDF_RUNTIME_DIR=${PALO_HOME}/lib/udf-runtime
export LOG_DIR=${PALO_HOME}/log

while read line; do
    envline=`echo $line | sed 's/[[:blank:]]*=[[:blank:]]*/=/g' | sed 's/^[[:blank:]]*//g' | egrep "^[[:upper:]]([[:upper:]]|_|[[:digit:]])*="`
    envline=`eval "echo $envline"`
    if [[ $envline == *"="* ]]; then
        eval 'export "$envline"'
    fi
done < $PALO_HOME/conf/be.conf

mkdir -p $LOG_DIR
mkdir -p ${UDF_RUNTIME_DIR}
rm -f ${UDF_RUNTIME_DIR}/*

pidfile=$curdir/be.pid

if [ -f $pidfile ]; then
    if flock -nx $pidfile -c "ls > /dev/null 2>&1"; then
        rm $pidfile
    else
        echo "Backend running as process `cat $pidfile`. Stop it first."
        exit 1
    fi
fi
 
chmod 755 ${PALO_HOME}/lib/palo_be
echo "start time: "$(date) >> $LOG_DIR/be.out

if [ ! -f /bin/limit3 ]; then
    LIMIT=
else
    LIMIT="/bin/limit3 -c 0 -n 65536"
fi

nohup $LIMIT ${PALO_HOME}/lib/palo_be "$@" >>$LOG_DIR/be.out 2>&1 </dev/null &
echo $! > $pidfile
