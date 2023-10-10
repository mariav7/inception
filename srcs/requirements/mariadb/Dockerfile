FROM    debian:bullseye

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install mariadb-server mariadb-client -y

#   Create mysql service directory to store data related to mysql service,
#   such as configuration files, logs, and data files.
#   We do this to help keep the service data organized
#   and separate from other system data, to make it easier to manage and backup.
# RUN mkdir -p /run/mysqld /var/lib/mysql
#RUN chown -R mysql:root /run/mysqld
# RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod -R 755 /var/run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql && \
    chmod -R 755 /var/lib/mysql && \
    mkdir -p /var/log/mysql && \
    chown -R mysql:mysql /var/log/mysql && \
    chmod -R 755 /var/log/mysql

#   mysql_install_db, script provided by the mysql package that is used to initialize
#   the directory for a mysql database server
#   It creates the necessary system tables, initializes the data directory, and sets up
#   the root user with a default password

#   When the docker image is built from this dockerfile
#   the directory will be initialized and ready for use 
#   when a container is started from the image

#   Copy the my.cnf file into the directory /etc/mysql/, in the my 50-server.cnf file we specify the port and set
#   bind-address=0.0.0.0 to allow the mariadb server to listen for connections from any IP address, including
#   the IP addresses from other containers and the host machine
# COPY    ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY ./conf/50-server.cnf /etc/mysql/
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

#   Copy the script in the docker image
COPY    ./tools/init_database.sh /tmp/

#   Make sure that we can execute the script
RUN chmod +x /tmp/init_database.sh

#   Run MariaDB configuration script as entry point
ENTRYPOINT  [ "/tmp/init_database.sh" ]
