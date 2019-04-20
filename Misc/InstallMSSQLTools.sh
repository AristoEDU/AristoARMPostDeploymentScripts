declare SSH_USERNAME="$1"
declare V_HOME="/home/$SSH_USERNAME"

echo "Installing MSSQL Tools ..."
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list

sudo apt-get update

sudo ACCEPT_EULA=Y apt-get -y install mssql-tools unixodbc-dev

sed -i '/mssql-tools\/bin/d' $V_HOME/.bashrc
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> $V_HOME/.bashrc

unset V_HOME

unset SSH_USERNAME
