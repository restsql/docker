#!/bin/sh

docker rm -f restsql
echo "running service, expecting mysql, mapped /etc/opt/restsql, mapped /var/log/restsql"
docker run -d --link mysqld:mysql -p 8080:8080 --name restsql --volume /private/var/log/restsql:/var/log/restsql --volume /private/etc/opt/restsql:/etc/opt/restsql --env TOMCAT_LOG_RETENTION_DAYS=1 restsql/service
echo "sleeping 6s"
sleep 6s
docker logs restsql
