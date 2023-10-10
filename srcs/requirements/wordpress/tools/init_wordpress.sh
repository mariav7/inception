#!/bin/sh

echo "=> Waiting 10 seconds before starting initialization script..."

sleep 10

cd /var/www/html

# Avoid PHP running problems
if [ ! -d "/run/php" ]; then
	mkdir -p /run/php
fi

echo "=> Checking for WordPress installation..."

if [ ! -f "wp-config-sample.php" ]; then
	echo "=> Downloading wordpress..."
	wp core download --allow-root
	echo "=> Done!"
fi

if [ ! -f "wp-config.php" ]; then

	echo "=> Create config file . . ."
    wp config create --dbname=${BDD_NAME} \
                    --dbuser=${BDD_USER} \
                    --dbpass=${BDD_USER_PASSWORD} \
                    --dbhost=${BDD_HOST}:3306 --path='/var/www/html' \
                    --allow-root
	echo "=> Done!"

	echo "=> Installing WordPress . . ."
    wp core install --url=${DOMAIN_NAME} \
                    --title=${WP_TITLE} \
                    --admin_user=${WP_ADMIN_USER} \
                    --admin_password=${WP_ADMIN_PASSWORD} \
                    --admin_email=${WP_ADMIN_EMAIL} \
                    --skip-email --allow-root
    echo "=> Done!"

    echo "=> Creating new user ($WP_USER)"
    wp user create ${WP_USER} ${WP_USER_EMAIL} \
                    --user_pass=${WP_USER_PASSWORD} \
                    --role=${WP_USER_ROLE} \
                    --allow-root

    echo "=> Done!"

    echo "=> Activating WordPress theme . . ."
    wp theme activate twentytwentytwo --allow-root

fi

php-fpm7.4 -F -R
