#!/bin/sh

if [ -z "$1" ]; then
	echo "Usage: run-service-sdk-pgsql.sh posgresql-ip-address"
	exit 2
fi

docker rm -f restsql
echo "running service-sdk, expecting postgresql listening on ip $1, mapped /etc/opt/restsql, mapped /var/log/restsql"
docker run -d --add-host postgresql:$1 -p 8080:8080 --name restsql --volume /private/var/log/restsql:/var/log/restsql --volume /private/etc/opt/restsql:/etc/opt/restsql restsql/service-sdk
echo "sleeping 6s"
sleep 6s
docker logs restsql
