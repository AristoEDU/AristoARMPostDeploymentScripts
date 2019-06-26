declare ENVIRONMENT=$1
declare GIT_USER=$2
declare GIT_PASSWORD=$3
declare SSH_USER=$4

set -xe

temp_home=/home/$SSH_USER

cd $temp_home

myemail="$GIT_USER@microsoft.com"

#We'll use the HTTPS to push a ssh key to git, SSH for pull/push configuration
gitrepo_ssh="git@github.com:AristoEDU/AristoAirflow.git"
gitrepo_https="https://github.com/$GIT_USER/AristoEDU/AristoAirflow.git"

#Generating SSH key:
ssh-keygen -f "$temp_home/.ssh/id_rsa" -t rsa -b 4096 -C "${myemail}" -N ''
sslpub="$(cat $temp_home/.ssh/id_rsa.pub |tail -1)"

git_api_addkey="https://api.$(echo ${gitrepo_https} |cut -d'/' -f3)/user/keys"

#Keyname to identify where it's from and when it was generated.
git_ssl_keyname="$(hostname)_$(date +%d-%m-%Y)"

#Post this ssh key:
curl -u "$GIT_USER:$GIT_PASSWORD" -X POST -d "{\"title\":\"$git_ssl_keyname\",\"key\":\"$sslpub\"}" $git_api_addkey

# Write out Host key checking
ssh-keyscan -H 192.30.253.113 >> $temp_home/.ssh/known_hosts
ssh-keyscan -H github.com >> $temp_home/.ssh/known_hosts

# temporary point to empty dag folder
mkdir ~/dummy_dags
AIRFLOW__CORE__DAGS_FOLDER_TEMP=${AIRFLOW__CORE__DAGS_FOLDER}
export AIRFLOW__CORE__DAGS_FOLDER=~/dummy_dags

# initialize DB - AristoAirflow schema
airflow initdb

export AIRFLOW__CORE__DAGS_FOLDER=${AIRFLOW__CORE__DAGS_FOLDER_TEMP}

# Clone the repo
git clone --single-branch --branch master $gitrepo_ssh

cd $temp_home/AristoAirflow

# We can't seem to import the variables unless the db is initialized but
# airflow imports the dags as part of the initdb process, causing
# an error so we have to init, import and init again.
airflow initdb

if [ "$ENVIRONMENT" = "Prod" ]; then
  airflow variables --i ./vars/AristoVariables.var
else
  airflow variables --i ./vars/AristoVariables-Dev.var
fi

# Make directory and files for logging so that the utility script can be run
# without additional work to start airflow.
mkdir ./logs/webserver
mkdir ./logs/worker
touch ./logs/webserver/webserver.log
touch ./logs/webserver/worker.log

rm -fr ~/dummy_dags

unset ENVIRONMENT
unset GIT_USER
unset GIT_PASSWORD
unset SSH_USER
