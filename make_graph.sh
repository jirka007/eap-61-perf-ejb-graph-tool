#!/bin/bash

# read server.log and find the biggest and the lowest number of handled invocations (ignore low numbers at start and end of server)

SERVER_MIN_LOG="server_min.properties"
SERVER_MAX_LOG="server_max.properties"
CLIENT_LOG="client_max_clients.properties"

SERVER_LOG="server.log"


for mach in $CLIENT_MACHINES; do
    CLIENT_LOG="results-$mach.log"
    break
done

res=`cat $SERVER_LOG | grep "HANDLED INVOCATIONS IN THE PREVIOUS SECOND" | sed 's/.*HANDLED INVOCATIONS IN THE PREVIOUS SECOND..//g' | sed 's/ ===//g' | sort -n | head -n 4 | tail -n 1`
echo YVALUE=$res > $SERVER_MIN_LOG
res=`cat $SERVER_LOG | grep "HANDLED INVOCATIONS IN THE PREVIOUS SECOND" | sed 's/.*HANDLED INVOCATIONS IN THE PREVIOUS SECOND..//g' | sed 's/ ===//g' | sort -n | tail -n 1`
echo YVALUE=$res > $SERVER_MAX_LOG

res=`cat $CLIENT_LOG | grep "collecting results.. clients=" | sed 's/.*collecting results.. clients=//g' | sed 's/; average.*//g' | sort -n | tail -n 1`
echo YVALUE=$res > $CLIENT_LOG

