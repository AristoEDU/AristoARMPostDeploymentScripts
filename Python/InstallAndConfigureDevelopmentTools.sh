declare SSH_USERNAME=$1
declare PYTHON_VERSION=$2

# Install PyEnv Dependencies
sudo apt-get install -y git python-pip make build-essential libssl1.0-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev

# Install PyEnv
declare V_HOME=/home/$SSH_USERNAME

if [ ! -d $V_HOME/.pyenv ]; then
    git clone https://github.com/yyuu/pyenv.git $V_HOME/.pyenv
fi

sed -i '/PYENV_/d' $V_HOME/.bashrc
sed -i '/pyenv/d' $V_HOME/.bashrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $V_HOME/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $V_HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $V_HOME/.bashrc

export PYENV_ROOT="$V_HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

sudo chmod a+w -R $V_HOME/.pyenv
sudo chmod a+r -R $V_HOME/.pyenv

# Configure PyEnv to make global the passed in version
if [ ! -d $V_HOME/.pyenv/versions/$PYTHON_VERSION ]; then
    pyenv install $PYTHON_VERSION
fi

pyenv global $PYTHON_VERSION

# Given the PyEnv has been setup, now install other python tools
declare -a PIP_INSTALL=(
pipdeptree==0.13.2
pipreqs==0.4.9
pylint==1.9.4
)

for package in ${PIP_INSTALL[@]}; do
    echo "Installing ${package}..."
    pip install $package
done

unset PIP_INSTALL
unset V_HOME
unset PYTHON_VERSION
unset SSH_USERNAME
