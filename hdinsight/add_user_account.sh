#!/bin/bash

###TODO: Generate password and save to keyvault
DEFAULT_PASS="Wer34#fT983TgJ08"
NEW_USER=$1
CURR_PATH=`pwd`
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")

usage(){
   echo "./add_user_account.sh NEW_USER NEW_USER_PASSWORD(OPTIONAL)"  
   exit
}

if [ $# == 2 ]; then
    DEFAULT_PASS=$2
elif [ $# == 1 ]; then
    echo "The password has not been supplied. The default password will be set."
else
    usage
fi 

res=$(groups | grep sshuser)
if [ "$res" == "" ]; then
  echo "ERROR!!!"
  echo "This script must run from the admin account (sshuser group) only !"

  exit 
fi

### Add color schema
if [ ! -f ~/.vimrc ]; then
   echo ":color desert" > ~/.vimrc
fi
### Add Scala source code coloring
if [ ! -d ~/.vim ]; then
   mkdir -p ~/.vim/{ftdetect,indent,syntax} && for d in ftdetect indent syntax ; do curl -o ~/.vim/$d/scala.vim https://raw.githubusercontent.com/derekwyatt/vim-scala/master/$d/scala.vim; done
fi

if [ -f ~/.profile ]; then
   res=$(grep Dscala ~/.profile)
   if [ "${res}" == "" ]; then
       echo "" >> ~/.profile
       echo "alias scala=\"scala -Dscala.color\"" >> ~/.profile
       echo "alias spark-shell=\"spark-shell --conf spark.driver.extraJavaOptions='-Dscala.color'\"" >> ~/.profile
   fi
fi

if [ ! -d /home/${NEW_USER} ]; then
  ### copy provided .bashrc and .profile
  if [ "${CURR_PATH}" != "${HOME}" ]; then
     echo "WARNING: Replacing .bashrc and .profile"
     if [ -f ".bashrc" ]; then
       mv ${HOME}/.bashrc ${HOME}/.bashrc_${TIMESTAMP} 
       cp .bashrc ${HOME}/.
     fi

     if [ -f ".profile" ]; then 
       mv ${HOME}/.profile ${HOME}/.profile_${TIMESTAMP}
       cp .profile ${HOME}/.
     fi

  else
     echo "at home path ..."
  fi

  sudo useradd  ${NEW_USER}
  echo -e "${DEFAULT_PASS}\n${DEFAULT_PASS}" | (sudo passwd ${NEW_USER})
  sudo passwd --maxdays 99999 --warndays 99900 ${NEW_USER}
  sudo usermod -a -G sshuser ${NEW_USER}

  sudo mkdir /home/${NEW_USER}
  sudo cp ${HOME}/.bashrc /home/${NEW_USER}/.
  sudo cp ${HOME}/.profile /home/${NEW_USER}/.
  sudo cp -r ${HOME}/.vim  /home/${NEW_USER}/.
  sudo cp ${HOME}/.vimrc /home/${NEW_USER}/.

  sudo chown -R ${NEW_USER}:sshuser /home/${NEW_USER}

  sudo chmod -R 544 /home/${NEW_USER}/.bashrc
  sudo chmod -R 544 /home/${NEW_USER}/.profile
  sudo chmod 750 /home/${NEW_USER}
else
   echo "User home /home/${NEW_USER} already exist."
fi
