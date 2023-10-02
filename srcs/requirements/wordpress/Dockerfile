# Specify the distribution
FROM debian:bullseye

# UDPATE & INSTALLATION
RUN apt-get update && apt-get upgrade -y
RUN apt install unzip php curl wget redis php-redis php-mysqli php-fpm php-cgi php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
RUN apt install default-mysql-client -y

# Modifying php config files
# Modify the listen port to 9000 and uncomment the 'clear_env' line to avoid problem with our environment
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/
RUN	mkdir /run/php

# Move the config script in the docker
COPY ./tools/init_wordpress.sh /home/
RUN chmod 777 /home/init_wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/home/init_wordpress.sh"]





