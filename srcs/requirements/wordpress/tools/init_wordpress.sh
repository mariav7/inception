#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then

    sleep 10

    cd /var/www/html

    wp core download --allow-root

    wp config create --dbname=${BDD_NAME} \
                    --dbuser=${BDD_USER} \
                    --dbpass=${BDD_USER_PASSWORD} \
                    --dbhost=${BDD_HOST} \
                    --allow-root

    wp core install --url=${DOMAIN_NAME} \
                    --title=${WP_TITLE} \
                    --admin_user=${WP_ADMIN_USER} \
                    --admin_password=${WP_ADMIN_PASSWORD} \
                    --admin_email=${WP_ADMIN_EMAIL} \
                    --skip-email --allow-root

    wp user create ${WP_USER} ${WP_USER_EMAIL} \
                    --user_pass=${WP_USER_PASSWORD} \
                    --role=${WP_USER_ROLE} \
                    --allow-root

    wp theme activate twentytwentytwo --allow-root

fi

php-fpm7.4 -F -R
