#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then
    until mysqladmin -hmariadb -u${WP_ADMIN_USER} -p${WP_ADMIN_PASSWORD} ping; do
        sleep 2
    done
        cd /var/www/html
        rm -rf *
        wp core download --allow-root
        wp config create --dbname=${BDD_NAME} --dbuser=${BDD_USER} --dbpass=${BDD_USER_PASSWORD} --dbhost=${BDD_HOST} --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
        wp core install --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${BDD_USER} --admin_password=${BDD_USER_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --skip-email --allow-root
        wp user create ${WP_USER} ${WP_USER_EMAIL} --role=${WP_USER_ROLE} --user_pass=${WP_USER_PASSWORD} --allow-root 
fi

php-fpm7.4 -F -R
