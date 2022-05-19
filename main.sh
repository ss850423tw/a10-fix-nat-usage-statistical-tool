#!/bin/bash
# Program : A10_Fixed-nat_port_usage
# Auther : EricWu
# History : 
# 2022/04/28 EricWu First release
# 2022/05/11 EricWu
# 2022/05/12 EricWu

location=$(pwd)
date=$(date +"%Y%m%d%H%M%S")
startTime=$(date +"%s")

#mkdir
mkdir -p $location/input
mkdir -p $location/output/tmp

# Input File
networkIDListFile=$location/input/networkidlist
touch $networkIDListFile

# Output File
ipListFile=$location/output/tmp/iplist
rawdata=$location/output/tmp/rawdata_$date.txt
serverOutput=$location/output/tmp/serverOutput_$date.txt
userCSV=$location/output/User_$date.csv
summaryFile=$location/output/Summary_$date.txt
#userCSV=$location/output/User.csv
#summaryFile=$location/output/Summary.txt

#clear tmp
#rm -f $location/output/tmp/*

#Command send parameter
commandDelayValue=0
commandSamplingValue=1

title='Generate-IP-list';printf '========== %11s%-11s  ========== \n' `echo "$title" | cut -c 1-$((${#title}/2))` `echo "$title" | cut -c $((${#title}/2+1))-${#title}`
echo "This part will generate all of IP in these Network ID for quota-used commands."
echo 
echo "-Network ID List-"
echo "`grep -n "$" $networkIDListFile`"
echo 
echo "Is network ID list correct?"
select selection in "Yes." "No & edit." "No & quit."; do
	case $selection in
		"Yes." )
			echo
			echo "Calculating all IP in Network ID list..."
			echo 
			./iplist_generator.sh $networkIDListFile $ipListFile
			break;;
		"No & edit." ) 
			vim $networkIDListFile
			echo 
			clear
			title='Get-IP-list';printf '========== %11s%-11s  ========== \n' `echo "$title" | cut -c 1-$((${#title}/2))` `echo "$title" | cut -c $((${#title}/2+1))-${#title}`
			echo "This part will generate all of IP in these Network ID for quota-used commands.";
			echo 
			echo "-Network ID List-"
			echo "`grep -n "$" $networkIDListFile`"
			echo 
			echo "Is network ID list correct?"
			echo "1) Yes."
			echo "2) No & edit."
			echo "3) No & quit.";;
		"No & quit." )
			exit;;
	esac
done
ipList=(`awk '{print $0}' $ipListFile`)

title='Command-sender-parameter';printf '========== %11s%-11s  ========== \n' `echo "$title" | cut -c 1-$((${#title}/2))` `echo "$title" | cut -c $((${#title}/2+1))-${#title}`
echo "This part will setting log in information, sampling value and delay value for command sender."
echo 
read -ep "Login A10 IP : " a10IP
echo
read -ep "Login A10 User : " username
echo
read -sep "Login A10 Password : " password
loginData=$a10IP" "$username" "$password
echo
echo
read -ep "What sampling value you want?[default : 1]: " commandSampling
commandSampling=${commandSampling:-$commandSamplingValue}
echo
read -ep "What delay value you want? (this value will impact A10 cpu utilization)[default : 0]: " commandDelay
commandDelay=${commandDelay:-$commandDelayValue}
commandParameter=$commandSampling" "$commandDelay
echo
echo "All right! let's go."
echo
title='Command-sender';printf '========== %11s%-11s  ========== \n' `echo "$title" | cut -c 1-$((${#title}/2))` `echo "$title" | cut -c $((${#title}/2+1))-${#title}`
echo
echo "Use \"$username\" Login to \"$a10IP\""
echo
echo "Collecting data..."
#loginData=192.168.102.100" "admin" "a10
./ssh_login.sh $loginData $commandParameter ${ipList[*]} > $serverOutput &
while [ 1 ]; do
	sleep 1
	[[ `tail -n 1 $serverOutput` =~ "Error" ]] && echo "`grep "Log" $serverOutput | tail -n 1`" && echo "exit !" && exit
	echo -ne "`grep "Log" $serverOutput | tail -n 1`\\r"
	[[ `tail -n 1 $serverOutput` =~ "100%" ]] && echo -ne "`grep "Log" $serverOutput | tail -n 1`\\r" && break
done
wait
grep 'show\|NAT IP\|Used' $serverOutput > $rawdata
echo
echo
echo done.

echo
title='Create-CSV-File';printf '========== %11s%-11s  ========== \n' `echo "$title" | cut -c 1-$((${#title}/2))` `echo "$title" | cut -c $((${#title}/2+1))-${#title}`
awk -F " " 'BEGIN{printf "User,NAT,Session,TCP,UDP,ICMP"}{printf ","$4$5}' $rawdata | sed 's/,inside-user/\n/g' > $userCSV
echo done.

echo
title='Summary';printf '========== %11s%-11s  ========== \n' `echo "$title" | cut -c 1-$((${#title}/2))` `echo "$title" | cut -c $((${#title}/2+1))-${#title}`
./summary.sh $userCSV | tee $summaryFile
echo done.

echo
endTime=$(date +"%s")
title="All-done.($((endTime-startTime))s)";printf '========== %11s%-11s  ========== \n' `echo "$title" | cut -c 1-$((${#title}/2))` `echo "$title" | cut -c $((${#title}/2+1))-${#title}`
