all:
	@sudo mkdir -p /home/mflores-/data/mariadb /home/mflores-/data/wordpress
	@docker-compose -f ./srcs/docker-compose.yml up --build -d

install :
	@sudo apt-get update 
	@sudo apt-get upgrade -y
	@sudo mkdir -p /home/mflores-/data/mariadb /home/mflores-/data/wordpress
	
restart :
	@docker-compose -f ./srcs/docker-compose.yml stop
	@docker-compose -f ./srcs/docker-compose.yml start

stop:
	docker-compose -f ./srcs/docker-compose.yml down

clean:
	@docker rm -f $$(docker ps -qa)
	@docker volume rm -f $$(docker volume ls)
	@sudo rm -rdf /home/mflores-/data

prune:
	docker system prune -a

.PHONY: all install restart stop down clean prune