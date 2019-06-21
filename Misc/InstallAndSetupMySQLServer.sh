set -xe

sudo apt-get update
sudo apt-get install -y mysql-server-5.7

mysql -e CREATE DATABASE AristoAirflow;
mysql -e CREATE DATABASE AristoAirflowBackfill;
mysql -e CREATE DATABASE edu_analytics;
