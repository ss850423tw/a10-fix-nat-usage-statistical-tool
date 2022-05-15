#!/bin/bash
inputFile=$1
awk -F "," 'BEGIN{
	userCSVLine=0;
	userCounter[];
	natCounter[];
	for(i=-1;i<9;i++){
		sessionCounter[i] = 0;
		tcpCounter[i] = 0;
		udpCounter[i] = 0;
		icmpCounter[i] = 0;
	}
}
{
	userCSVArray[userCSVLine,0]=$1;
	userCSVArray[userCSVLine,1]=$2;
	userCSVArray[userCSVLine,2]=$3;
	userCSVArray[userCSVLine,3]=$4;
	userCSVArray[userCSVLine,4]=$5;
	userCSVArray[userCSVLine,5]=$6;
	#print userCSVArray[userCSVLine,0],userCSVArray[userCSVLine,1],userCSVArray[userCSVLine,2],userCSVArray[userCSVLine,3],userCSVArray[userCSVLine,4],userCSVArray[userCSVLine,5];
	
	if(userCSVArray[userCSVLine,0] ~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){
		for(i=0;i<9;i++){
			if(userCSVArray[userCSVLine,2]==0){
				sessionCounter[-1]++;
				break;
			}else if(int(userCSVArray[userCSVLine,2]/1000)==i){
				sessionCounter[i]++;
			}
			
		}
		for(i=0;i<9;i++){
			if(userCSVArray[userCSVLine,3]==0){
				tcpCounter[-1]++;
				break;
			}else if(int(userCSVArray[userCSVLine,3]/1000)==i){
				tcpCounter[i]++;
			}
		}
		for(i=0;i<9;i++){
			if(userCSVArray[userCSVLine,4]==0){
				udpCounter[-1]++;
				break;
			}else if(int(userCSVArray[userCSVLine,4]/1000)==i){
				udpCounter[i]++;
			}
		}
		for(i=0;i<9;i++){
			if(userCSVArray[userCSVLine,5]==0){
				icmpCounter[-1]++;
				break;
			}else if(int(userCSVArray[userCSVLine,5]/1000)==i){
				icmpCounter[i]++;
			}
		}
		
	}
	userCSVLine++;
}
END{
	printf "\n"
	printf "%11s|%7s%6s|%4s%6s|%4s%6s|%4s%6s\n"," Quantity","Session","%","TCP","%","UDP","%","ICMP","%";
	printf "-----------+-------------+----------+----------+----------\n"
	printf "%11s|%7s%6.2f|%4s%6.2f|%4s%6.2f|%4s%6.2f\n","0",sessionCounter[-1],(sessionCounter[-1]/(userCSVLine-1)*100),tcpCounter[-1],(tcpCounter[-1]/(userCSVLine-1)*100),udpCounter[-1],(udpCounter[-1]/(userCSVLine-1)*100),icmpCounter[-1],(icmpCounter[-1]/(userCSVLine-1)*100);
	printf "%11s|%7s%6.2f|%4s%6.2f|%4s%6.2f|%4s%6.2f\n","1 ~ 999",sessionCounter[0],(sessionCounter[0]/(userCSVLine-1)*100),tcpCounter[0],(tcpCounter[0]/(userCSVLine-1)*100),udpCounter[0],(udpCounter[0]/(userCSVLine-1)*100),icmpCounter[0],(icmpCounter[0]/(userCSVLine-1)*100);
	printf "%11s|%7s%6.2f|%4s%6.2f|%4s%6.2f|%4s%6.2f\n","1000 ~ 1999",sessionCounter[1],(sessionCounter[1]/(userCSVLine-1)*100),tcpCounter[1],(tcpCounter[1]/(userCSVLine-1)*100),udpCounter[1],(udpCounter[1]/(userCSVLine-1)*100),icmpCounter[1],(icmpCounter[1]/(userCSVLine-1)*100);
	printf "%11s|%7s%6.2f|%4s%6.2f|%4s%6.2f|%4s%6.2f\n","2000 ~ 2999",sessionCounter[2],(sessionCounter[2]/(userCSVLine-1)*100),tcpCounter[2],(tcpCounter[2]/(userCSVLine-1)*100),udpCounter[2],(udpCounter[2]/(userCSVLine-1)*100),icmpCounter[2],(icmpCounter[2]/(userCSVLine-1)*100);
	printf "%11s|%7s%6.2f|%4s%6.2f|%4s%6.2f|%4s%6.2f\n","3000 ~ 3999",sessionCounter[3],(sessionCounter[3]/(userCSVLine-1)*100),tcpCounter[3],(tcpCounter[3]/(userCSVLine-1)*100),udpCounter[3],(udpCounter[3]/(userCSVLine-1)*100),icmpCounter[3],(icmpCounter[3]/(userCSVLine-1)*100);
	printf "%11s|%7s%6.2f|%4s%6.2f|%4s%6.2f|%4s%6.2f\n","4000 ~ 4999",sessionCounter[4],(sessionCounter[4]/(userCSVLine-1)*100),tcpCounter[4],(tcpCounter[4]/(userCSVLine-1)*100),udpCounter[4],(udpCounter[4]/(userCSVLine-1)*100),icmpCounter[4],(icmpCounter[4]/(userCSVLine-1)*100);
	printf "%11s|%7s%6.2f|%4s%6.2f|%4s%6.2f|%4s%6.2f\n","5000 ~ 5999",sessionCounter[5],(sessionCounter[5]/(userCSVLine-1)*100),tcpCounter[5],(tcpCounter[5]/(userCSVLine-1)*100),udpCounter[5],(udpCounter[5]/(userCSVLine-1)*100),icmpCounter[5],(icmpCounter[5]/(userCSVLine-1)*100);
	printf "%11s|%7s%6.2f|%4s%6.2f|%4s%6.2f|%4s%6.2f\n","6000 ~ 6999",sessionCounter[6],(sessionCounter[6]/(userCSVLine-1)*100),tcpCounter[6],(tcpCounter[6]/(userCSVLine-1)*100),udpCounter[6],(udpCounter[6]/(userCSVLine-1)*100),icmpCounter[6],(icmpCounter[6]/(userCSVLine-1)*100);
	printf "%11s|%7s%6.2f|%4s%6.2f|%4s%6.2f|%4s%6.2f\n","7000 ~ 7999",sessionCounter[7],(sessionCounter[7]/(userCSVLine-1)*100),tcpCounter[7],(tcpCounter[7]/(userCSVLine-1)*100),udpCounter[7],(udpCounter[7]/(userCSVLine-1)*100),icmpCounter[7],(icmpCounter[7]/(userCSVLine-1)*100);
	printf "%11s|%7s%6.2f|%4s%6.2f|%4s%6.2f|%4s%6.2f\n","     > 8000",sessionCounter[8],(sessionCounter[8]/(userCSVLine-1)*100),tcpCounter[8],(tcpCounter[8]/(userCSVLine-1)*100),udpCounter[8],(udpCounter[8]/(userCSVLine-1)*100),icmpCounter[8],(icmpCounter[8]/(userCSVLine-1)*100);
}' $inputFile