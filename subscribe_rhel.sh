#!/bin/bash

set -x

SATELLITE=sat01.jferre.local

for v in `cat hosts`; do
        SERVER=$(ssh $v uname -n)
        echo $SERVER
        MAJOR_VERSION=$(ssh $v cat /etc/os-release | grep 'VERSION_ID' | cut -d '=' -f2 | sed 's|"||g' | cut -d '.' -f1)
        echo $MAJOR_VERSION

######### SUBSCRIBE IN SATELLITE #########
ssh $v "curl -sS --insecure 'https://${SATELLITE}/register?activation_keys=AK_RHEL${MAJOR_VERSION}&force=true&location_id=2&organization_id=1&update_packages=false' -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0LCJpYXQiOjE3NDAwMjgxODIsImp0aSI6ImM3ODBjYWVjMWM1MTg1YjM2MDRjYmUzNWM1NTFmNTU2OTEwN2I4OTc4MTBjOTAxZjA4OWY5M2M5ZjZhODVlN2UiLCJzY29wZSI6InJlZ2lzdHJhdGlvbiNnbG9iYWwgcmVnaXN0cmF0aW9uI2hvc3QifQ.LGAIJLFw9oaUT03MgBfVBYcI_Zhtv7D9IZ-plj08QSc' | bash"
done

set +x
