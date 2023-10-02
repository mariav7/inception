#	Allows us to tell Docker under which OS our VM should run
FROM	alpine:3.17

#	Allows us to launch a command on our VM
#	Install MariaDB
RUN		apk update && apk upgrade &&\
		apk add mariadb mariadb-client

#	Simply indicates where our file to copy is located from the directory where our Dockerfile is located
#	Copy MariaDB configuration files
COPY	./conf/configure-mariadb.sh /tmp/configure-mariadb.sh
RUN		chmod +x /tmp/configure-mariadb.sh

# Run MariaDB configuration script as entry point
ENTRYPOINT	[ "sh", "/tmp/configure-mariadb.sh" ]

