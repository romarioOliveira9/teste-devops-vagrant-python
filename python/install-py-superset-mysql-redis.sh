#!/bin/bash

echo "Instalando Python 3.6......."
sudo yum install -y https://repo.ius.io/ius-release-el7.rpm
sudo yum update
sudo yum install -y python36u python36u-libs python36u-devel python36u-pip
python3.6 -V

echo "Instalando Apache Superset localmente com Docker......."

echo "Instalando Docker......."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo "Instalando Apache Superset......."
git clone https://github.com/apache/superset.git
cd superset
docker-compose -f docker-compose-non-dev.yml up

echo "Instalacao MySQL......."

echo "Preparando o repositorio MYSQL......."
sudo yum update
sudo wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
sudo rpm -Uvh mysql80-community-release-el7-3.noarch.rpm

echo "Instalando MySQL......."
sudo yum install mysql-server -y
sudo systemctl start mysqld
sudo systemctl status mysqld