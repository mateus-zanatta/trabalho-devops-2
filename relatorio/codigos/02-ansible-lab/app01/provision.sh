#!/usr/bin/env bash
# Provisionamento do app01: autoriza a chave SSH do control-node e prepara o firewall

echo "Configurando chaves..."
# Cole abaixo o conteúdo de ~/.ssh/id_rsa.pub gerado no control-node (ssh-keygen).
# A chave PÚBLICA pode ser compartilhada; a chave PRIVADA nunca sai do control-node.
sudo tee -a /home/vagrant/.ssh/authorized_keys > /dev/null <<EOT
ssh-rsa COLE_AQUI_A_CHAVE_PUBLICA_DO_CONTROL_NODE vagrant@control-node
EOT

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
