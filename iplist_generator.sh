#!/bin/bash
inputFile=$1
ipListFile=$2
touch $ipListFile
awk -F '[./]' 'BEGIN{
	networkIDListLine = 1	
}
{
	if($0 ~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/+[0-9]{1,2}/){
		ipAddrNum = 0
		netMaskNum = 0
		networkNum = 0
		broadcastNum = 0
		
		print networkIDListLine":Network ID is " $1"."$2"."$3"."$4"/"$5
		
		#print $1,$2,$3,$4,$5
		zeros = 32-$5
		#print "There are "zeros" zero in netmask."
		
		for(i=0;i<zeros;i++){
			netMaskNum = xor(lshift(netMaskNum, 1), 1) 
		}
		netMaskNum = xor(netMaskNum,0xFFFFFFFF)
		#print "netMaskNum = "netMaskNum
		
		ipAddrNum = lshift($1,24)+lshift($2,16)+lshift($3,8)+$4
		#print "ipAddrNum = "ipAddrNum
		
		networkNum = and(ipAddrNum,netMaskNum)
		#print "networkNum = "networkNum
		
		broadcastNum = or(xor(0xFFFFFFFF,netMaskNum),networkNum)
		#print "broadcastNum = "broadcastNum
		
		s1 = rshift(and(networkNum,0xFF000000),24)
		s2 = rshift(and(networkNum,0xFF0000),16)
		s3 = rshift(and(networkNum,0xFF00),8)
		s4 = and(networkNum,0xFF)
		print "  Start IP = "s1"."s2"."s3"."s4
		
		e1 = rshift(and(broadcastNum,0xFF000000),24)
		e2 = rshift(and(broadcastNum,0xFF0000),16)
		e3 = rshift(and(broadcastNum,0xFF00),8)
		e4 = and(broadcastNum,0xFF)
		print "  End IP = "e1"."e2"."e3"."e4
		
		#d1=e1-s1
		#d2=e2-s2
		#d3=e3-s3
		#d4=e4-s4
		#print "D IP = "d1"."d2"."d3"."d4
		
		for(A=s1;A<=e1;A++){
			for(B=s2;B<=e2;B++){
				for(C=s3;C<=e3;C++){
					for(D=s4;D<=e4;D++){
						print A"."B"."C"."D > "'$ipListFile'"
					}
				}
			}
		}
		print "  There are "2^zeros" IPs in this Network ID."
		print ""
		networkIDListLine++
	}
}' $inputFile