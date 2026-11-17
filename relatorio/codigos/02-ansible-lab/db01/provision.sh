#!/usr/bin/env bash
# Provisionamento do db01: autoriza a chave SSH do control-node e prepara o firewall

echo "Configurando chaves..."
# Mesma chave PÚBLICA do control-node usada no app01
sudo tee -a /home/vagrant/.ssh/authorized_keys > /dev/null <<EOT
ssh-rsa COLE_AQUI_A_CHAVE_PUBLICA_DO_CONTROL_NODE vagrant@control-node
EOT

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
