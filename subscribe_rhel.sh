#!/bin/bash

set -x

SATELLITE=sat01.jferre.local

for v in `cat hosts`; do
        SERVER=$(ssh $v uname -n)
        echo $SERVER
        MAJOR_VERSION=$(ssh $v cat /etc/os-release | grep 'VERSION_ID' | cut -d '=' -f2 | sed 's|"||g' | cut -d '.' -f1)
        echo $MAJOR_VERSION

######### SUBSCRIBE IN SATELLITE #########
ssh $v "curl -sS --insecure 'https://${SATELLITE}/register?activation_keys=AK_RHEL${MAJOR_VERSION}&force=true&location_id=2&organization_id=1&update_packages=false' -H 'Authorization: Bearer <TOKEN>' | bash"
done

set +x
