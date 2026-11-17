#!/usr/bin/env bash
# Provisionamento da VM jenkins: Jenkins LTS + ferramentas usadas pelo pipeline
set -e

echo "=========================================="
echo " Instalando Jenkins (LTS) no Rocky Linux 9"
echo "=========================================="

echo "Instalando dependências (Java 21 para o Jenkins, Java 17 para o build, Git)..."
dnf install -y wget unzip tar fontconfig git java-21-openjdk java-17-openjdk-devel

echo "Instalando o Apache Maven..."
MAVEN_VERSION="3.9.9"
if [ ! -d /opt/maven ]; then
  wget -q -O /tmp/maven.tar.gz \
    "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
  tar -xzf /tmp/maven.tar.gz -C /opt
  mv "/opt/apache-maven-${MAVEN_VERSION}" /opt/maven
fi
ln -sf /opt/maven/bin/mvn /usr/local/bin/mvn

echo "Adicionando o repositório oficial do Jenkins (LTS) e instalando..."
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/rpm-stable/jenkins.repo
dnf install -y jenkins

echo "Instalando o Docker Engine (estágio de imagem do pipeline)..."
dnf install -y dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
systemctl enable --now docker
usermod -aG docker jenkins

echo "Instalando o SonarScanner CLI..."
SCANNER_VERSION="8.0.1.6346"
if [ ! -d /opt/sonar-scanner ]; then
  wget -q -O /tmp/scanner.zip \
    "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SCANNER_VERSION}-linux-x64.zip"
  unzip -q /tmp/scanner.zip -d /opt/
  mv "/opt/sonar-scanner-${SCANNER_VERSION}-linux-x64" /opt/sonar-scanner
fi
ln -sf /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner

echo "Configurando /etc/hosts..."
tee -a /etc/hosts > /dev/null <<EOT
192.168.1.3 app01
192.168.1.4 db01
192.168.1.6 sonarqube
EOT

echo "Habilitando e iniciando o Jenkins..."
systemctl daemon-reload
systemctl enable --now jenkins

echo "Liberando a porta 8080 no firewalld, se estiver ativo..."
if systemctl is-active --quiet firewalld; then
  firewall-cmd --permanent --add-port=8080/tcp
  firewall-cmd --reload
fi

echo "=========================================="
echo " Jenkins instalado: http://localhost:8081"
echo " Senha inicial (somente no primeiro acesso):"
echo "   sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo "=========================================="
