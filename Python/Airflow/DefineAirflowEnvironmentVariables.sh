declare SSH_USERNAME=$1
declare AIRFLOW_DATABASE=$2
declare MYSQL_SERVER_USERNAME=$3
declare MYSQL_SERVER_PASSWORD=$4
declare MYSQL_SERVER_HOSTNAME=$5
declare RABBITMQ_QUEUENAME=$6
declare RABBITMQ_VHOST=$7
declare RABBITMQ_USERNAME=$8
declare RABBITMQ_PASSWORD=$9
declare RABBITMQ_HOSTNAME=${10}
declare SA_EMAIL=${11}
declare SA_PASSWORD=${12}

declare V_HOME="/home/$SSH_USERNAME"
sed -i '/AIRFLOW_/d' $V_HOME/.profile

echo export AIRFLOW_HOME=$V_HOME/AristoAirflow >> $V_HOME/.profile
echo export AIRFLOW__CORE__AIRFLOW_HOME=$V_HOME/AristoAirflow >> $V_HOME/.profile
echo export AIRFLOW__CORE__DAGS_FOLDER=$V_HOME/AristoAirflow/dags >> $V_HOME/.profile
echo export AIRFLOW__CORE__BASE_LOG_FOLDER=$V_HOME/AristoAirflow/logs >> $V_HOME/.profile
echo export AIRFLOW__CORE__PLUGINS_FOLDER=$V_HOME/AristoAirflow/plugins >> $V_HOME/.profile
echo export AIRFLOW__SCHEDULER__CHILD_PROCESS_LOG_DIRECTORY=$V_HOME/AristoAirflow/logs/scheduler >> $V_HOME/.profile

echo export AIRFLOW__SMTP__SMTP_USER=$SA_EMAIL >> $V_HOME/.profile
echo export AIRFLOW__SMTP__SMTP_MAIL_FROM=$SA_EMAIL >> $V_HOME/.profile
echo export AIRFLOW__SMTP__SMTP_PASSWORD=$SA_PASSWORD >> $V_HOME/.profile

echo export MYSQL_SERVER_HOSTNAME=${MYSQL_SERVER_HOSTNAME} >> $V_HOME/.profile
echo 'export ENV_DB_HOST=mysql://${MYSQL_SERVER_HOSTNAME}' >> $V_HOME/.profile
echo export ENV_DB_URL_PARAMS="edu_analytics?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC" >> $V_HOME/.profile
echo export ENV_DB_USER=${MYSQL_SERVER_USERNAME} >> $V_HOME/.profile
echo export ENV_DB_PASS=${MYSQL_SERVER_PASSWORD} >> $V_HOME/.profile
echo 'export AIRFLOW__CORE__SQL_ALCHEMY_CONN=mysql+mysqldb://${ENV_DB_USER}:${ENV_DB_PASS}@$MYSQL_SERVER_HOSTNAME:3306/$AIRFLOW_DATABASE' >> $V_HOME/.profile
echo 'export AIRFLOW__CELERY__RESULT_BACKEND=db+mysql://${ENV_DB_USER}:${ENV_DB_PASS}@$MYSQL_SERVER_HOSTNAME:3306/$AIRFLOW_DATABASE' >> $V_HOME/.profile
echo export AIRFLOW__CELERY__DEFAULT_QUEUE=$RABBITMQ_QUEUENAME >> $V_HOME/.profile
echo export AIRFLOW__CELERY__BROKER_URL=amqp://$RABBITMQ_USERNAME:$RABBITMQ_PASSWORD@$RABBITMQ_HOSTNAME:5672/$RABBITMQ_VHOST >> $V_HOME/.profile

unset V_HOME

unset SSH_USERNAME
unset AIRFLOW_DATABASE
unset MYSQL_SERVER_USERNAME
unset MYSQL_SERVER_PASSWORD
unset MYSQL_SERVER_HOSTNAME
unset RABBITMQ_QUEUENAME
unset RABBITMQ_VHOST
unset RABBITMQ_USERNAME
unset RABBITMQ_PASSWORD
unset RABBITMQ_HOSTNAME
unset SA_EMAIL
unset SA_PASSWORD
