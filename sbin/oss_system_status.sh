#!/bin/bash

echo "{"
echo "\"runningKernel\":\"$( uname -r )\","
echo "\"installedKernel\":\"$( rpm -q kernel-default --qf "%{VERSION}-%{RELEASE}" )\","
echo "\"uptime\":\"$( gawk '{ printf("%d T %d Std",$1/86400,$1%86400/3600) }'  /proc/uptime )\","
echo "\"version\":\"$( rpm -q --qf "%{VERSION}-%{RELEASE}" oss-base )\","
d=$( rpm -qa --qf "%{INSTALLTIME}\n" | sort -n | tail  -n 1 )
echo "\"lastUpdate\":\"$( date -d "@$d" +%Y-%m-%d-%H-%M )\","
echo -n '"rootUsage":"'
	df -h --output=avail,pcent,ipcent /     | gawk '{ if ( NR==2 ) { print $1 " " $2 " " $3 "\"" ","} }'
echo -n '"srvUsage":"'
	df -h --output=avail,pcent,ipcent /srv  | gawk '{ if ( NR==2 ) { print $1 " " $2 " " $3 "\"" ","} }'
echo -n '"varUsage":"'
	df -h --output=avail,pcent,ipcent /var  | gawk '{ if ( NR==2 ) { print $1 " " $2 " " $3 "\"" ","} }'
echo -n '"homeUsage":"'
	df -h --output=avail,pcent,ipcent /home | gawk '{ if ( NR==2 ) { print $1 " " $2 " " $3 "\"" ","} }'
echo -n '"availableUpdates":"'
	zypper lu | gawk '{ if( $1 == "v" ) { printf("%s ", $5) } }'
	echo '",'
echo "}"


