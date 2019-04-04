declare SSH_USERNAME="$1"
declare V_HOME="/home/$SSH_USERNAME"

echo "Installing jq ..."
sudo apt-get update
sudo apt-get -y install jq

echo "Installing python dev and pip ..."
sudo apt-get install -y python3-dev python3-pip libmysqlclient-dev

echo "Installing neovim ..."
sudo apt-add-repository -y ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install -y neovim

echo "Installing virtual environments ..."
sudo pip3 install virtualenvwrapper

echo "Setting the environment variables"

sed -i '/WORKON_HOME/d' $V_HOME/.bashrc
echo export WORKON_HOME=$V_HOME/.virtualenvs >> $V_HOME/.bashrc

sed -i '/VIRTUALENVWRAPPER_PYTHON/d' $V_HOME/.bashrc
echo export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3 >> $V_HOME/.bashrc

sudo mkdir $V_HOME/.virtualenvs
sudo chmod a+w $V_HOME/.virtualenvs

sed -i '/virtualenvwrapper.sh/d' $V_HOME/.bashrc
echo source /usr/local/bin/virtualenvwrapper.sh >> $V_HOME/.bashrc
