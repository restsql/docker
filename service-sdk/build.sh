#!/bin/sh

RESTSQL_VERSION=`grep 'build.version' ../../restsql/build.properties | cut -d '=' -f 2 | tr -d '\r'`


rm -rf usr/local/tomcat/webapps/
mkdir usr/local/tomcat/webapps/
cp ../../restsql/obj/lib/restsql-$RESTSQL_VERSION.war usr/local/tomcat/webapps/restsql.war
cp ../../restsql-sdk/obj/lib/restsql-sdk-$RESTSQL_VERSION.war usr/local/tomcat/webapps/restsql-sdk.war

docker build --tag restsql/service-sdk:$RESTSQL_VERSION --tag restsql/service-sdk:latest .
