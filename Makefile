SRCS_PATH = ./srcs/
YML_FILE = docker-compose.yml
COMPOSE_FILE = $(addprefix $(SRCS_PATH), $(YML_FILE))

DB_FOLDER = /data/
DB_PATH = $(addprefix $(HOME), $(DB_FOLDER))

all: header
	@echo "$(YELLOW)\n. . . Launching . . .\n$(RESET)"
	@sudo mkdir -p $(DB_PATH)mariadb $(DB_PATH)wordpress
	@sudo docker compose -f $(COMPOSE_FILE) up --build -d
	@echo "$(BOLD)$(GREEN)Launched [ ✔ ]\n$(RESET)"

install :
	@echo "$(YELLOW)\n. . . apt updating && upgrading . . . \n$(RESET)"
	@sudo apt-get update 
	@sudo apt-get upgrade -y
	@echo "$(BOLD)$(GREEN)apt update && upgrade [ ✔ ]\n$(RESET)"

restart :
	@echo "$(YELLOW)\n. . . restarting containers . . . \n$(RESET)"
	@sudo docker compose -f $(COMPOSE_FILE) stop
	@sudo docker compose -f $(COMPOSE_FILE) start
	@echo "$(BOLD)$(GREEN)Containers restarted [ ✔ ]\n$(RESET)"

stop:
	@echo "$(YELLOW)\n. . . stopping containers . . . \n$(RESET)"
	@sudo docker compose -f $(COMPOSE_FILE) down
	@echo "$(BOLD)$(GREEN)Stopped containers [ ✔ ]\n$(RESET)"

clean: stop
	@echo "$(YELLOW)\n. . . deleting volumes . . . \n$(RESET)"
	@sudo docker volume rm $$(docker volume ls -q)
	@echo "$(BOLD)$(GREEN)Cleaned [ ✔ ]\n$(RESET)"

fclean: clean
	@echo "$(YELLOW)\n. . . deleting images . . . \n$(RESET)"
	@sudo docker rmi -f $$(docker images -aq)
	@sudo rm -rdf $(DB_PATH)
	@echo "$(BOLD)$(GREEN)Fcleaned [ ✔ ]\n$(RESET)"

re: fclean all

prune:
	@echo "$(YELLOW)\n. . . pruning . . . \n$(RESET)"
	@sudo docker system prune -fa
	@echo "$(BOLD)$(GREEN)Pruned [ ✔ ]\n$(RESET)"

.PHONY: all install restart stop down clean fclean re prune header check-isclean

check-isclean:
	@echo "$(YELLOW)docker ps -a $(RESET)" && docker ps -a
	@echo "$(YELLOW)docker images -a $(RESET)" && docker images -a
	@echo "$(YELLOW)docker volume ls $(RESET)" && docker volume ls
	@echo "$(YELLOW)docker network ls $(RESET)" && docker network ls

define HEADER_PROJECT

	 _                      _   _              
	(_)                    | | (_)             
	 _ _ __   ___ ___ _ __ | |_ _  ___  _ __   
	| | '_ \ / __/ _ \ '_ \| __| |/ _ \| '_ \  
	| | | | | (_|  __/ |_) | |_| | (_) | | | | 
	|_|_| |_|\___\___| .__/ \__|_|\___/|_| |_| 
	                 | |                       
	                 |_|                       

endef
export HEADER_PROJECT

header:
	clear
	@echo "$(BOLD) $(DMAGENTA)$$HEADER_PROJECT $(RESET)"

# COLORS
RESET = \033[0m
WHITE = \033[37m
GREY = \033[90m
RED = \033[91m
DRED = \033[31m
GREEN = \033[92m
DGREEN = \033[32m
YELLOW = \033[93m
DYELLOW = \033[33m
BLUE = \033[94m
DBLUE = \033[34m
MAGENTA = \033[95m
DMAGENTA = \033[35m
CYAN = \033[96m
DCYAN = \033[36m

# FORMAT
BOLD = \033[1m
ITALIC = \033[3m
UNDERLINE = \033[4m
STRIKETHROUGH = \033[9m
