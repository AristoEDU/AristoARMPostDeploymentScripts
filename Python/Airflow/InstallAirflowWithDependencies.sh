export SLUGIFY_USES_TEXT_UNIDECODE=yes
sudo apt-get -y install libmysqlclient-dev

declare -a PIP_INSTALL=(
apache-airflow==1.10.2
azure==4.0.0
celery==4.3.0
mysqlclient==1.4.2
)

for package in ${PIP_INSTALL[@]}; do
    echo "Installing $package ..."
    sudo -E pip install $package
done

unset PIP_INSTALL
