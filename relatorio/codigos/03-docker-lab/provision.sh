#!/usr/bin/env bash
# Provisionamento da VM docker-notes: instala o Docker Engine (repositório oficial)
set -e

echo "Adicionando o repositório oficial do Docker..."
dnf install -y dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

echo "Instalando o Docker Engine e o plugin Compose..."
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Habilitando e iniciando o Docker..."
systemctl enable --now docker

# Permite usar o comando docker sem sudo (vale após um novo login)
usermod -aG docker vagrant

echo "Configurando /etc/hosts..."
tee -a /etc/hosts > /dev/null <<EOT
192.168.1.3 app01
192.168.1.4 db01
EOT

docker --version
