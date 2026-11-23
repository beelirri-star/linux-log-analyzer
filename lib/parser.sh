#!/bin/bash

parse_by_severity()
{
local file=$1
local severity=$2
#check arguments 
if [[ $# -ne 2 ]]; then 
echo "ERROR: function requires a file and the severity level "
return 2
fi

#validate severity

case $severity in
 INFO|WARNING|ERROR|CRITICAL)
;;

*)
 echo "Error: Invalid severity level: $severity"
return 2
;;
    esac

#extract matching log entries

grep -F "$severity" "$file"

}

#extract failed SSH attempts 


parse_failed_ssh()
{
local file=$1


#check arguments allow only 1 arguments

if [[ $# -ne 1 ]]; then
echo "ERROR: function requires a file"
return 2
fi

grep -F "Failed password" "$file"

}

extract_failed_ssh_ips()
{

local file=$1


#check arguments allow only 1 arguments

if [[ $# -ne 1 ]]; then
echo "ERROR: function requires a file"
return 2
fi


grep -F "Failed password" "$file" | 
       awk '{
for (i = 1 ; i < NF ; i++ )
{
if ( $i == "from" ) {

print $(i+1)
break
}
}

}'

}


count_by_severity()
{

local file=$1
local severity=$2
#check arguments
if [[ $# -ne 2 ]]; then
echo "ERROR: function requires a file and the severity level "
return 2
fi

case $severity in
INFO|ERROR|CRITICAL|WARNING)
;;

*)
 echo "Error: Invalid severity level: $severity"
return 2
;;
    esac

grep -Fc "$severity" "$file" 

}













