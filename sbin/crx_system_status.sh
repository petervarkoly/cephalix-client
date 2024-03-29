#!/bin/bash

ERROR=""
if [ -x /usr/share/cranix/tools/cephalix-client-check ]; then
	ERROR=$( /usr/share/cranix/tools/cephalix-client-check )
fi
echo -n "{"
echo -n "\"created\":\"$(date +%s)000\","
echo -n "\"runningKernel\":\"$( uname -r )\","
echo -n "\"installedKernel\":\"$( rpm -q kernel-default --qf "%{VERSION}-%{RELEASE}\n" | tail -n1 )\","
echo -n "\"uptime\":\"$( gawk '{ printf("%d T %d Std",$1/86400,$1%86400/3600) }'  /proc/uptime )\","
if [ -e /etc/products.d/CRANIX.prod ]; then
     echo -n "\"version\":\"$( rpm -q --qf "%{VERSION}-%{RELEASE}" cranix-base )\","
else
     echo -n "\"version\":\"$( rpm -q --qf "%{VERSION}-%{RELEASE}" oss-base )\","
fi
d=$( rpm -qa --qf "%{INSTALLTIME}\n" | sort -n | tail  -n 1 )
echo -n "\"lastUpdate\":\"$((d*1000))\","
echo -n '"rootUsage":"'
	df -h --output=avail,pcent,ipcent /     | gawk '{ if ( NR==2 ) { print $1 " " $2 " " $3 "\"" ","} }'
isSrv=$( grep " /srv " /proc/mounts  )
if [ "${isSrv}" ]; then
   echo -n '"srvUsage":"'
	df -h --output=avail,pcent,ipcent /srv  | gawk '{ if ( NR==2 ) { print $1 " " $2 " " $3 "\"" ","} }'
fi
isVar=$( grep " /var " /proc/mounts  )
if [ "${isVar}" ]; then
   echo -n '"varUsage":"'
	df -h --output=avail,pcent,ipcent /var  | gawk '{ if ( NR==2 ) { print $1 " " $2 " " $3 "\"" ","} }'
fi
isHome=$( grep " /home " /proc/mounts  )
if [ "${isHome}" ]; then
    echo -n '"homeUsage":"'
	df -h --output=avail,pcent,ipcent /home | gawk '{ if ( NR==2 ) { print $1 " " $2 " " $3 "\"" ","} }'
fi
echo -n '"availableUpdates":"'
	zypper lu | gawk -F "|" '{ if( $1 == "v " ) { printf("%s ", $3) } }' | sed -E 's/\s+/ /g'
	echo '",'
echo -n '"errorMessages":"'${ERROR}'"'
echo "}"


