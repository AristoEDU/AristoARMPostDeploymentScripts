declare SSH_USERNAME="$1"

sudo passwd --maxdays 99999 --warndays 99900 $SSH_USERNAME

unset SSH_USERNAME
