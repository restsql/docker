#!/bin/sh

# start cron in the background
echo "Starting cron..."
crond &

# start tomcat
catalina.sh run
