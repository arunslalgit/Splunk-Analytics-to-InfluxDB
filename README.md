# Automated Splunk Query Execution and InfluxDB Ingestion
This document provides an overview of a Bash script designed to automate the execution of a Splunk query, process the response, and log the execution status to InfluxDB. The script is intended to be run on a scheduled basis as part of a broader data processing and monitoring system.
## Script Overview
The script retrieves data from Splunk based on a specified query, processes the results, and records the execution status in an InfluxDB database. It also allows for configuration through a sourced configuration file.

## Explanation of Script Components
### 1. Configuration and Environment Setup
- **Configuration File Sourcing**:
 The script begins by sourcing a configuration file located at `/vector/bin/config/shellConfig.conf`. This file should define necessary environment variables such as `HTTP_PROXY`, `SPLUNK_HOST`, `SPLUNK_API_ENDPOINT`, `AUTH_TOKEN`, `INFLUX_API`, `SplunkQuery`, and `opMode`.

### 2. Logging the Execution Status to InfluxDB
- **Status Logging**:
 If the Splunk query was successful (as determined by `successCount`), the script logs the success status to InfluxDB. This allows the script to track the last successful execution time and use it for subsequent queries.
 ```bash
 if [ $successCount -ge 0 ]; then
   statusFinal="SplunkStatus,Event=$event_name status=1 $thisRunTime"
   curl -s -XPOST $INFLUX_API'/api/v2/write?bucket=splunk_query_status&precision=ms' --data-raw "$statusFinal"
 fi
 ```
## Usage and Execution
- **Running the Script**:
 This script is designed to be run on a scheduled basis, typically via a cron job or equivalent scheduler. It will query Splunk, process the results, and update InfluxDB with the status of the query. The output of this script will be streamed in `stdout` in line protocol format. `Vector` will pick up this data and it will then write the output into Influx DB which is then visualized in Grafana as a Dashboard.
- **Debugging**:
 Uncomment the `set -x` line at the beginning of the script to enable debugging. This will output each command as it is executed, which can help in troubleshooting.
