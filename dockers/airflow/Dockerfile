FROM python:3.7-slim
LABEL maintainer="Jae"

ARG AIRFLOW_VERSION=2.0.1
ARG AIRFLOW_HOME=/opt/airflow

USER root
# Export the environment variable AIRFLOW_HOME where airflow will be installed
ENV AIRFLOW_HOME=${AIRFLOW_HOME}

# install microsoft odbc packages
RUN apt-get update -y && apt-get install -y curl gnupg2
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install dependencies and tools
RUN apt-get update -yqq && \
    apt-get upgrade -yqq && \
    apt-get install -yqq --no-install-recommends \
    wget \
    libczmq-dev \
    libssl-dev \
    git \
    inetutils-telnet \
    bind9utils freetds-dev \
    libkrb5-dev \
    libsasl2-dev \
    libffi-dev libpq-dev \
    freetds-bin build-essential \
    default-libmysqlclient-dev \
    apt-utils \
    rsync \
    zip \
    unzip \
    gcc \
    vim \
    locales \
    unixodbc-dev \
    libgssapi-krb5-2 \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools \
    && apt-get autoremove -yqq --purge && apt-get clean

COPY ./requirements.txt ./requirements.txt
# Upgrade pip
# Create airflow user 
# Install apache airflow with subpackages
RUN pip install --upgrade pip && \
    useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow && \
    pip install mechanize==0.4.5 & \
    pip install boto3==1.15.18 & \
    pip install apache-airflow-providers-microsoft-mssql==1.1.0 & \
    pip install apache-airflow[postgres]==${AIRFLOW_VERSION} --constraint ./requirements.txt

# include mssql-tool to bash
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
    source ~/.bashrc

# Copy the entrypoint.sh from host to container (at path AIRFLOW_HOME)
COPY ./entrypoint.sh ./entrypoint.sh

# Set the entrypoint.sh file to be executable
RUN chmod +x ./entrypoint.sh

# Set the owner of the files in AIRFLOW_HOME to the user airflow
RUN chown -R airflow: ${AIRFLOW_HOME}

# Set the username to use
USER airflow

# Set workdir (it's like a cd inside the container)
WORKDIR ${AIRFLOW_HOME}

# Create the dags folder which will contain the DAGs inside $AIRFLOW_HOME
RUN mkdir dags
# Create the temp folder inside $AIRFLOW_HOME
RUN mkdir temp

# Expose ports (just to indicate that this container needs to map port)
EXPOSE 8080

# Execute the entrypoint.sh
ENTRYPOINT  [ "/entrypoint.sh" ]
