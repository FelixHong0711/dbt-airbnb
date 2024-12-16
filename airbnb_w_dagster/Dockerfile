FROM python:3.11
 
ENV DAGSTER_HOME=/opt/dagster/dagster_home/
RUN mkdir -p $DAGSTER_HOME
 
# Install dependencies
COPY ./airbnb_dbt/dbt_requirements.txt .
RUN pip install -r dbt_requirements.txt
 
# Copy code and workspace to /opt/dagster/app
RUN mkdir -p /opt/dagster/app
COPY ./workspace.yaml /opt/dagster/app
COPY ./airbnb_w_dagster /opt/dagster/app/airbnb_dagster
COPY ./airbnb_dbt /opt/dagster/app/airbnb_dbt
 
# Copy dagster.yml to $DAGSTER_HOME
COPY ./dagster.yaml $DAGSTER_HOME
 
WORKDIR /opt/dagster/app