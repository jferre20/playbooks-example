#!/bin/bash

#SERVICE STATUS
PRODUCT=$1
STAT=$2

if [ $STAT = 'stop' ];
then
   MACHINE='poweroff'
fi

if [ $PRODUCT = 'satellite' ] && [ $STAT = 'stop' ];
then
   COMMAND="satellite-maintain service $STAT && $MACHINE"
   for srv in {sat01,sat02}; do ssh $srv $COMMAND; done
elif [ $PRODUCT = 'aap' ] && [ $STAT = 'stop' ];
then
   COMMAND="automation-controller-service $STAT && $MACHINE"
   ssh aap01 $COMMAND
   ssh db01 systemctl $STAT postgresql && $MACHINE
   for srv in {hub01,eda01}; do ssh $srv systemctl $STAT nginx && $MACHINE; done
else
   echo 'NADA'
fi
