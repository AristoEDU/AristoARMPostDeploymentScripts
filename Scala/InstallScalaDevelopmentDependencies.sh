declare SSH_USERNAME="$1"
declare V_HOME="/home/$SSH_USERNAME"

echo "Installing SBT ..."

echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

sudo apt-get update

sudo apt-get install sbt

echo "Installing Scala ..."
sudo apt-get update

sudo apt-get install -y default-jdk

sudo apt-get install -y scala


echo "Installing Scala Syntax Highlighting ..."
mkdir -p $V_HOME/.vim/{ftdetect,indent,syntax} && for d in ftdetect indent syntax;
do
    wget -O $V_HOME/.vim/$d/scala.vim https://raw.githubusercontent.com/derekwyatt/vim-scala/master/$d/scala.vim; 
done
