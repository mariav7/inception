#!/bin/bash

#   Check if the wordpress database is already created
echo "=> Checking if \`$BDD_NAME\` database exists . . ."
if [ ! -d "/var/lib/mysql/$BDD_NAME" ]; then

    # Check if MariaDB is already running
    if ! service mariadb status > /dev/null; then
        echo "=> MariaDB is not running, starting it..."
        service mariadb start
    else
        echo "=> MariaDB is already running."
    fi

    echo "=> Waiting for MariaDB to start..."
    while ! mysqladmin ping -hlocalhost -uroot -p"$BDD_ROOT_PASSWORD" --silent; do
        sleep 2
        echo "Waiting for MariaDB to start..."
    done

    sleep 2

    # CREATE WORDPRESS DATABASE
    mysql -e "CREATE DATABASE IF NOT EXISTS $BDD_NAME;"

    # CREATE USER
    mysql -e "CREATE USER IF NOT EXISTS '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';"

    # PRIVILEGES USER FOR ALL IP ADRESSES
    mysql -e "GRANT ALL PRIVILEGES ON $BDD_NAME.* TO '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';"

    mysql -e "FLUSH PRIVILEGES;"

    # FORCE AUTHENTIFICATION WITH PASSWORD FOR ROOT
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$BDD_ROOT_PASSWORD';"

    mysqladmin -u root -p${BDD_ROOT_PASSWORD} shutdown

    echo "=> MariaDB database and user were created successfully! "

    # Shutdown MariaDB gracefully if it was started in this script
    if [ -f /var/run/mysqld/mysqld.pid ]; then
        echo "=> Shutting down MariaDB..."
        # service mariadb stop
        sleep 2
        kill $(cat /var/run/mysqld/mysqld.pid)
    fi

fi

exec mysqld
# exec mysqld_safe
