# Supported tags and respective `Dockerfile` links

-   [`0.8.12`, `latest` (0.8.12/Dockerfile*)](https://github.com/restsql/docker/blob/0.8.12/service/Dockerfile)
-   [`0.8.11` (0.8.11/Dockerfile*)](https://github.com/restsql/docker/blob/0.8.11/service/Dockerfile)

# What is restSQL?
restSQL is an open-source, ultra-lightweight data access layer for HTTP clients. restSQL is a persistence framework or engine in the middle tier of a classic three tier architecture: client, application server and database. It may also be embedded in any middle-tier as a Java library.

See [restsql.org](http://restsql.org) for more on concepts, architecture, API details, deployment instructions and project information.

# Image overview
This image provides the restSQL service running on tomcat 7 and jdk 7 on debian. It exposes HTTP on port 8080 at /restsql for the web service and admin console. See [restsql/service-sdk](https://hub.docker.com/r/restsql/service-sdk/) if you would like a bundled SDK.

It is designed to work with the MySQL database packaged as the [restsql/mysql-sakila](https://hub.docker.com/r/restsql/mysql-sakila/) docker container but you can use any [supported database](http://restsql.org/doc/Architecture.html).

# Prerequisites
A supported database must be running and accessible remotely *before* starting the restsql container. By default, this image is paired with the [restsql/mysql-sakila](https://hub.docker.com/r/restsql/mysql-sakila/), which contains the [sakila](https://dev.mysql.com/doc/sakila/en/) database (with restsql-test extensions). The restql image expects the database to be available at host 'mysql', port 3306 and a root password 'sakila'. See the [restsql/mysql-sakila](https://hub.docker.com/r/restsql/mysql-sakila/) for instructions on how to start it.

If you are running MySQL in another container or standalone, you can customize the restsql/service container as follows:

1. Use the docker run attribute --add-host="Host:IP" for example --add-host="mysql:192.168.1.13". This adds the host name mysql at 192.168.1.13 into the container's /etc/hosts.
2. Ensure port 3306 is accessible to the docker host
3. Update the access user name/password in restsql.properties. This is at /etc/opt/restsql/restsql.properties in the container file system.

    a. Start the restsql/service container

    b. Copy the current properties to the local file system

		$ docker cp restsql:/etc/opt/restsql/restsql.properties .

    c. Edit the database.user and database.password entries

    d. Copy the properties back to the container

		$ docker cp restsql.properties restsql:/etc/opt/restsql

	e. Restart the container


If you are running another database type, e.g. PostgreSQL:

1. Follow the above procedures
2. Additionally modify the database.driverClassName and database.url in restsql.properties

See [restSQL configuration](http://restsql.org/doc/Deployment.html) for more detail on restsql.properties customization.

If you would like to run the SDK's API Explorer, you need the sakila database. You can use the [restsql/mysql](https://github.com/restsql/restsql-sdk/tree/master/WebContent/database/mysql) or [restsql/postgresql](https://github.com/restsql/restsql-sdk/tree/master/WebContent/database/postgresql).

# Image use
```console
$ docker run -d --link mysqld:mysql -p 8080:8080 --name restsql --volume /var/log/restsql:/var/log/restsql restsql/service
```
This creates the container with the following characteristics:

- Names it restsql from the latest image in repository restsql/service
- Runs command ```catalina.sh run``` in daemon mode (background process)
- Binds mysqld container into the service container, mapping it's IP address into the host name mysql. The port 3306 is also made available since this was exposed at mysqld container creation. See [restsql/mysql-sakila](https://hub.docker.com/r/restsql/mysql-sakila/) for details.
- Exposes service and sdk on port 8080 to host processes and binds to its external interfaces. Check access via ```$ curl http://localhost:8080/restsql/```
- Exposes log files to local file system ```/var/log/restsql```. To check for errors: ```$ cat /var/log/reststql/internal.log```.

If you are using another database, use instructions from Prerequisites.

# Next steps
Use the restsql home page at http://host:port/restsql/ for helpful links. You may want to auto-create resource definitions from any available schema from the tools link (http://host:port/restsql/tools/). If you are using restsql/mysql-sakila you can auto-create resources from all tables in the sakila schema.

Explore restSQL [Concepts](http://restsql.org/doc/Concepts.html), [Architecture](http://restsql.org/doc/Architecture.html) and the [HTTP API reference](http://restsql.org/doc/api/index.html).

# License
restSQL is licensed under the standard [MIT license](http://restsql.org/doc/License.html).

# Supported Docker versions
This image was tested on Docker version 1.12.6.

Please see [the Docker installation documentation](https://docs.docker.com/installation/) for details on how to upgrade your Docker daemon.

# Issues
If you have any problems with or questions about this image or restSQL, please contact us through a [GitHub issue](http://github.com/restsql/restsql/issues) or see the [Support Overview](http://restsql.org/doc/Support.html).

# Contributing
You are invited to contribute new features, fixes or updates, large or small, via github pull requests. See [restsql.org/Roadmap](http://restsql.org/doc/Roadmap.html) for more information.
