declare SSH_USERNAME=$1
declare PYTHON_VERSION=$2
declare AIRFLOW_DATABASE=$3
declare MYSQL_SERVER_USERNAME=$4
declare MYSQL_SERVER_PASSWORD=$5
declare MYSQL_SERVER_HOSTNAME=$6
declare RABBITMQ_QUEUENAME=$7
declare RABBITMQ_VHOST=$8
declare RABBITMQ_USERNAME=$9
declare RABBITMQ_PASSWORD=${10}
declare RABBITMQ_HOSTNAME=${11}
declare SA_USERNAME=${12}
declare SA_PASSWORD=${13}

# Setup the python environment
source InstallAndConfigurePyEnv.sh $SSH_USERNAME $PYTHON_VERSION

# Install airflow on the python environment
source InstallAirflowWithDependencies.sh

# Define the environment variables needed to connect with the other resources in our 
# Celery executor architecture
source DefineAirflowEnvironmentVariables.sh $SSH_USERNAME $AIRFLOW_DATABASE $MYSQL_SERVER_USERNAME $MYSQL_SERVER_PASSWORD $MYSQL_SERVER_HOSTNAME $RABBITMQ_QUEUENAME $RABBITMQ_VHOST $RABBITMQ_USERNAME $RABBITMQ_PASSWORD $RABBITMQ_HOSTNAME $SA_USERNAME $SA_PASSWORD
