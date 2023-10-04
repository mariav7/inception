#!/bin/bash

echo "Waiting 10 seconds before starting initialization script..."
sleep 10

# Avoid PHP running problems
if [ ! -d "/run/php" ]; then
	mkdir -p /run/php
	touch /run/php/php7.3-fpm.pid
fi

cd /var/www/html
echo "Checking for wordpress installation..."
# Download wordpress if isn't already done
if [ ! -f "wp-config-sample.php" ]; then
	echo "=> Downloading wordpress..."
	php wp-cli.phar --info
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
	wp core download --allow-root
	echo "=> Done!"
fi
echo "OK!"

echo "Checking for wordpress configuration..."
# Check if the configuration of wordpress is already done, if not, start the configuration and installation
# https://make.wordpress.org/cli/handbook/how-to/how-to-install/
if [ ! -f "wp-config.php" ]; then
	echo "=> Create config file..."
	wp config create --dbname=$BDD_NAME \
					 --dbuser=$BDD_USER \
					 --dbpass=$BDD_USER_PASSWORD \
					 --dbhost=$BDD_HOST --path='/var/www/html' \
					 --allow-root

	echo "=> Done!"

	echo "=> Installing wordpress..."
	wp core install --url="mflores.42.fr" \
					--title="Inception" \
					--admin_user=$WP_ADMIN_USER \
					--admin_password=$WP_ADMIN_PASSWORD \
					--admin_email=$WP_ADMIN_EMAIL \
					--allow-root
    # wp theme install neve --activate --allow-root
    # wp config set WP_REDIS_HOST redis --add --allow-root
    # wp config set WP_REDIS_PORT 6379 --add --allow-root  
    # wp config set WP_CACHE true --add --allow-root  
    # wp plugin install redis-cache --activate --allow-root  
    # wp plugin update --all --allow-root  
    # wp redis enable --allow-root  
	echo "=> Done!"
fi
echo "OK!"

echo "Checking for user configuration..."
# Create another user (admin user already exists thanks to the wp core install)
# https://developer.wordpress.org/cli/commands/user/
if [[ -z $(wp user get $WP_USER --allow-root) ]]; then
	echo "=> Creating new user ($WP_USER)"
	wp user create $WP_USER $WP_USER_EMAIL \
				   --user_pass=$WP_USER_PASSWORD \
                   --role=$WP_USER_ROLE \
                   --porcelain \
				   --allow-root
	echo "=> Done!"
fi
echo "OK!"

echo "Container now running php-fpm."
/usr/sbin/php-fpm7.3 -F -R
