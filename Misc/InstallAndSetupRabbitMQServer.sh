declare USERNAME=$1
declare PASSWORD=$2
declare ERLANG_PREF_FILE="/etc/apt/preferences.d/erlang"
declare RABBITMQ_PREF_FILE="/etc/apt/preferences.d/rabbitmq-server"
declare SOURCE_LIST_FILE="/etc/apt/sources.list.d/bintray.rabbitmq.list"

if [ -f $ERLANG_PREF_FILE ]; then
        sudo rm $ERLANG_PREF_FILE
fi

sudo touch $ERLANG_PREF_FILE
sudo chmod a+w $ERLANG_PREF_FILE

sudo echo "Package: erlang*" >> $ERLANG_PREF_FILE
sudo echo "Pin: version 1:21.3.2-1" >> $ERLANG_PREF_FILE
sudo echo "Pin-Priority: 1000" >> $ERLANG_PREF_FILE

if [ -f $RABBITMQ_PREF_FILE ]; then
        sudo rm $RABBITMQ_PREF_FILE
fi

sudo touch $RABBITMQ_PREF_FILE
sudo chmod a+w $RABBITMQ_PREF_FILE

sudo echo "Package: rabbitmq-server*" >> $RABBITMQ_PREF_FILE
sudo echo "Pin: version 3.7.14-1" >> $RABBITMQ_PREF_FILE
sudo echo "Pin-Priority: 1000" >> $RABBITMQ_PREF_FILE

if [ ! -f $SOURCE_LIST_FILE ]; then
        sudo touch $SOURCE_LIST_FILE
fi

sudo chmod a+w $SOURCE_LIST_FILE

sudo sed -i "/dl.bintray.com\/rabbitmq/d" $SOURCE_LIST_FILE

sudo echo "deb https://dl.bintray.com/rabbitmq-erlang/debian bionic erlang" >> $SOURCE_LIST_FILE
sudo echo "deb https://dl.bintray.com/rabbitmq/debian bionic main" >> $SOURCE_LIST_FILE

wget -O - "https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc" | sudo apt-key add -

sudo apt-get install apt-transport-https

sudo apt-get update

sudo apt-get install -y rabbitmq-server

sudo rabbitmqctl add_user $USERNAME $PASSWORD

sudo rabbitmqctl set_user_tags $USERNAME administrator

sudo rabbitmqctl set_permissions -p / $USERNAME ".*" ".*" ".*"

sudo rabbitmq-plugins enable rabbitmq_management

unset USERNAME
unset PASSWORD
unset ERLANG_PREF_FILE
unset RABBITMQ_PREF_FILE
unset SOURCE_LIST_FILE
