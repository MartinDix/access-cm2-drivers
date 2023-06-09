#!/usr/bin/env bash

# Script to save the maximum wallclock time.
#
# This file is then loaded by the validation note software
# to calculate the speed of the model.

# Taken from Met Office standard AMIP suite

set -u
RESUB_PERIOD=$1

# What is the output file?
MY_OUTPUT=$ATM_RUNDIR/pe_output/$RUNID.fort6.pe0
echo "Using output file $MY_OUTPUT"

pes=$(grep "Processors initialised." $MY_OUTPUT | awk '{print $1}')
if [ -z "$pes" ]; then
   echo "This must be a reconfiguration job so therefore skipping saving of wallclock time"
else
   wallclock=$(grep "Maximum Elapsed Wallclock Time" $MY_OUTPUT | awk '{print $5}')
   cputime=$(grep "Total Elapsed CPU Time" $MY_OUTPUT | awk '{print $5}')
   double_timesteps=$(grep -c "Linear solve for Helmholtz problem" $MY_OUTPUT)
   timesteps=$(expr $double_timesteps "/" 2)
   w_max=$(get_vertical.sh $MY_OUTPUT | tail -n 1 | awk '{print $8}')
   resub_mon=$(echo $RESUB_PERIOD | cut -dP -f2 | cut -dM -f1)
   if [ -z "$resub_mon" ] ; then resub_mon=0 ; fi
   resub_day=$(echo $RESUB_PERIOD | cut -dP -f2 | cut -dM -f2 | cut -dD -f1)
   if [ -z "$resub_day" ] ; then resub_day=0 ; fi
   echo "$CYLC_TASK_CYCLE_POINT, $pes, $resub_mon, $resub_day, $timesteps, $wallclock, $cputime, $w_max" >> $ROSE_DATA/${RUNID}_wallclock.list
fi
