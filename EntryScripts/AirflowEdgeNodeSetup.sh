declare P_SSH_USERNAME=$1
declare P_PYTHON_VERSION=$2
declare P_AIRFLOW_DATABASE=$3
declare P_MYSQL_SERVER_USERNAME=$4
declare P_MYSQL_SERVER_PASSWORD=$5
declare P_MYSQL_SERVER_HOSTNAME=$6
declare P_RABBITMQ_QUEUENAME=$7
declare P_RABBITMQ_VHOST=$8
declare P_RABBITMQ_USERNAME=$9
declare P_RABBITMQ_PASSWORD=${10}
declare P_RABBITMQ_HOSTNAME=${11}
declare P_SA_EMAIL=${12}
declare P_SA_PASSWORD=${13}

# Setup the python environment
source InstallAndConfigureDevelopmentTools.sh $P_SSH_USERNAME $P_PYTHON_VERSION

# Install airflow on the python environment
source InstallAirflowWithDependencies.sh

# Define the environment variables needed to connect with the other resources in our 
# Celery executor architecture
source DefineAirflowEnvironmentVariables.sh $P_SSH_USERNAME $P_AIRFLOW_DATABASE $P_MYSQL_SERVER_USERNAME $P_MYSQL_SERVER_PASSWORD $P_MYSQL_SERVER_HOSTNAME $P_RABBITMQ_QUEUENAME $P_RABBITMQ_VHOST $P_RABBITMQ_USERNAME $P_RABBITMQ_PASSWORD $P_RABBITMQ_HOSTNAME $P_SA_EMAIL $P_SA_PASSWORD

unset P_SSH_USERNAME
unset P_PYTHON_VERSION
unset P_AIRFLOW_DATABASE
unset P_MYSQL_SERVER_USERNAME
unset P_MYSQL_SERVER_PASSWORD
unset P_MYSQL_SERVER_HOSTNAME
unset P_RABBITMQ_QUEUENAME
unset P_RABBITMQ_VHOST
unset P_RABBITMQ_USERNAME
unset P_RABBITMQ_PASSWORD
unset P_RABBITMQ_HOSTNAME
unset P_SA_EMAIL
unset P_SA_PASSWORD