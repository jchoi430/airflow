# airflow-docker 2.0 with local executor
Apache Airflow is a workflow management platform, which can help to schedule and monitor the workflows (batch jobs) easily.
The Airflow runs on the docker container

## Run in local

```sh
docker-compose up -d --build
```

## To stop in local
```sh
docker-compose down
```

## to reset in local
```sh
docker-compose down
rm -rf ./postgres-data/*
docker rmi -f $(docker images -a -q)
docker system prune -f
docker volume prune -f
docker network prune -f
```

## Description

This project creates a full working Airflow environment using Docker containers.

It uses the Local Executor, PostgreSQL as the core Airflow database.
All the configuration is done in the `airflow.cfg` file that comes with the airflow installation.    

To generate fernet
```
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
```


All the necessary Airflow processes including `airflow initdb` command, and airflow.
By default, the webserver forwards the port 8080 to the host so you can go to `localhost:8080` in local env.

The python dependencies are specified in the Dockerfile for now in case you need to add more packages.

The Dags and Plugins folder are mounted into the webserver, worker and scheduler so you can modify them and see the changes immediatly. If you see
some file stuck in an old state, it's better to restart (and maybe rebuild) the whole project.

## Tips

- Use `docker-compose logs -f` to troubleshoot errors
- You can open bash sessions inside the containers to test airflow commands: `docker-compose exec worker bash` or `docker-compose run --rm worker airflow list_dags`
