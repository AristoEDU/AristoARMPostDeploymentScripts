declare SSH_USERNAME=$1
declare V_HOME="/home/$SSH_USERNAME"
declare CLUSTERNAME=$2
declare AIRFLOW_RESOURCE_USERNAME=$3
declare AIRFLOW_RESOURCE_PASSWORD=$4
declare AIRFLOW_SMTP_PASSWORD=$5
declare MYSQL_SERVER_HOSTNAME=$6
declare RABBITMQ_VM_IP=$7

sed -i '/CLUSTERNAME/d' $V_HOME/.profile
echo export CLUSTERNAME=$CLUSTERNAME >> $V_HOME/.profile

echo "Giving airflowuser read rights"
sudo setfacl -R -m u:$SSH_USERNAME:r-x /usr/local/lib/

sudo wget https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt.pem -P /etc/ssl/certs

sed -i '/AIRFLOW_/d' $V_HOME/.profile

echo export AIRFLOW_HOME=$V_HOME/AristoAirflow >> $V_HOME/.profile

echo export AIRFLOW__SMTP__SMTP_PASSWORD=$AIRFLOW_SMTP_PASSWORD >> $V_HOME/.profile

declare SSL_CA_PATH="/etc/ssl/certs/BaltimoreCyberTrustRoot.crt.pem"
declare AZURE_ADDR_POSTFIX="$MYSQL_SERVER_HOSTNAME.mysql.database.azure.com"
declare MYSQL_SERVER_LOGIN="$AIRFLOW_RESOURCE_USERNAME@$MYSQL_SERVER_HOST_NAME:$AIRFLOW_RESOURCE_PASSWORD"

echo export AIRFLOW__CORE__SQL_ALCHEMY_CONN=mysql+mysqldb://$MYSQL_SERVER_LOGIN@$AZURE_ADDR_POSTFIX:3306/airflow?ssl_ca=$SSL_CA_PATH >> $V_HOME/.profile
echo export AIRFLOW__CELERY__RESULT_BACKEND=db+mysql://$MYSQL_SERVER_LOGIN@$AZURE_ADDR_POSTFIX:3306/airflow?ssl_ca=$SSL_CA_PATH >> $V_HOME/.profile
echo export AIRFLOW__CELERY__CELERY_RESULT_BACKEND=${AIRFLOW__CELERY__RESULT_BACKEND} >> $V_HOME/.profile
echo export AIRFLOW__CELERY__BROKER_URL=amqp://$AIRFLOW_RESOURCE_USERNAME:$AIRFLOW_RESOURCE_PASSWORD@$RABBITMQ_VM_IP/airflow >> $V_HOME/.profile
