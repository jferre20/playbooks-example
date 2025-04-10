#!/bin/bash

#SERVICE STATUS
PRODUCT=$1
STAT=$2

if [ $STAT = 'stop' ];
then
   MACHINE='poweroff'
fi

if [ $PRODUCT = 'satellite' ]; 
then

   if [ $3 = '01' ];
   then
      SERVER='sat01'
   elif [ $3 = '02' ];
   then
      SERVER='sat02'
   else
      SERVER='sat01 sat02'
   fi

   if [ $STAT = 'stop' ];
   then
      COMMAND="satellite-maintain service $STAT && $MACHINE"
      for srv in $SERVER; do ssh $srv $COMMAND; done
   elif [ $STAT = 'start' ];
   then
      COMMAND="sudo virsh start" 
      for srv in $SERVER; do $COMMAND $srv.jferre.local; done
   fi
   
elif [ $PRODUCT = 'aap' ] && [ $STAT = 'stop' ];
then

   ssh aap01 "automation-controller-service $STAT && $MACHINE"
   for srv in {hub01,eda01}; do ssh $srv "systemctl $STAT nginx && $MACHINE"; done
   ssh db01 "systemctl $STAT postgresql && $MACHINE"

elif [ $PRODUCT = 'aap' ] && [ $STAT = 'start' ];
then

   for srv in {aap01,hub01,eda01,db01}; do sudo virsh start $srv.jferre.local; done

else
   echo 'NADA'
fi
