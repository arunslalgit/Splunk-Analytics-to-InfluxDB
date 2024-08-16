#!/bin/bash
#set -x #activate this line for debugging, also activate file sink in vector toml file to see full output

# Source configuration and pull key value pairs
source "/vector/bin/config/shellConfig.conf"
export HTTP_PROXY HTTPS_PROXY SPLUNK_HOST SPLUNK_API_ENDPOINT AUTH_TOKEN INFLUX_API SplunkQuery opMode
Duration="-5m"
FinalQuery=$opMode$Duration$SplunkQuery
#echo $FinalQuery
#This is highly configurable, check Splunk documentation
response=$(curl --max-time 300 -s -X POST -H "Authorization: Bearer $AUTH_TOKEN" -k $SPLUNK_HOST$SPLUNK_API_ENDPOINT -d $FinalQuery)
echo "$response" #Vector pulls this streaming data and inserts into InfluxDB
