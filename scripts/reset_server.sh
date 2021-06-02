#!/bin/bash

# /!\ WARNING: RESET EVERYTHING! 
# Remove all containers/networks/volumes/images and data in db

cd /opt/airflow
docker-compose down
docker rmi -f $(docker images -a -q)
docker system prune -f
docker volume prune -f
docker network prune -f
