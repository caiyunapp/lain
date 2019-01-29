#!/bin/bash

SEM_IDS=`ipcs -s | egrep "0x[0-9a-f]+ [0-9]+" | cut -f2 -d " "` # Semaphores IDs

for sem_id in $SEM_IDS; do
  SEM_INFO=`ipcs -s -i $sem_id`
  SEM_PS=`echo -e "$SEM_INFO" | awk 'NR>8 {print $5}' | sort -u` # Semaphore's processes IDs
  SEM_LEAK_FLAG=true
  for ps_id in $SEM_PS; do
    if `ps -p $ps_id > /dev/null`; then
      SEM_LEAK_FLAG=false
    fi
  done
  if $SEM_LEAK_FLAG ; then
    echo "Delete semaphore $sem_id"
    ipcrm -s $sem_id; # Remove the semaphore identified by semid.
  fi
done
