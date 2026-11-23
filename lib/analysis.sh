#!/bin/bash

 analyze_log_summary() {
local file=$1
echo "INFO: $(count_by_severity "$file" "INFO")"
echo "Errors: $(count_by_severity "$file" "ERROR")"
echo "Warnings: $(count_by_severity "$file" "WARNING")"
echo "Critical: $(count_by_severity "$file" "CRITICAL")"
}

detect_suspicious_ips()
{
local file=$1
local threshold=$2

#check arguments 

if [[ $# -ne 2 ]];  then
echo "Error: Function requires 2 arguments"
return 2
fi

#check threshold must be an integer number 

if ! [[ $threshold =~ ^[1-9][0-9]*$ ]]; then 
echo "ERROR: numbers must be integers "
return 2
fi 

extract_failed_ssh_ips "$file" | awk -v threshold="$threshold" '
{
count[$1]++
total++
}

END {
if (total == 0) {
 print "No failed login attempts found."
exit
}
for (ip in count) {
 if (count[ip] >= threshold) {
print ip, count[ip], "SUSPICIOUS"
} else {
 print ip, count[ip], "NORMAL"
}
}
}'
}
