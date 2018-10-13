# Supported tags and respective `Dockerfile` links

-   [`0.8.13`, `latest` (0.8.13/Dockerfile*)](https://github.com/restsql/docker/blob/0.8.13/service/Dockerfile)
-   [`0.8.12` (0.8.12/Dockerfile*)](https://github.com/restsql/docker/blob/0.8.12/service/Dockerfile)
-   [`0.8.11` (0.8.11/Dockerfile*)](https://github.com/restsql/docker/blob/0.8.11/service/Dockerfile)

# What is restSQL?
restSQL is an open-source, ultra-lightweight data access layer for HTTP clients. restSQL is a persistence framework or engine in the middle tier of a classic three tier architecture: client, application server and database. It may also be embedded in any middle-tier as a Java library.

See [restsql.org](http://restsql.org) for more on concepts, architecture, API details, deployment instructions and project information.

# Image overview
This image provides the restSQL service running on tomcat 7 on a minimized linux (7.0.91-jre7-alpine). It exposes HTTP on port 8080 at /restsql for the web service and admin console. See [restsql/service-sdk](https://hub.docker.com/r/restsql/service-sdk/) if you would like a bundled SDK.

If you are just evaluating the framework, it is easiest to use the MySQL database packaged as the [restsql/mysql-sakila](https://hub.docker.com/r/restsql/mysql-sakila/) docker container. However, you can use any [supported database](http://restsql.org/doc/Architecture.html), containerized or not.

This container plus the mysql-sakila is backing our [live sandboxed service](http://restsql.org/restsql). All of the sdk is also hosted at [restsql.org](http://restsql.org). You are welcome to explore both.

# Prerequisites
A [supported database](http://restsql.org/doc/Architecture.html) must be running and accessible to the reststql container *before* starting the restsql container, otherwise it will not start properly.

## Use the project's containerized database
By default, this image is paired with the [restsql/mysql-sakila](https://hub.docker.com/r/restsql/mysql-sakila/), which contains an extended [sakila](https://dev.mysql.com/doc/sakila/en/) database. The restql image expects the database to be available at host 'mysql', port 3306 and a root password 'sakila'. However you do not need to configure anything special. All you need to do is start the restsql container with the `--link mysqld:mysql` to connect to the mysql-sakila containerized database.

See the [restsql/mysql-sakila](https://hub.docker.com/r/restsql/mysql-sakila/) for instructions on how to start it.

If you're just getting started, this may be the path of least resistance.

## Use your database
You'll be creating the restsql container with a docker volume mapping the container's configuration path `/etc/opt/restsql` to your host's configuration path. Let's say that is `/home/tripper/restsql-conf`. It will have a file `restsql.properties` and an empty directory called `sqlresources`. The argument `--volume /home/tripper/restsql-conf:/etc/opt/restsql` is added to the docker run to override the default config.

Copy the default restsql properties file from [github](https://raw.githubusercontent.com/restsql/restsql-sdk/master/WebContent/defaults/properties/default-restsql.properties) to your restsql conf dir. Create an empty dir `sqlresources`. Using the example above, it will look like:

    /home/tripper/restsql-conf
	    /sqlresources
		restsql.properties

Follow instructions below to configure for your database.

### MySQL config
Modify the properties `database.url`, `database.user` and `database.password` in the restsql.properties.

Your restsql.properties database section might look like:

    database.driverClassName=com.mysql.jdbc.Driver
	database.url=jdbc:mysql://dev-mysql1.example.com:3306?noDatetimeStringSync=true&zeroDateTimeBehavior=convertToNull
    database.user=mysql
    database.password=***

## Use your PostgreSQL database
Modify the `database.url`, `database.user`, `database.password` as well as the `database.driverClassName` in restsql.properties.

Your restsql.properties database section might look like:

    database.driverClassName=org.postgresql.Driver
    database.url=jdbc:postgresql://dev.postgresql.example.com:5432/dev_12
    database.user=postgres
    database.password=***

# Image use
Assuming you've followed the prerequisites, we're ready to launch.

## With the project's containerized database
```console
$ docker run -d --link mysqld:mysql -p 8080:8080 --name restsql --volume /var/log/restsql:/var/log/restsql restsql/service
```
This creates the container with the following characteristics:
- Uses the latest image in repository restsql/service
- Names it restsql
- Runs tomcat in daemon mode (background process)
- Exposes service on port 8080 to host processes and binds to its external interfaces.
- Exposes log files to local file system `/var/log/restsql`.
- Binds mysqld container into the service container, mapping it's IP address into the host name mysql. The port 3306 is also made available since this was exposed at mysqld container creation. See [restsql/mysql-sakila](https://hub.docker.com/r/restsql/mysql-sakila/) for details.
- Uses the container's restsql configuration at `/etc/opt/restsql`

If you want to productionize this, it is best to map the restsql configuration to the host's file system via a volume. This makes it easier to change restsql.properties and to edit/add/remove sql resource files. Without the volume, to change config, you'll need to use [docker exec](https://docs.docker.com/engine/reference/commandline/exec/) to open a shell and vi files, or [docker cp](https://docs.docker.com/engine/reference/commandline/cp/) to get files from the container, edit them on the host, and then write them back to the container. Furthermore, an unmapped config is subject to loss by human error. When the container is removed, all your config is also lost.

Use the docker run option `--volume host-path:container-path`. For example:
```console
$ docker run -d --link mysqld:mysql -p 8080:8080 --name restsql --volume /var/log/restsql:/var/log/restsql --volume /home/tripper/restsql-conf:/etc/opt/restsql restsql/service
```

## With your own MySQL database
Instead of the `--link` option use the docker run option `--add-host="Host:IP"`. Supposing your `database.url` restsql property uses the hostname dev-mysql1.example.com, this argument looks like: `--add-host="dev-mysql1.example.com:192.168.1.13"`. This adds the host name dev-mysql1.example.com at 192.168.1.13 into the container's `/etc/hosts`. Note that if you are running the db on the same host as the restsql container, you still can't use localhost. 127.0.0.1 refers to the localhost of the container. You also cannot put in two IP addresses. The option only accepts host-name:ip-address.

Here's an example full docker run command with the above host and ip address, and as mentioned in the Prerequisites the mapped volume for the configuration.

```console
$ docker run -d --add-host="dev-mysql1.example.com:192.168.1.13" -p 8080:8080 --name restsql --volume /var/log/restsql:/var/log/restsql --volume /home/tripper/restsql-conf:/etc/opt/restsql restsql/service
```

The database port is configured in the restsql.properties. See the Prerequisites.

## With your own PostgreSQL database
As above, you'll be using the `--add-host=your-postgresql-hostname:ip-address` and the `--volume /your/configuration/dir:/etc/opt/restsql`. If your postgre host was dev.postgresql.example.com on 192.168.25.11, then the full docker command is:

```console
$ docker run -d --add-host="dev.postgresql.example.com:192.168.25.11" -p 8080:8080 --name restsql --volume /var/log/restsql:/var/log/restsql --volume /home/tripper/restsql-conf:/etc/opt/restsql restsql/service
```

The database port is configured in the restsql.properties. See the Prerequisites.

## Validation
Validate the service by accessing the console: curl or open your browser to `http://host:port/restsql/`.

If that doesn't open:
* check for errors in the tomcat catalina logs by executing `docker logs restsql`
* check for errors in the log `/var/log/reststql/internal.log`.

If you need to go deeper and have a look around, open a shell in the container like this:
```console
$docker exec -it restsql /bin/sh
```

If you want to copy files out from or into the container, use [docker cp](https://docs.docker.com/engine/reference/commandline/cp/).

# For more help
See [restSQL Deployment](http://restsql.org/doc/Deployment.html) for more detail on restsql.properties customization.

# Next steps
Use the restsql home page at http://host:port/restsql/ for helpful links. You may want to auto-create resource definitions from any available schema from the tools link (http://host:port/restsql/tools/). If you are using restsql/mysql-sakila you can auto-create resources from all tables in the sakila schema.

Explore restSQL [Concepts](http://restsql.org/doc/Concepts.html), [Architecture](http://restsql.org/doc/Architecture.html) and the [HTTP API reference](http://restsql.org/doc/api/index.html).

# Logging
See [Logging](http://restsql.org/doc/Logging.html) for restsql logging. All four of restSQL's logs are rotated after 1MB until there are 9 backups, and then older ones are deleted. The example run commands above recommend mapping the host's /var/log/restsql to the container's for easier access.

Tomcat access logs are not mapped to the host file system, but they could be if desired. These live in /usr/local/tomcat/logs. These are rotated daily by Tomcat. A cron job runs daily at 2am UTC that deletes those older than three days. You can change this retention policy by passing in an environment variable with the number of days. For example to set to 14 days retention, add the option `--env TOMCAT_LOG_RETENTION_DAYS=14` to docker run.

# Supported Docker versions
This image was tested on Docker version 18.06.

Please see [the Docker installation documentation](https://docs.docker.com/installation/) for details on how to upgrade your Docker daemon.

# Issues
If you have any problems with or questions about this image or restSQL, please contact us through a [GitHub issue](http://github.com/restsql/restsql/issues) or see the [Support Overview](http://restsql.org/doc/Support.html).

# License
restSQL is licensed under the standard [MIT license](http://restsql.org/doc/License.html).

# Contributing
You are invited to contribute new features, fixes or updates, large or small, via github pull requests. See [restsql.org/Roadmap](http://restsql.org/doc/Roadmap.html) for more information.
