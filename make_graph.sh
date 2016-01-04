#!/bin/bash

# read server.log and find the biggest and the lowest number of handled invocations (ignore low numbers at start and end of server)

SERVER_MIN_LOG_OUTPUT="server_min.properties"
SERVER_MAX_LOG_OUTPUT="server_max.properties"
CLIENT_LOG_OUTPUT="client_max_clients.properties"

SERVER_LOG_INPUT="server.log"

# script read data from one of clients log (first one)
for mach in $CLIENT_MACHINES; do
    CLIENT_LOG_INPUT="results-$mach.log"
    break
done

# DATA FROM SERVER

# example of line of server log
# 03:25:36,001 INFO  [stdout] (EJB default - 10) === HANDLED INVOCATIONS IN THE PREVIOUS SECOND: 3254 ===
# interested data is last number 

# minimal value
# - for ignoring first (start up) low numbers and final (during stopping server) low numbers - return 10th lowest number
res=`cat $SERVER_LOG_INPUT | grep "HANDLED INVOCATIONS IN THE PREVIOUS SECOND" | sed 's/.*HANDLED INVOCATIONS IN THE PREVIOUS SECOND..//g' | sed 's/ ===//g' | sort -n | head -n 10 | tail -n 1`
echo YVALUE=$res > $SERVER_MIN_LOG_OUTPUT
echo "server min log"
echo YVALUE=$res

# maximal value
res=`cat $SERVER_LOG_INPUT | grep "HANDLED INVOCATIONS IN THE PREVIOUS SECOND" | sed 's/.*HANDLED INVOCATIONS IN THE PREVIOUS SECOND..//g' | sed 's/ ===//g' | sort -n | tail -n 1`
echo YVALUE=$res > $SERVER_MAX_LOG_OUTPUT
echo "server max log"
echo YVALUE=$res

# DATA FROM CLIENT

# example of line of client log (result-perf18.log)
# 03:28:10,592 INFO  [com.redhat.qe.ejbperf.PerfTestRunner:130] collecting results.. clients=620; average latency=212ms; successful calls=10741; calls per client=17
# interested data is "clients"

# maximal count of clients
res=`cat $CLIENT_LOG_INPUT | grep "collecting results.. clients=" | sed 's/.*collecting results.. clients=//g' | sed 's/; average.*//g' | sort -n | tail -n 1`
echo YVALUE=$res > $CLIENT_LOG_OUTPUT
echo "client log"
echo YVALUE=$res

