declare P_SSH_USERNAME=$1
declare P_PYTHON_VERSION=$2

# Setup the python environment
source InstallAndConfigureDevelopmentTools.sh $P_SSH_USERNAME $P_PYTHON_VERSION

# Install airflow on the python environment
source InstallAirflowWithDependencies.sh

# Define the environment variables needed to connect with the other resources in our 
# Celery executor architecture
#source DefineAirflowEnvironmentVariables.sh $P_SSH_USERNAME $P_AIRFLOW_DATABASE $P_MYSQL_SERVER_USERNAME $P_MYSQL_SERVER_PASSWORD $P_MYSQL_SERVER_HOSTNAME $P_RABBITMQ_QUEUENAME $P_RABBITMQ_VHOST $P_RABBITMQ_USERNAME $P_RABBITMQ_PASSWORD $P_RABBITMQ_HOSTNAME $P_SA_EMAIL $P_SA_PASSWORD

unset P_SSH_USERNAME
unset P_PYTHON_VERSION
