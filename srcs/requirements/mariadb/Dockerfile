#	Allows us to tell Docker under which OS our VM should run
FROM	debian:bullseye

#	Allows us to launch a command on our VM
#	Install MariaDB
RUN	apt-get update
RUN	apt install mariadb-server -y

#	Copy MariaDB configuration files
#	Copy our config file and our script to configure and init mysql database
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

#   Copy the script in the images and modify the execution rights of it
COPY ./tools/init_database.sh /tmp

#   Make sure that we can execute the script
RUN chmod +x /tmp/init_database.sh

EXPOSE 3306

#   Run MariaDB configuration script as entry point
ENTRYPOINT	[ "/tmp/init_database.sh" ]
