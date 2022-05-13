#!/bin/bash
FILE=$1
while read line; do
	case "$line" in
		*"show"*)
			echo $line | rev | awk -F " " '{print $2}' | rev | awk -F " " '{print "Private IP: "$0}'
			continue
		;;
		*"NAT"*)
			echo $line | rev | awk -F " " '{print $1}' | rev | awk -F " " '{print "Public IP: "$0}'
			continue
		;;
		*"Session"*)
			echo $line
			continue
		;;
		*"TCP"*)
			echo $line
			continue
		;;
		*"UDP"*)
			echo $line
			continue
		;;
		*"ICMP"*)
			echo -e "$line\n"
			continue
		;;
		*)
			echo $line
		;;
	esac
done < $FILE