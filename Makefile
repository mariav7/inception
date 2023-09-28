# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mflores- <mflores-@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/28 14:02:21 by mflores-          #+#    #+#              #
#    Updated: 2023/09/28 14:28:31 by mflores-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

LOGIN		= mflores-
DOMAIN		= ${LOGIN}.42.fr
DATA_PATH	= /home/${LOGIN}/data
ENV			= LOGIN=${LOGIN} DATA_PATH=${DATA_PATH} DOMAIN=${LOGIN}.42.fr 

all: up

up: setup
	${ENV} docker-compose -f ./srcs/docker-compose.yaml up -d --build

down:
	${ENV} docker-compose -f ./srcs/docker-compose.yaml down

start:
	${ENV} docker-compose -f ./srcs/docker-compose.yaml start

stop:
	${ENV} docker-compose -f ./srcs/docker-compose.yaml stop

status:
	cd srcs && docker-compose ps && cd ..

logs:
	cd srcs && docker-compose logs && cd ..

setup:
	${ENV} ./configure-login.sh
	${ENV} ./configure-hosts.sh
	sudo mkdir -p /home/${LOGIN}/
	sudo mkdir -p ${DATA_PATH}
	sudo mkdir -p ${DATA_PATH}/mariadb-data
	sudo mkdir -p ${DATA_PATH}/wordpress-data

clean:
	sudo rm -rf ${DATA_PATH}

fclean: clean
	${ENV} ./anonymize-login.sh
	docker system prune -f -a --volumes
	docker volume rm srcs_mariadb-data srcs_wordpress-data

.PHONY: all up down start stop status logs prune clean fclean
