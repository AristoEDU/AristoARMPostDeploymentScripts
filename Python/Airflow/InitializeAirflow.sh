declare P_ENVIRONMENT=$1

git clone https://github.com/AristoEDU/AristoAirflow.git

cd ~/AristoAirflow

# We can't seem to import the variables unles the db is inited but
# airflow imports the dags as part of the initdb process, causing
# and error so we have to init, import and init again.
airflow initdb

if [ "$P_ENVIRONMENT" = "Prod" ]
  airflow variables --i ./AristoVariables.var
else
  airflow variables --i ./AristoVariables-Dev.var
fi

airflow initdb

# Launch out webserver, scheduler and worker



unset P_ENVIRONMENT
