#!/usr/bin/env bash
# Provisionamento do control-node: instala o Ansible e configura a resolução de nomes

echo "Instalando e configurando dependências..."
sudo dnf install -y epel-release

echo "Instalando e configurando Ansible..."
sudo dnf install -y ansible

echo "Configurando /etc/hosts..."
sudo tee -a /etc/hosts > /dev/null <<EOT
192.168.1.2 control-node
192.168.1.3 app01
192.168.1.4 db01
EOT
