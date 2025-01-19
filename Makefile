SHELL := /bin/bash

# 1) .env varsa içe al (isteğe bağlı)
-include .env
export $(shell sed 's/=.*//' .env 2>/dev/null)

# 2) SSH_USER boş ise whoami sonucuna ayarla
SSH_USER ?= $(shell whoami)

init:
	cd src && terraform init

apply:
	cd src && terraform apply -auto-approve -var "project_id=$(PROJECT_ID)"

destroy:
	cd src && terraform destroy -auto-approve -var "project_id=$(PROJECT_ID)"

ssh-manager-%:
	@IP=$$(cd src && terraform output -json manager_public_ips | jq -r .[$*]); \
	echo "Connecting to manager-$* ($$IP) with user: $(SSH_USER)"; \
	ssh -o StrictHostKeyChecking=no $(SSH_USER)@$$IP

ssh-worker-%:
	@IP=$$(cd src && terraform output -json worker_public_ips | jq -r .[$*]); \
	echo "Connecting to worker-$* ($$IP) with user: $(SSH_USER)"; \
	ssh -o StrictHostKeyChecking=no $(SSH_USER)@$$IP

printenv:
	@echo "PROJECT_ID = $(PROJECT_ID)"
	@echo "GOOGLE_APPLICATION_CREDENTIALS = $(GOOGLE_APPLICATION_CREDENTIALS)"
	@echo "SSH_USER = $(SSH_USER)"
