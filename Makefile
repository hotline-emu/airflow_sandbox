-include .env

DOCKER_COMPOSE = docker-compose
CONTAINER_NAME_POSTGRES = postgres
CONTAINER_NAME_AIRFLOW_WEB = airflow-webserver
CONTAINER_NAME_AIRFLOW_SCHEDULER = airflow-scheduler

default: help

help:
	@powershell -Command "
	$makefile = Get-Content $(MAKEFILE_LIST);
	$makefile | Where-Object { $_ -match '^[a-zA-Z_-]+:.*?## ' } |
	ForEach-Object {
		$target = $_ -replace '^(.*?)(##.*)', '$($matches[1])';
		$comment = $_ -replace '^[^#]*## ', '';
		Write-Output ('`t' + $target + '  ' + $comment)
	}"

install: ## Install dependencies
	poetry install

up: ## The default target is to bring up the containers
	$(DOCKER_COMPOSE) up -d  ## Start all services defined in docker-compose.yml in detached mode (-d)

down: ## Stop the containers
	$(DOCKER_COMPOSE) down  ## Stop and remove all services (containers, networks, volumes, etc.) defined in docker-compose.yml

logs-web: ## View logs from the Airflow webserverweb:
	$(DOCKER_COMPOSE) logs -f $(CONTAINER_NAME_AIRFLOW_WEB)  ## Tail logs of the Airflow webserver container (-f to follow)

logs-scheduler: ## View logs from the Airflow schedulerscheduler:
	$(DOCKER_COMPOSE) logs -f $(CONTAINER_NAME_AIRFLOW_SCHEDULER)  ## Tail logs of the Airflow scheduler container (-f to follow)

ps: ## Check the status of running containers
	$(DOCKER_COMPOSE) ps  ## List all running containers and their status (from docker-compose)

init-db: ## Initialize the Airflow database (useful if you haven't already)db:
	$(DOCKER_COMPOSE) run --rm airflow-webserver airflow db init  ## Run the `airflow db init` command to initialize the Airflow database

webserver: ## Run Airflow webserver manually (if needed)
	$(DOCKER_COMPOSE) run --rm airflow-webserver airflow webserver  ## Run the Airflow webserver in a one-off container

scheduler: ## Run Airflow scheduler manually (if needed)
	$(DOCKER_COMPOSE) run --rm airflow-scheduler airflow scheduler  ## Run the Airflow scheduler in a one-off container
