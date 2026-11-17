#!/usr/bin/env bash

set -e

echo "=========================================="
echo " Instalando SonarQube no Rocky Linux 9"
echo "=========================================="

SONAR_VERSION="26.5.0.122743"
SONAR_ZIP="sonarqube-${SONAR_VERSION}.zip"
SONAR_URL="https://binaries.sonarsource.com/Distribution/sonarqube/${SONAR_ZIP}"
SONAR_HOME="/opt/sonarqube"
SONAR_USER="sonar"

SCANNER_VERSION="8.0.1.6346"
SCANNER_ZIP="sonar-scanner-cli-${SCANNER_VERSION}-linux-x64.zip"
SCANNER_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SCANNER_ZIP}"
SCANNER_HOME="/opt/sonar-scanner"

echo "Atualizando pacotes do sistema..."
dnf update -y

echo "Instalando dependências..."
dnf install -y wget unzip java-21-openjdk java-21-openjdk-devel fontconfig tar net-tools

echo "Verificando versão do Java..."
java -version

echo "Criando usuário sonar..."
if ! id "${SONAR_USER}" &>/dev/null; then
  useradd --system --no-create-home --shell /bin/false "${SONAR_USER}"
fi

echo "Configurando parâmetros do kernel para o Elasticsearch interno do SonarQube..."
cat > /etc/sysctl.d/99-sonarqube.conf <<EOF
vm.max_map_count=524288
fs.file-max=131072
EOF

sysctl --system

echo "Configurando limites do usuário sonar..."
cat > /etc/security/limits.d/99-sonarqube.conf <<EOF
sonar   -   nofile   131072
sonar   -   nproc    8192
EOF

echo "Baixando SonarQube ${SONAR_VERSION}..."
cd /tmp

if [ ! -f "${SONAR_ZIP}" ]; then
  wget "${SONAR_URL}"
fi

echo "Removendo instalação anterior do SonarQube, se existir..."
systemctl stop sonar 2>/dev/null || true
rm -rf "${SONAR_HOME}"

echo "Extraindo SonarQube..."
unzip -q "${SONAR_ZIP}" -d /opt/

mv "/opt/sonarqube-${SONAR_VERSION}" "${SONAR_HOME}"

echo "Ajustando permissões do SonarQube..."
chown -R "${SONAR_USER}:${SONAR_USER}" "${SONAR_HOME}"

echo "Configurando SonarQube para escutar na porta 9000..."
cat >> "${SONAR_HOME}/conf/sonar.properties" <<EOF

# Configuração para laboratório
sonar.web.host=0.0.0.0
sonar.web.port=9000
EOF

echo "Criando serviço systemd do SonarQube..."
cat > /etc/systemd/system/sonar.service <<EOF
[Unit]
Description=SonarQube Server
After=network.target

[Service]
Type=forking

User=sonar
Group=sonar
ExecStart=${SONAR_HOME}/bin/linux-x86-64/sonar.sh start
ExecStop=${SONAR_HOME}/bin/linux-x86-64/sonar.sh stop

Restart=always
RestartSec=10

LimitNOFILE=131072
LimitNPROC=8192

TimeoutStartSec=300
TimeoutStopSec=120

[Install]
WantedBy=multi-user.target
EOF

echo "Recarregando systemd..."
systemctl daemon-reload

echo "Habilitando SonarQube para iniciar com o sistema..."
systemctl enable sonar

echo "Iniciando SonarQube..."
systemctl start sonar

echo "Liberando porta 9000 no firewalld, se estiver ativo..."
if systemctl is-active --quiet firewalld; then
  firewall-cmd --permanent --add-port=9000/tcp
  firewall-cmd --reload
fi

echo "=========================================="
echo " Instalando SonarScanner CLI"
echo "=========================================="

cd /tmp

echo "Baixando SonarScanner ${SCANNER_VERSION}..."
if [ ! -f "${SCANNER_ZIP}" ]; then
  wget "${SCANNER_URL}"
fi

echo "Removendo instalação anterior do SonarScanner, se existir..."
rm -rf "${SCANNER_HOME}"

echo "Extraindo SonarScanner..."
unzip -q "${SCANNER_ZIP}" -d /opt/

echo "Renomeando diretório do SonarScanner..."
mv "/opt/sonar-scanner-${SCANNER_VERSION}-linux-x64" "${SCANNER_HOME}"

echo "Ajustando permissões do SonarScanner..."
chown -R "${SONAR_USER}:${SONAR_USER}" "${SCANNER_HOME}"

echo "Adicionando SonarScanner ao PATH..."
cat > /etc/profile.d/sonar-scanner.sh <<EOF
export PATH=\$PATH:${SCANNER_HOME}/bin
EOF

chmod +x /etc/profile.d/sonar-scanner.sh

echo "Criando link simbólico para uso global..."
ln -sf "${SCANNER_HOME}/bin/sonar-scanner" /usr/local/bin/sonar-scanner

echo "Validando instalação do SonarScanner..."
sonar-scanner --version

echo "=========================================="
echo " Instalação finalizada"
echo "=========================================="
echo "Acesse o SonarQube no navegador:"
echo "http://127.0.0.1:9000"
echo ""
echo "Status do serviço:"
echo "systemctl status sonar"
echo ""
echo "Logs:"
echo "tail -f /opt/sonarqube/logs/sonar.log"
echo "tail -f /opt/sonarqube/logs/web.log"
echo "tail -f /opt/sonarqube/logs/es.log"
echo ""
echo "Testar SonarScanner:"
echo "sonar-scanner --version"
echo "=========================================="
