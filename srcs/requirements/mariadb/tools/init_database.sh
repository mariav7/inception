#!/bin/sh

# Check if MariaDB is already running
if ! service mariadb status > /dev/null; then
    echo "=> MariaDB is not running, starting it..."
    service mariadb start
else
    echo "=> MariaDB is already running."
fi

echo "=> Check for \`$BDD_NAME\` database..."
#   Check if the wordpress database is already created
if [ ! -d "/var/lib/mysql/$BDD_NAME" ]; then

    sleep 2

    # CREATE WORDPRESS DATABASE
    mysql -e "CREATE DATABASE IF NOT EXISTS $BDD_NAME;"

    # CREATE USER
    mysql -e "CREATE USER IF NOT EXISTS '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';"

    # PRIVILEGES USER FOR ALL IP ADRESSES
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$BDD_USER'@'%' IDENTIFIED BY '$BDD_USER_PASSWORD';"

    mysql -e "FLUSH PRIVILEGES;"

    # FORCE AUTHENTIFICATION WITH PASSWORD FOR ROOT
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$BDD_ROOT_PASSWORD';"

    echo "=> MariaDB database and user were created successfully! "
fi

# Shutdown MariaDB gracefully if it was started in this script
if [ -f /var/run/mysqld/mysqld.pid ]; then
    echo "=> Shutting down MariaDB..."
    kill $(cat /var/run/mysqld/mysqld.pid)
    exec mysqld
fi
