#!/usr/bin/env bash
# Provisionamento da VM do laboratório 1: instala e configura o Apache (httpd)

echo "Instalando o Apache e configurando..."

dnf install -y httpd

# Copia a página HTML da pasta compartilhada (/vagrant) para o Apache
mkdir -p /var/www/html
cp -r /vagrant/html/. /var/www/html/

# Habilita o Apache no boot e inicia o serviço
systemctl enable httpd
systemctl start httpd

# Libera a porta 80 (serviço http) no firewall
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
