#!/usr/bin/expect

set a10IP [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set sampling [lindex $argv 3]
set delay [lindex $argv 4]

spawn ssh -o "StrictHostKeyChecking no" $username@$a10IP
send_user "\n\[Log:Status\]Logging in...       \n"
expect {
	-re  "password:" {
		send "$password\r"
	}
	timeout {
		send_user "\n\n\[Log:Error\]Server timeout"
		exit
	}
}
expect {
	-re "login:" {
		send_user "\n\[Log:Status\]Logged in           \n"
		sleep 0.3
		send_user "\n\[Log:Status\]Sending Command     \n"
		set i 5
		while {$i < $argc} {
			expect ">" {send "show cgnv6 fixed-nat inside-user [lindex $argv $i] quota-used\r"}
			send_user "\n\[Log:Progress\][expr $i-4]/[expr $argc-5]([expr int((($i-4.0)/($argc-5.0))*100)]%)                    \n"
			set i [expr $i+$sampling]
			sleep $delay
		}
		expect ">" {send "exit\r"}
		expect "?:" {send "Y\r"}
		send_user "\n\[Log:Progress\][expr $argc-5]/[expr $argc-5](100%)\n"
	}
	-re "password:" {
		send_user "\n\n\[Log:Error\]Invalid user or password"
		exit
	}
}