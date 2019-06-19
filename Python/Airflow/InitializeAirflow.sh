declare ENVIRONMENT=$1
declare GIT_USER=$2
declare GIT_PASSWORD=$3
declare SSH_USER=$4

set -xe

cd /home/$SSH_USER

myemail="$GIT_USER@microsoft.com"

#We'll use the HTTPS to push a ssh key to git, SSH for pull/push configuration
gitrepo_ssh="git@github.com:AristoEDU/AristoAirflow.git"
gitrepo_https="https://github.com/$GIT_USER/AristoEDU/AristoAirflow.git"

#Generating SSH key:
ssh-keygen -f "/home/$SSH_USER/.ssh/id_rsa" -t rsa -b 4096 -C "${myemail}" -N ''
sslpub="$(cat /home/$SSH_USER/.ssh/id_rsa.pub |tail -1)"

git_api_addkey="https://api.$(echo ${gitrepo_https} |cut -d'/' -f3)/user/keys"

#Keyname to identify where it's from and when it was generated.
git_ssl_keyname="$(hostname)_$(date +%d-%m-%Y)"

#Post this ssh key:
curl -u "$GIT_USER:$GIT_PASSWORD" -X POST -d "{\"title\":\"$git_ssl_keyname\",\"key\":\"$sslpub\"}" $git_api_addkey

# Write out Host key checking
ssh-keyscan -H 192.30.253.113 >> /home/$SSH_USER/.ssh/known_hosts
ssh-keyscan -H github.com >> /home/$SSH_USER/.ssh/known_hosts

# Clone the repo
git clone --single-branch --branch master $gitrepo_ssh

cd /home/$SSH_USER/AristoAirflow

# We can't seem to import the variables unless the db is initialized but
# airflow imports the dags as part of the initdb process, causing
# an error so we have to init, import and init again.
airflow initdb

if [ "$ENVIRONMENT" = "Prod" ]; then
  airflow variables --i .vars/AristoVariables.var
else
  airflow variables --i .vars/AristoVariables-Dev.var
fi

airflow initdb

unset ENVIRONMENT
unset GIT_USER
unset GIT_PASSWORD
unset SSH_USER
