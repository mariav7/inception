#!/bin/sh
service mariadb start
sleep 2

# CREATE WORDPRESS DATABASE #
echo "CREATE DATABASE IF NOT EXISTS $BDD_NAME;" | mysql

# CREATE USER #
echo "CREATE USER IF NOT EXISTS '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';" | mysql

# PRIVILEGES USER FOR ALL IP ADRESS #
echo "GRANT ALL PRIVILEGES ON *.* TO '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';" | mysql
echo "FLUSH PRIVILEGES;" | mysql

# FORCE AUTHENTIFICATION WITH PASSWORD FOR ROOT
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$BDD_ROOT_PASSWORD';" | mysql

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld

echo "MariaDB database and user were created successfully! "
