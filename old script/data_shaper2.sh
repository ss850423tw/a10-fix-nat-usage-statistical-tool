#!/bin/bash
FILE=$1
while read line; do
	case "$line" in
		*"show"*)
			echo $line | rev | awk -F " " '{printf ","$2}' | rev 
		;;
		*"NAT"*)
			echo $line | rev | awk -F " " '{printf ","$1}' | rev
		;;
		*"Session"*)
			echo $line | rev | awk -F " " '{printf ","$1}' | rev
		;;
		*"TCP"*)
			echo $line | rev | awk -F " " '{printf ","$1}' | rev
		;;
		*"UDP"*)
			echo $line | rev | awk -F " " '{printf ","$1}' | rev
		;;
		*"ICMP"*)
			echo $line | rev | awk -F " " '{printf $1"\n"}' | rev
		;;
		*)
			echo $line
		;;
	esac
done < $FILE
time