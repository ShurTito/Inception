name = Inception
data_dir = ~/data
mariadb_dir = $(data_dir)/mariadb
wordpress_dir = $(data_dir)/wordpress
docker_compose_file = ./srcs/docker-compose.yml
env_file = ~/.env

define create_dirs
	@mkdir -p $(data_dir) $(mariadb_dir) $(wordpress_dir)
endef

all:
	@echo "Configuring ${name}..."
	$(create_dirs)
	@docker-compose -f $(docker_compose_file) --env-file $(env_file) up -d

build:
	@echo "Building ${name} configuration..."
	$(create_dirs)
	@docker-compose -f $(docker_compose_file) --env-file $(env_file) up -d --build

down:
	@echo "Stopping ${name}..."
	@docker-compose -f $(docker_compose_file) --env-file $(env_file) down

re: down
	@echo "Rebuilding ${name}..."
	$(create_dirs)
	@docker-compose -f $(docker_compose_file) --env-file $(env_file) up -d --build

clean: down
	@echo "Cleaning ${name}..."
	@docker system prune -a -f
	@sudo chmod -R 777 $(data_dir)
	@sudo rm -rf $(wordpress_dir)/* $(mariadb_dir)/*

fclean:
	@echo "Full cleaning ${name}..."
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@docker volume rm $$(docker volume ls -q)
	@sudo chmod -R 777 $(data_dir)
	@sudo rm -rf $(mariadb_dir)/* $(wordpress_dir)/* $(data_dir)/* $(data_dir)

.PHONY: all build down re clean fclean
