# Specify the distribution
FROM debian:bullseye

# UDPATE & INSTALLATION
RUN apt-get update && apt-get upgrade -y
RUN apt install unzip php curl wget redis php-redis php-mysqli php-fpm php-cgi php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
RUN apt install default-mysql-client -y

# The installation of wordpress is done with WP-CLI (https://wp-cli.org/fr/)
# https://make.wordpress.org/cli/handbook/guides/installing/
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Create the folder of the website and give www-data access to it
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Modifying php config files
# Modify the listen port to 9000 and uncomment the 'clear_env' line to avoid problem with our environment
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Move the config script in the docker
COPY tools/init_wordpress.sh /var/www/init_wordpress.sh
RUN chmod +x /var/www/init_wordpress.sh


WORKDIR /var/www/html
EXPOSE 9000

CMD ["/var/wwww/init_wordpress.sh"]





