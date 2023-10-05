#!/bin/sh

#	mysql command is a client for connecting and communicating with the
#	the MYSQL database.
#	-u root specifies that the client should connect as the root user,
#	which has admin privileges

#	ALTER USER is used to modify the properties of an existing user
#	in this case we are setting the password for the root user of the MYSQL instance

#	DELETE FROM lines are for security, the first one deletes all users from the MYSQL
#	instance except for the root
#	removes all root users that can connect from hosts other than localhost, 127.0.0.1, or ::1.
#	remove also all users where the user column is an empty string

#	Then we create a a new user, and specify its password, this user can connect from any machine
#	on the network
#	we grant all privileges, meaning the user will be able to have full access to the database
#	and perform any action

#	Flushing the privileges allows to reload the MSQL server's grant tables and update the in-memory
#	privileges with any changes made.

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





echo "Check for \`mysql\` database..."
# Create mysql database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "=> mysql database doesn't exists, creating one!"

	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
	chown -R mysql:mysql /var/lib/mysql

	echo "=> Done!"
fi
echo "OK!"

echo "Check for \`wordpress\` database..."
# Check if the wordpress database is already created
if [ ! -d "/var/lib/mysql/wordpress" ]; then
	echo "=> Creating wordpress database and basic user configuration..."

	cat << EOF > /tmp/querys_database.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE user='';
DELETE FROM mysql.user WHERE user='root' AND host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS wordpress CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '${SQL_USERNAME}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON wordpress.* TO '${SQL_USERNAME}'@'%';
FLUSH PRIVILEGES;
EOF

	chmod 777 /tmp/querys_database.sql
	mysqld --user=mysql --verbose --bootstrap < /tmp/querys_database.sql
	rm -f /tmp/querys_database.sql

	echo "=> Done!"
fi
echo "OK!"

echo "Container now runnig mysqld."
exec mysqld