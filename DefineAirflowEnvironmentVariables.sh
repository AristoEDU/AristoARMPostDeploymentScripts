declare SSH_USERNAME=$1
declare V_HOME="/home/$SSH_USERNAME"
declare CLUSTERNAME=$2
declare AIRFLOW_RESOURCE_USERNAME=$3
declare AIRFLOW_RESOURCE_PASSWORD=$4
declare AIRFLOW_SMTP_PASSWORD=$5
declare AIRFLOW_SMTP_HOSTNAME=$6
declare ARISTO_SA_EMAIL=$7
declare MYSQL_SERVER_HOSTNAME=$8
declare RABBITMQ_VM_IP=$9

sed -i '/CLUSTERNAME/d' $V_HOME/.profile
echo export CLUSTERNAME=$CLUSTERNAME >> $V_HOME/.profile

echo "Giving airflowuser read rights"
sudo setfacl -R -m u:$SSH_USERNAME:r-x /usr/local/lib/

sudo wget https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt.pem -P /etc/ssl/certs

sed -i '/AIRFLOW_/d' $V_HOME/.profile

echo export AIRFLOW_HOME=$V_HOME/AristoAirflow >> $V_HOME/.profile
echo export AIRFLOW__CORE__AIRFLOW_HOME=$V_HOME/AristoAirflow >> $V_HOME/.profile
echo export AIRFLOW__CORE__DAGS_FOLDER=$V_HOME/AristoAirflow/dags >> $V_HOME/.profile
echo export AIRFLOW__CORE__BASE_LOG_FOLDER=$V_HOME/AristoAirflow/logs >> $V_HOME/.profile
echo export AIRFLOW__CORE__PLUGINS_FOLDER=$V_HOME/AristoAirflow/plugins >> $V_HOME/.profile
echo export AIRFLOW__SCHEDULER__CHILD_PROCESS_LOG_DIRECTORY=$V_HOME/AristoAirflow/logs/scheduler >> $V_HOME/.profile

echo export AIRFLOW__SMTP__SMTP_PORT=587 >> $V_HOME/.profile
echo export AIRFLOW__SMTP__SMTP_HOST=$AIRFLOW_SMTP_HOSTNAME >> $V_HOME/.profile
echo export AIRFLOW__SMTP__SMTP_USER=$ARISTO_SA_EMAIL >> $V_HOME/.profile
echo export AIRFLOW__SMTP__SMTP_MAIL_FROM=$ARISTO_SA_EMAIl >> $V_HOME/.profile
echo export AIRFLOW__SMTP__SMTP_PASSWORD=$AIRFLOW_SMTP_PASSWORD >> $V_HOME/.profile

declare SSL_CA_PATH="/etc/ssl/certs/BaltimoreCyberTrustRoot.crt.pem"
declare AZURE_ADDR_POSTFIX="$MYSQL_SERVER_HOSTNAME.mysql.database.azure.com"
declare MYSQL_SERVER_LOGIN="$AIRFLOW_RESOURCE_USERNAME@$MYSQL_SERVER_HOSTNAME:$AIRFLOW_RESOURCE_PASSWORD"

echo export AIRFLOW__CORE__SQL_ALCHEMY_CONN=mysql+mysqldb://$MYSQL_SERVER_LOGIN@$AZURE_ADDR_POSTFIX:3306/airflow?ssl_ca=$SSL_CA_PATH >> $V_HOME/.profile
echo export AIRFLOW__CELERY__CELERY_RESULT_BACKEND=db+mysql://$MYSQL_SERVER_LOGIN@$AZURE_ADDR_POSTFIX:3306/airflow?ssl_ca=$SSL_CA_PATH >> $V_HOME/.profile
echo export AIRFLOW__CELERY__BROKER_URL=amqp://$AIRFLOW_RESOURCE_USERNAME:$AIRFLOW_RESOURCE_PASSWORD@$RABBITMQ_VM_IP/airflow >> $V_HOME/.profile
echo export AIRFLOW__CELERY__RESULT_BACKEND=db+mysql://$MYSQL_SERVER_LOGIN@$AZURE_ADDR_POSTFIX:3306/airflow?ssl_ca=$SSL_CA_PATH >> $V_HOME/.profile
