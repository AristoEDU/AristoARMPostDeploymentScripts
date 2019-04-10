declare SSH_USERNAME=$1
declare PYTHON_VERSIONS=$2
declare GLOBAL_PYTHON_VERSION=$3

declare V_HOME=/home/$SSH_USERNAME
  
sudo apt-get install -y git python-pip make build-essential libssl1.0-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
git clone https://github.com/yyuu/pyenv.git $V_HOME/.pyenv

sed -i '/PYENV_/d' $V_HOME/.bashrc
sed -i '/pyenv/d' $V_HOME/.bashrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $V_HOME/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $V_HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $V_HOME/.bashrc

export PYENV_ROOT="$V_HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

sudo chmod a+w $V_HOME/.pyenv

for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"
do
    pvenv install $PYTHON_VERSION
done

pyenv global $GLOBAL_PYTHON_VERSION
