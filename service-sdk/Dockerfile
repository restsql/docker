# restSQL service + sdk image

FROM tomcat:7.0.91-jre7-alpine

MAINTAINER restSQL Project Contributors <support@restsql.org>

# Locally used constants
ENV RESTSQL_VERSION=0.8.13
ENV TOMCAT_WEBAPPS_DIR=/usr/local/tomcat/webapps
ENV RESTSQL_CONF_DIR=/etc/opt/restsql
ENV RESTSQL_LOG_DIR=/var/log/restsql

# For the daily cron'd log cleaner
ENV TOMCAT_LOG_RETENTION_DAYS=3

# Create base dirs
RUN mkdir -vp ${RESTSQL_LOG_DIR}
RUN mkdir -vp ${RESTSQL_CONF_DIR}

# Get the service and sdk wars and tomcat conf
COPY usr /usr

# Link the default restsql.properties from the webapp to the conf dir. The war will expand when tomcat starts.
WORKDIR ${RESTSQL_CONF_DIR}
RUN ln -s ${TOMCAT_WEBAPPS_DIR}/restsql/WEB-INF/classes/resources/properties/default-restsql.properties restsql.properties

# Set the sqlresources dir to the sdk's
RUN ln -s ${TOMCAT_WEBAPPS_DIR}/restsql-sdk/examples/sqlresources .

# Install cron support for the log cleaner
RUN apk update
RUN apk add apk-cron
RUN rm /etc/periodic/daily/apk
COPY etc /etc
COPY sbin /sbin

VOLUME "${RESTSQL_LOG_DIR}"

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
