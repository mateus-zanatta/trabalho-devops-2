# Relatório das Atividades Práticas de Fundamentos de DevOps (Overleaf)

Esta pasta é um projeto LaTeX completo, pronto para o Overleaf (compilador **pdfLaTeX**).
O arquivo principal é `main.tex`.

## 1. Como abrir no Overleaf

1. Compacte a pasta `relatorio/` inteira em um `.zip` (no Windows: botão direito → *Enviar para* → *Pasta compactada*).
2. No Overleaf: **New Project → Upload Project** e selecione o `.zip`.
3. Confira em **Menu → Compiler** se está `pdfLaTeX` e se o *Main document* é `main.tex`.
4. Clique em **Recompile**.

> Se o professor passou um modelo (*template*) próprio no Overleaf, abra o modelo e copie para ele
> as pastas `config/`, `secoes/`, `codigos/` e `prints/`; depois inclua as seções com
> `\input{secoes/...}` no lugar do conteúdo de exemplo do modelo.

## 2. Como inserir os prints

Cada lugar onde vai um print aparece no PDF como uma caixa tracejada **"INSERIR PRINT AQUI"**,
com o nome do arquivo e o que deve aparecer na imagem.

1. Tire o print (Windows: `Win + Shift + S`).
2. Salve na pasta `prints/` **com o nome exato** indicado (pode ser `.png`, `.jpg` ou `.jpeg`).
3. No Overleaf, envie o arquivo para a pasta `prints/` e recompile.

A caixa é substituída automaticamente pela imagem. Não é preciso mexer no código.

**Antes de salvar qualquer print:** borre/tarje senhas, *tokens* (SonarQube, Jenkins) e nunca
mostre a chave privada SSH (`id_rsa`).

### Lista de prints (20)

| # | Arquivo (`prints/...png`) | Seção | O que capturar |
|---|---|---|---|
| 1 | `vagrant-up` | Vagrant | Saída do `vagrant up` criando a VM (provider `vmware_desktop`, porta redirecionada, mensagens do `provision.sh`) |
| 2 | `vagrant-status` | Vagrant | `vagrant global-status` (ou `vagrant status`) com as VMs em *running* |
| 3 | `github-repositorio` | Git | Página do repositório no GitHub com os arquivos versionados e o último commit |
| 4 | `git-status-log` | Git | Terminal com `git status` e `git log --oneline` |
| 5 | `git-push` | Git | Saída do `git push` (ou aba *Commits* do GitHub) |
| 6 | `ansible-inventario` | Ansible | `cat inventory/hosts.ini` (ou `ansible-inventory --graph`) no control-node |
| 7 | `ansible-ping` | Ansible | `ansible all -m ping` com `SUCCESS` / `pong` para app01 e db01 |
| 8 | `ansible-db-playbook` | Ansible | Execução do `ansible-playbook playbooks/db.yml` com o PLAY RECAP |
| 9 | `ansible-app-playbook` | Ansible | Execução do `ansible-playbook playbooks/app.yml` com o PLAY RECAP |
| 10 | `ansible-servico` | Ansible | No app01: `sudo systemctl status notes` (`active (running)`) e o `curl` na API |
| 11 | `ansible-arquivos-yml` | Ansible | VS Code com a árvore do projeto `ansible/` e um `.yml` aberto |
| 12 | `docker-container` | Docker | `docker images`, `docker ps` (container `notes` em execução) e `curl` na API |
| 13 | `sonar-token` | SonarQube | Geração do token **com o valor borrado** |
| 14 | `sonar-scanner-exec` | SonarQube | Final da saída do `sonar-scanner` (`ANALYSIS SUCCESSFUL` / `EXECUTION SUCCESS`) |
| 15 | `sonar-dashboard` | SonarQube | *Overview* do projeto com o Quality Gate e as métricas |
| 16 | `sonar-issues` | SonarQube | Aba *Issues* com os apontamentos |
| 17 | `jenkins-inicial` | Jenkins | Dashboard do Jenkins com os jobs criados |
| 18 | `jenkins-pipeline-stages` | Jenkins | Visualização dos *stages* do pipeline, todos em verde |
| 19 | `jenkins-console` | Jenkins | *Console Output* de um build com `Finished: SUCCESS` |
| 20 | `jenkins-jenkinsfile` | Jenkins | Configuração do job com o `Jenkinsfile` visível |

## 3. O que você precisa conferir e completar

O PDF destaca em **amarelo** (`[PREENCHER: ...]`) o que só você pode informar. No código-fonte,
os pontos de atenção estão marcados com comentários `% CONFIRA` ou `% ATENÇÃO`.

- **`main.tex`** – confira seu nome completo e o nome do curso (macros `\autor` e `\curso`).
- **SonarQube (`secoes/07-sonarqube.tex`)** – preencha a Tabela 3 com os números do **seu**
  dashboard e ajuste a lista de apontamentos da aba *Issues* para os que aparecerem para você.
- **Jenkins (`secoes/08-jenkins.tex`)** – não havia PDF da aula de Jenkins no repositório; a seção
  foi escrita com uma instalação padrão (VM `jenkins`, IP `192.168.1.7`, porta `8081` no Windows).
  Ajuste IP, porta, forma de instalação e o pipeline ao que foi feito em aula.
- **Docker (`secoes/06-docker.tex`)** – confira o IP da VM `docker-notes` (`192.168.1.5`) e as portas.
- **Provider do Vagrant** – o texto considera VMware (como nas aulas a partir da Aula 3). Se você
  usou VirtualBox, ajuste a Seção 2.1 e a Tabela 1.
- **Pergunta reflexiva (`secoes/11-reflexao.tex`)** – é obrigatório que esteja com **as suas
  palavras**. Use o texto como rascunho: revise, troque exemplos e conte a sua experiência real.

## 4. Estrutura da pasta

```
relatorio/
├── main.tex                 # arquivo principal
├── config/
│   ├── preambulo.tex        # pacotes, margens ABNT, cores e estilos de código
│   └── comandos.tex         # \printtela, \codigo, \preencher, caixas de destaque
├── secoes/                  # uma seção por arquivo (introdução ... referências)
├── codigos/                 # arquivos reais do laboratório, incluídos no relatório
│   ├── 01-vagrant-lab/      # Vagrantfile + provision.sh + página HTML (Apache)
│   ├── 02-ansible-lab/      # control-node, app01, db01 e o projeto Ansible
│   ├── 03-docker-lab/       # VM docker-notes, Dockerfile e multi-stage
│   ├── 04-sonarqube/        # VM do SonarQube e sonar-project.properties
│   └── 05-jenkins/          # VM do Jenkins, primeiro job e Jenkinsfiles
└── prints/                  # coloque aqui os prints (nomes da lista acima)
```

Os códigos foram validados: os `Vagrantfile` com `ruby -c`, os scripts com `bash -n` e os
playbooks com `ansible-playbook --syntax-check`. Senhas e chaves foram substituídas por marcadores
(`TROQUE_SENHA_ROOT`, `TROQUE_SENHA_APP`, `COLE_AQUI_A_CHAVE_PUBLICA_DO_CONTROL_NODE`).

## 5. Compilar fora do Overleaf (opcional)

```bash
latexmk -pdf main.tex
```
