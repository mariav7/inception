#!/bin/sh
service mariadb start 

# CREATE USER #
echo "CREATE USER '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';" | mysql

# PRIVILEGES FOR ROOT AND USER FOR ALL IP ADRESSES #
echo "GRANT ALL PRIVILEGES ON *.* TO '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';" | mysql
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$BDD_ROOT_PASSWORD';" | mysql
echo "FLUSH PRIVILEGES;" | mysql

# CREAT WORDPRESS DATABASE #
echo "CREATE DATABASE $BDD_NAME;" | mysql

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld