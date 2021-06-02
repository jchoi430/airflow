#!/usr/bin/env bash

echo "starting entrypoint"
CMD="airflow"

# Init. the metadatabase
$CMD db init

echo "creating airflow user"
# Create User
# python scripts/webserver_config.py
airflow users create -e "jchoi@airflow.com" \
-f "airflow" \
-l "airflow" \
-p "airflow" \
-r "Admin" \
-u "airflow"

echo "start scheduler and webserver"
# Run the scheduler in background
$CMD scheduler &> /dev/null &

# run airflow webserver in foreground (for docker logs)
exec $CMD webserver 
