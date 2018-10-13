# Supported tags and respective `Dockerfile` links

-   [`0.8.13`, `latest` (0.8.13/Dockerfile*)](https://github.com/restsql/docker/blob/0.8.13/mysql-sakila/Dockerfile)
-   [`0.8.12` (0.8.12/Dockerfile*)](https://github.com/restsql/docker/blob/0.8.12/mysql-sakila/Dockerfile)
-	[`0.8.11` (0.8.11/Dockerfile*)](https://github.com/restsql/docker/blob/0.8.11/mysql-sakila/Dockerfile)

# What is restSQL?
restSQL is an open-source, ultra-lightweight data access layer for HTTP clients. restSQL is a persistence framework or engine in the middle tier of a classic three tier architecture: client, application server and database. It may also be embedded in any middle-tier as a Java library.

See [restsql.org](http://restsql.org) for more on concepts, architecture, API details, deployment instructions and project information.

# Image overview
This image provides a ready to use database for the [restsql/service-sdk](https://hub.docker.com/r/restsql/service-sdk/) docker container. It contains MySQL 5.7.17 on ubuntu, the [sakila](https://dev.mysql.com/doc/sakila/en/) database and extensions required for the restsql test harness, [restsql-test](https://github.com/restsql/restsql-test).

# Image use
```console
$ docker run -d --name mysqld restsql/mysql-sakila
```

This creates a container with the following characteristics:

- Creates a container with name mysqld from the latest in repository restsql/mysql-sakila
- Runs entrypoint mysqld_safe --bind-address=0.0.0.0 in daemon mode (background process)
- Exposes port 3306 to other containers, but not to host processes, nor does it bind to the host external interfaces

You can check proper health via:
```console
$ docker run -it --link mysqld:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -psakila -e "show tables;" sakila'
```

(The password to the `root` account, is `sakila`, the same name as the schema/database to which you will connect.)

This downloads the mysql official library image, creates a temporary container, runs the mysql client, and lists all tables in the sakila schema. Drop the `-e "show tables;"` to open an interactive mysql console.

If you want to open it up for exploration with other non-containerized tools, publish the port 3306, as in:

```console
$ docker run -d --publish 3306:3306 --name mysqld restsql/mysql-sakila
```

# Supported Docker versions
This image was tested on Docker version 18.06.

Please see [the Docker installation documentation](https://docs.docker.com/installation/) for details on how to upgrade your Docker daemon.

# Issues
If you have any problems with or questions about this image or restSQL, please contact us through a [GitHub issue](http://github.com/restsql/restsql/issues) or see the [Support Overview](http://restsql.org/doc/Support.html).

# License
restSQL is licensed under the standard [MIT license](http://restsql.org/doc/License.html). The sakila database is licensed under the standard [BSD license](https://dev.mysql.com/doc/sakila/en/sakila-license.html).

# Contributing
You are invited to contribute new features, fixes or updates, large or small, via github pull requests. See [restsql.org/Roadmap](http://restsql.org/doc/Roadmap.html) for more information.
