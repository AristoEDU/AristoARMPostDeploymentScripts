export SLUGIFY_USES_TEXT_UNIDECODE=yes

### LIST OF APT-GET PACKAGES ANBD VERSIONS
declare -a APT_GET_INSTALL=(
python-pip
python-mysqldb=1.3.10-1build1
)

### LIST OF PIP PACKAGES AND VERSIONS
declare -a PIP_INSTALL=(
pipdeptree==0.13.2
pipreqs==0.4.9
apache-airflow==1.10.2
celery==4.3.0
azure==4.0.0
pylint==1.9.4
)

sudo apt-get update

for val in ${APT_GET_INSTALL[@]}; do
   echo "installing ${val}..."
   sudo apt-get install -y ${val}
done

for val in ${PIP_INSTALL[@]}; do
   echo "installing ${val}..."
   sudo -E pip install ${val}
done

