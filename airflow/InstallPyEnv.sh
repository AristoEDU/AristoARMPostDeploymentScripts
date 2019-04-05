declare SSH_USERNAME=$1
declare V_HOME=/home/$SSH_USERNAME
  
sudo apt-get install -y git python-pip make build-essential libssl1.0-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
git clone https://github.com/yyuu/pyenv.git $V_HOME/.pyenv

sed -i '/PYENV_/d' $V_HOME/.bashrc
sed -i '/pyenv/d' $V_HOME/.bashrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $V_HOME/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $V_HOME/.bashrc

export PYENV_ROOT="$V_HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv global

pyenv install 2.7.8
pyenv install 2.7.15

pyenv versions

pyenv global 2.7.15
which python 
which pip
