declare P_ENVIRONMENT=$1
declare P_GIT_USER=$2
declare P_GIT_PASSWORD=$3

set -xe
myemail="${P_GIT_USER}@microsoft.com"

#We'll use the HTTPS to push a ssh key to git, SSH for pull/push configuration
gitrepo_ssh="git@github.com:AristoEDU/AristoAirflow.git"
gitrepo_https="https://github.com/${P_GIT_USER}/AristoEDU/AristoAirflow.git"

#Generating SSH key:
ssh-keygen -f "${HOME}/.ssh/id_rsa" -t rsa -b 4096 -C "${myemail}" -N ''
sslpub="$(cat ${HOME}/.ssh/id_rsa.pub |tail -1)"

git_api_addkey="https://api.$(echo ${gitrepo_https} |cut -d'/' -f3)/user/keys"

#Keyname to identify where it's from and when it was generated.
git_ssl_keyname="$(hostname)_$(date +%d-%m-%Y)"

#Post this ssh key:
curl -u "${P_GIT_USER}:${P_GIT_PASSWORD}" -X POST -d "{\"title\":\"${git_ssl_keyname}\",\"key\":\"${sslpub}\"}" ${git_api_addkey}

# Write out Host key checking
ssh-keyscan -H 192.30.253.113 >> ~/.ssh/known_hosts
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

# Clone the repo
git clone $gitrepo_ssh

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

unset P_ENVIRONMENT
unset P_GIT_USER
unset P_GIT_PASSWORD