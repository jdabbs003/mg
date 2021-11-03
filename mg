#!/bin/sh

#
# Modemguard
# V1.2
#
# Disables Teltonika modems when they're not needed.
#
# Copyright 2021 James M Dabbs III
# Distributed under the Boost Software License, Version 1.0.
# See https://www.boost.org/LICENSE_1_0.txt
#

#
# Apply the Default Configuration
#

ping_address="8.8.8.8"
ping_device="eth1"
ping_interval=2
ping_failmax=3
modem_process="gsmd"

#
# Load any User Configuration
#
if test -f /var/etc/mg.conf; then
 . /var/etc/mg.conf
fi

#
# variables
#
ping_failcount=0
modem_running=1
modem_was_running=1
mg_runfile="/var/run/mg.run";
retval=0

#
# stop entry point
# stops the service in a civil manner
#
stop() {
 if test -f $mg_runfile; then
  pid_file="/proc/`cat $mg_runfile`"
  rm $mg_runfile
  while test -d $pid_file> /dev/null; do sleep 1; done;
 fi
 exit $retval;
}

disable_modem() {
 if [ $modem_running -ne 0 ]; then
  modem_running=0
  echo "Modemguard disabling modem."
  /etc/init.d/gsmd stop
  /etc/init.d/ledman stop
 fi
}

enable_modem() {
 if [ $modem_running -eq 0 ]; then
  modem_running=1
  echo "Modemguard enabling modem."
  /etc/init.d/gsmd start
  /etc/init.d/ledman start
 fi
}

#
# run entry point
# runs the serice on the calling process
#
run() {
 if [ -f $mg_runfile ]; then
  echo "Modemguard restarted."
 else
  echo "Modemguard started."
 fi

 echo $$ > $mg_runfile

 pidof $modem_process 2>&1 >/dev/null

 if [ $? -ne 0 ]; then
  modem_running=0
  modem_was_running=0
 fi

 while [ -f $mg_runfile ]
  do
   ping -c1 -I $ping_device $ping_address 2>&1 >/dev/null
   if [ $? -ne 0 ]; then
    if [ $ping_failcount -ge $ping_failmax ]; then
     enable_modem
    else
     ping_failcount=$((ping_failcount+1))
    fi
   else
    ping_failcount=0
    disable_modem
   fi

   sleep $ping_interval
 done

 if [ $modem_was_running -eq 0 ]; then
  disable_modem
 else
  enable_modem
 fi

 echo "Modemguard stopped."
 exit $retval
}

case "$1" in
 run)
  run
  ;;

 stop)
  stop
  ;;
 *)

  echo
  echo "* Modemguard"
  echo "  Usage: mg {run|stop}"
  echo "  This script is normally started by procd as a daemon."
  echo

  retval=1
esac

exit $retval

