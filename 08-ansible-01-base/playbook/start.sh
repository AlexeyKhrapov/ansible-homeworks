#!/usr/local/env bash
docker-compose up -d
ansible-playbook site.yml -i inventory/prod.yml --vault-password-file pass
docker-compose down
