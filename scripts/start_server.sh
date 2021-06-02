#!/bin/bash

# Build the base images from which are based the Dockerfiles
# then Startup all the containers at once 
# docker build -t spark-base docker/spark/spark-base && \

cd /opt/airflow
sudo chmod 777 /opt/airflow/logs
sudo chmod 777 /opt/airflow/temp
docker-compose up -d --build
