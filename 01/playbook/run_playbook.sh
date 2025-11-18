#!/bin/bash

VAULT_PASS="netology"

create_container() {
    NAME=$1
    IMAGE=$2
    PY_SETUP=$3

    echo "Creating container $NAME from image $IMAGE..."
    docker run -d --name $NAME $IMAGE sleep infinity

    echo "Installing Python in $NAME..."
    docker exec -it $NAME bash -c "$PY_SETUP"
}

# CentOS 7
create_container centos7 centos:7 "
sed -i 's|mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo && \
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo && \
yum clean all && yum makecache && yum install -y python
"

# Ubuntu
create_container ubuntu ubuntu:22.04 "
apt update && apt install -y python3 && ln -sf /usr/bin/python3 /usr/bin/python
"

# Fedora
create_container fedora01 fedora:38 "
dnf install -y python3 && ln -sf /usr/bin/python3 /usr/bin/python
"

# Запуск playbook
echo "Running Ansible playbook..."
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file <(echo "$VAULT_PASS")

# Остановка контейнеров
echo "Stopping and removing containers..."
docker rm -f centos7 ubuntu fedora01

echo "Done!"

