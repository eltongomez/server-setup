# ERP Server Setup

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub version](https://img.shields.io/badge/version-1.0.0-green.svg)]()
[![Bash 4.0+](https://img.shields.io/badge/bash-4.0%2B-blue.svg)]()
[![Supported Distros](https://img.shields.io/badge/distros-5-brightgreen.svg)](#-distribuições-suportadas)
[![Documentation](https://img.shields.io/badge/docs-complete-success.svg)](docs/)

**Script profissional de configuração automatizada para servidores Linux em ambiente de produção**

Automatize segurança, monitoramento e backup com um único script interativo, seguindo as melhores práticas da indústria.

## Características Principais

O script oferece uma solução completa de hardening e configuração de servidor com as seguintes características:

- **Interface Interativa**: Menus coloridos e intuitivos com navegação fácil entre as diferentes seções de configuração
- **Valores Padrão Inteligentes**: Todas as configurações possuem valores padrão recomendados baseados em padrões de mercado
- **Personalização Completa**: Cada parâmetro pode ser ajustado conforme as necessidades específicas do ambiente
- **Backup Automático**: Cria backup de todos os arquivos de configuração antes de modificá-los
- **Logging Detalhado**: Registra todas as operações executadas com timestamps para auditoria
- **Validação de Configurações**: Verifica a sintaxe e valida as configurações antes de aplicá-las
- **Suporte Multi-Distribuição**: Compatível com Ubuntu, Debian, CentOS, RHEL e Fedora
- **Rollback Facilitado**: Mantém backups que permitem reverter alterações em caso de problemas

## Requisitos do Sistema

### Requisitos Mínimos

| Componente | Especificação |
| :--- | :--- |
| **Sistema Operacional** | Ubuntu 18.04+, Debian 10+, CentOS 7+, RHEL 7+, Fedora 30+ |
| **Privilégios** | Acesso root (sudo) |
| **Shell** | Bash 4.0 ou superior |
| **Espaço em Disco** | Mínimo 500 MB livres para logs e backups |
| **Memória RAM** | Mínimo 1 GB (2 GB recomendado) |

### Dependências

O script instala automaticamente as dependências necessárias durante a execução. As seguintes ferramentas podem ser instaladas conforme a configuração escolhida:

- **ufw** - Firewall simplificado para Linux
- **fail2ban** - Proteção contra ataques de força bruta
- **libpam-pwquality** - Biblioteca para política de senhas
- **unattended-upgrades** - Atualizações automáticas de segurança
- **htop, iotop, nethogs, ncdu, sysstat** - Ferramentas de monitoramento

## Instalação

### Download e Preparação

Para instalar o script em seu servidor, execute os seguintes comandos:

```bash
# Fazer download do script
wget https://seu-servidor.com/erp-server-setup.sh

# Tornar o script executável
chmod +x erp-server-setup.sh

# Verificar a integridade (opcional)
bash -n erp-server-setup.sh
```

### Primeira Execução

Execute o script com privilégios de root:

```bash
sudo ./erp-server-setup.sh
```

## Guia de Uso

### Menu Principal

Ao iniciar o script, você será apresentado ao menu principal com as seguintes opções:

| Opção | Descrição |
| :--- | :--- |
| **1. Configuração Completa** | Executa todas as configurações recomendadas em sequência |
| **2. Segurança** | Acessa o submenu de configurações de segurança |
| **3. Monitoramento** | Acessa o submenu de ferramentas de monitoramento |
| **4. Backup** | Acessa o submenu de configuração de backup |
| **5. Sistema** | Acessa o submenu de configurações do sistema |
| **6. Gerar Relatório** | Cria um relatório detalhado das configurações aplicadas |
| **7. Sair** | Encerra o script |

### Configuração Completa (Recomendado)

A opção de **Configuração Completa** é recomendada para novos servidores. Ela executa automaticamente todas as etapas de hardening e configuração, solicitando confirmação e personalização apenas para os parâmetros mais críticos.

Esta opção configura:

- **SSH Seguro**: Altera a porta padrão, desabilita login root e configura autenticação por chave
- **Firewall UFW**: Configura regras básicas de firewall permitindo apenas portas essenciais
- **Fail2Ban**: Protege contra ataques de força bruta com banimento automático de IPs suspeitos
- **Política de Senhas**: Implementa requisitos de complexidade e expiração de senhas
- **Atualizações Automáticas**: Configura instalação automática de patches de segurança
- **Hardening do Kernel**: Aplica configurações de segurança no nível do kernel via sysctl
- **Ferramentas de Monitoramento**: Instala htop, iotop, nethogs e outras ferramentas essenciais
- **Rotação de Logs**: Configura logrotate para gerenciar o crescimento dos arquivos de log
- **Script de Backup**: Cria e agenda backups automáticos do sistema e dados

### Configurações de Segurança

#### SSH (Secure Shell)

O script configura o SSH seguindo as melhores práticas de segurança. Durante a configuração, você será questionado sobre:

- **Porta SSH**: Por padrão, o SSH usa a porta 22. É recomendável alterar para uma porta não padrão (ex: 2222) para reduzir tentativas de ataque automatizadas.
- **Login Root**: Desabilitar o login direto do usuário root força o uso de contas de usuário normais com sudo, criando uma camada adicional de auditoria.
- **Autenticação por Senha**: Desabilitar a autenticação por senha e usar apenas chaves SSH elimina a possibilidade de ataques de força bruta em senhas.

**Exemplo de Configuração**:
```
Porta SSH [22]: 2222
Desabilitar login root via SSH? [S/n]: S
Desabilitar autenticação por senha? [s/N]: N
```

#### Firewall (UFW)

O Uncomplicated Firewall (UFW) é configurado com uma política padrão de negar todas as conexões de entrada e permitir todas as conexões de saída. O script permite adicionar exceções para serviços específicos:

- **Porta SSH**: Automaticamente liberada com base na porta configurada
- **HTTP/HTTPS**: Portas 80 e 443 para servidores web
- **Portas Customizadas**: Você pode adicionar quantas portas adicionais forem necessárias

**Exemplo de Configuração**:
```
Porta SSH para liberar [22]: 2222
Liberar portas HTTP (80) e HTTPS (443)? [S/n]: S
Deseja adicionar portas customizadas? [s/N]: S
Digite a porta (ou 'fim' para terminar): 5432
Protocolo (tcp/udp) [tcp]: tcp
```

#### Fail2Ban

O Fail2Ban monitora os logs do sistema e bane automaticamente endereços IP que apresentam comportamento malicioso, como múltiplas tentativas de login falhadas.

Parâmetros configuráveis:

- **Tempo de Banimento**: Duração em segundos que um IP permanece banido (padrão: 3600 segundos = 1 hora)
- **Máximo de Tentativas**: Número de tentativas falhadas antes do banimento (padrão: 5 tentativas)
- **Janela de Tempo**: Período em que as tentativas são contabilizadas (padrão: 600 segundos = 10 minutos)

#### Política de Senhas

A política de senhas implementa requisitos de complexidade usando a biblioteca PAM (Pluggable Authentication Modules):

| Parâmetro | Padrão | Descrição |
| :--- | :--- | :--- |
| **Comprimento Mínimo** | 12 caracteres | Tamanho mínimo da senha |
| **Classes de Caracteres** | 3 | Número mínimo de tipos (maiúsculas, minúsculas, números, especiais) |
| **Caracteres Repetidos** | 3 | Máximo de caracteres idênticos consecutivos |
| **Expiração** | 90 dias | Dias até a senha expirar |
| **Intervalo Mínimo** | 7 dias | Dias mínimos entre mudanças de senha |
| **Aviso de Expiração** | 14 dias | Dias de aviso antes da expiração |

#### Atualizações Automáticas

O script configura o sistema para instalar automaticamente atualizações de segurança, reduzindo a janela de vulnerabilidade a exploits conhecidos. As atualizações são aplicadas diariamente durante a madrugada para minimizar impacto nos usuários.

Para distribuições baseadas em Debian/Ubuntu, o **unattended-upgrades** é configurado para:
- Atualizar apenas pacotes de segurança
- Remover pacotes de kernel antigos automaticamente
- Remover dependências não utilizadas
- Opcionalmente reiniciar o servidor às 03:00 se necessário

#### Hardening do Kernel

As configurações de hardening do kernel via sysctl incluem proteções contra diversos tipos de ataque:

- **Proteção contra IP Spoofing**: Valida a origem dos pacotes de rede
- **Desabilitar IP Forwarding**: Impede que o servidor atue como roteador
- **Proteção SYN Flood**: Ativa SYN cookies para prevenir ataques de negação de serviço
- **Ignorar ICMP Redirects**: Previne redirecionamento malicioso de tráfego
- **Randomização de Espaço de Endereços**: Dificulta exploits de buffer overflow
- **Restrição de Acesso ao Kernel**: Limita acesso a informações sensíveis do kernel

### Configurações de Monitoramento

#### Ferramentas de Monitoramento

O script instala um conjunto de ferramentas essenciais para monitoramento do servidor:

| Ferramenta | Função |
| :--- | :--- |
| **htop** | Monitor interativo de processos com interface colorida e ordenação flexível |
| **iotop** | Monitor de I/O de disco mostrando quais processos estão lendo/escrevendo |
| **nethogs** | Monitor de uso de rede por processo, útil para identificar consumo excessivo |
| **ncdu** | Analisador de uso de disco com interface interativa para navegação |
| **sysstat** | Conjunto de ferramentas para coleta de estatísticas de desempenho (sar, iostat, mpstat) |

Após a instalação, você pode usar estas ferramentas a qualquer momento:

```bash
# Monitor de processos
htop

# Monitor de I/O de disco
sudo iotop

# Monitor de uso de rede
sudo nethogs

# Analisar uso de disco
ncdu /

# Estatísticas de CPU
mpstat 1 5

# Estatísticas de I/O
iostat -x 1 5
```

#### Rotação de Logs

A rotação de logs previne que os arquivos de log cresçam indefinidamente e consumam todo o espaço em disco. O script configura o logrotate para:

- **Rotação Diária**: Logs são rotacionados diariamente
- **Retenção Configurável**: Você define por quantos dias manter os logs (padrão: 30 dias)
- **Compressão Opcional**: Logs antigos podem ser comprimidos para economizar espaço
- **Rotação Inteligente**: Apenas rotaciona se o arquivo não estiver vazio

### Configurações de Backup

#### Script de Backup Automatizado

O script cria um sistema completo de backup que inclui:

**Componentes do Backup**:
- Configurações do sistema (SSH, firewall, Fail2Ban, etc.)
- Dados da aplicação ERP (se existirem em `/opt/erp/data`)
- Banco de dados PostgreSQL (dump completo)
- Checksums SHA256 para verificação de integridade

**Parâmetros Configuráveis**:

| Parâmetro | Descrição | Padrão |
| :--- | :--- | :--- |
| **Diretório de Destino** | Onde os backups serão armazenados | `/backup/erp` |
| **Retenção** | Dias para manter backups antigos | 30 dias |
| **Agendamento** | Frequência de execução automática | Diário às 03:00 |

**Estrutura do Backup**:
```
/backup/erp/
├── erp-backup-20251228-030000/
│   ├── system-config.tar.gz
│   ├── app-data.tar.gz
│   ├── database.sql.gz
│   └── checksums.txt
├── erp-backup-20251229-030000/
│   └── ...
```

#### Agendamento de Backups

O script oferece três opções de agendamento:

1. **Diário (03:00)**: Backup executado todos os dias às 3h da manhã
2. **Semanal (Domingo 03:00)**: Backup executado apenas aos domingos
3. **Personalizado**: Você define a expressão cron manualmente

**Exemplos de Expressões Cron**:
```bash
# Diário às 03:00
0 3 * * *

# Semanal aos domingos às 03:00
0 3 * * 0

# A cada 6 horas
0 */6 * * *

# Segunda a sexta às 23:00
0 23 * * 1-5
```

#### Execução Manual de Backup

Você pode executar um backup manualmente a qualquer momento:

```bash
sudo /usr/local/bin/erp-backup.sh
```

Os logs de backup são salvos em `/var/log/erp-backup.log`.

### Configurações do Sistema

#### Desabilitar Serviços Desnecessários

Serviços desnecessários aumentam a superfície de ataque e consomem recursos do sistema. O script identifica e oferece a opção de desabilitar:

- **avahi-daemon**: Serviço de descoberta de rede (Zeroconf/Bonjour)
- **cups**: Sistema de impressão CUPS
- **bluetooth**: Serviço Bluetooth
- **iscsid**: Daemon iSCSI (necessário apenas se usar storage iSCSI)

Cada serviço é apresentado individualmente para que você decida se deseja desabilitá-lo.

#### Atualização do Sistema

Esta opção executa uma atualização completa do sistema operacional, instalando todos os pacotes disponíveis:

```bash
# Ubuntu/Debian
apt update && apt upgrade -y

# CentOS/RHEL/Fedora
yum update -y
```

### Geração de Relatório

O relatório de configuração fornece uma visão geral do estado atual do servidor, incluindo:

- Informações do sistema (distribuição, kernel, uptime)
- Status dos serviços de segurança (firewall, Fail2Ban, SSH)
- Ferramentas de monitoramento instaladas
- Configuração de backup
- Localização dos logs

O relatório é salvo em `/var/log/erp-setup/config-report-YYYYMMDD-HHMMSS.txt` e também exibido na tela.

## Estrutura de Arquivos

O script cria e utiliza a seguinte estrutura de diretórios:

```
/var/log/erp-setup/
├── setup-20251228-140000.log          # Log de execução do script
└── config-report-20251228-140500.txt  # Relatório de configuração

/var/backups/erp-setup/
├── sshd_config.backup-20251228-140100
├── jail.local.backup-20251228-140200
└── ...                                # Backups de arquivos de configuração

/usr/local/bin/
└── erp-backup.sh                      # Script de backup automatizado

/etc/ssh/sshd_config.d/
└── erp-hardening.conf                 # Configurações SSH personalizadas

/etc/sysctl.d/
└── 99-erp-hardening.conf              # Configurações de hardening do kernel

/etc/fail2ban/
└── jail.local                         # Configurações do Fail2Ban

/etc/security/
└── pwquality.conf                     # Política de senhas

/etc/apt/apt.conf.d/
├── 50unattended-upgrades              # Configuração de atualizações automáticas
└── 20auto-upgrades                    # Frequência de atualizações

/etc/logrotate.d/
└── erp-custom                         # Configuração de rotação de logs
```

## Solução de Problemas

### Problemas Comuns

#### Script não inicia

**Problema**: Mensagem de erro "Permission denied"

**Solução**: Certifique-se de que o script tem permissão de execução e está sendo executado como root:
```bash
chmod +x erp-server-setup.sh
sudo ./erp-server-setup.sh
```

#### SSH não conecta após configuração

**Problema**: Não consegue conectar via SSH após alterar a porta ou desabilitar autenticação por senha

**Solução**: Se você alterou a porta SSH, conecte usando:
```bash
ssh -p NOVA_PORTA usuario@servidor
```

Se desabilitou autenticação por senha sem configurar chave SSH, você precisará acessar o servidor fisicamente ou via console remoto e restaurar o backup:
```bash
sudo cp /var/backups/erp-setup/sshd_config.backup-* /etc/ssh/sshd_config
sudo systemctl restart sshd
```

#### Firewall bloqueou o acesso

**Problema**: Firewall está bloqueando conexões necessárias

**Solução**: Adicione a porta necessária ao firewall:
```bash
sudo ufw allow PORTA/tcp
sudo ufw status
```

#### Backup falha

**Problema**: Script de backup retorna erro

**Solução**: Verifique o log de backup para identificar o problema:
```bash
sudo tail -f /var/log/erp-backup.log
```

Problemas comuns incluem:
- Espaço em disco insuficiente no diretório de backup
- Permissões incorretas no diretório de destino
- Banco de dados não está rodando

### Restauração de Configurações

Se você precisar reverter alguma configuração, todos os arquivos originais foram salvos em `/var/backups/erp-setup/` com timestamp. Para restaurar:

```bash
# Listar backups disponíveis
ls -lh /var/backups/erp-setup/

# Restaurar um arquivo específico
sudo cp /var/backups/erp-setup/ARQUIVO.backup-TIMESTAMP /caminho/original/ARQUIVO

# Reiniciar o serviço correspondente
sudo systemctl restart SERVICO
```

### Logs e Auditoria

Todos os logs do script são salvos em `/var/log/erp-setup/` com timestamp. Para visualizar:

```bash
# Ver o último log
sudo tail -f /var/log/erp-setup/setup-*.log

# Buscar por erros
sudo grep -i error /var/log/erp-setup/*.log

# Buscar por avisos
sudo grep -i warning /var/log/erp-setup/*.log
```

## Boas Práticas

### Antes de Executar em Produção

1. **Teste em Ambiente de Desenvolvimento**: Execute o script primeiro em um servidor de teste para familiarizar-se com as opções e validar o comportamento
2. **Faça Backup Manual**: Antes de executar o script em produção, faça um snapshot ou backup completo do servidor
3. **Documente as Escolhas**: Anote as configurações personalizadas que você escolher para referência futura
4. **Planeje uma Janela de Manutenção**: Algumas configurações (especialmente SSH) podem interromper conexões ativas
5. **Tenha Acesso Alternativo**: Certifique-se de ter acesso ao console físico ou KVM em caso de problemas com SSH

### Após a Configuração

1. **Teste Todas as Conexões**: Verifique se consegue conectar via SSH, acessar serviços web, etc.
2. **Monitore os Logs**: Acompanhe os logs por alguns dias para identificar falsos positivos no Fail2Ban
3. **Valide os Backups**: Execute uma restauração de teste para garantir que os backups estão funcionando
4. **Documente o Ambiente**: Atualize sua documentação com as novas configurações de segurança
5. **Treine a Equipe**: Certifique-se de que a equipe conhece as novas políticas de senha e procedimentos de acesso

### Manutenção Contínua

1. **Revise os Logs Regularmente**: Verifique os logs de segurança e backup semanalmente
2. **Atualize o Script**: Mantenha o script atualizado com novas versões e patches de segurança
3. **Teste os Backups**: Execute restaurações de teste mensalmente
4. **Revise as Regras de Firewall**: Periodicamente revise e remova regras desnecessárias
5. **Monitore Alertas do Fail2Ban**: Investigue IPs banidos com frequência para identificar ataques persistentes

## Segurança e Privacidade

O script foi desenvolvido com segurança em mente:

- **Sem Coleta de Dados**: Nenhuma informação é enviada para servidores externos
- **Código Aberto**: Todo o código está disponível para inspeção
- **Backups Locais**: Todos os backups e logs são armazenados localmente no servidor
- **Validação de Entrada**: Todas as entradas do usuário são validadas antes de serem aplicadas
- **Execução Segura**: O script usa `set -euo pipefail` para falhar rapidamente em caso de erro

## Limitações Conhecidas

- O script foi testado principalmente em Ubuntu 20.04+ e Debian 11+. Outras distribuições podem requerer ajustes
- A configuração de banco de dados assume PostgreSQL. Outros bancos de dados requerem modificação do script de backup
- O script não configura SELinux (apenas sysctl). Para servidores RHEL/CentOS, considere configurar SELinux separadamente
- Não há suporte para ambientes containerizados (Docker, Kubernetes)

## Suporte e Contribuições

Para reportar problemas, sugerir melhorias ou contribuir com o projeto:

- **Issues**: Reporte bugs ou solicite features
- **Pull Requests**: Contribuições são bem-vindas
- **Documentação**: Ajude a melhorar esta documentação

## Licença

Este script é fornecido "como está", sem garantias de qualquer tipo. Use por sua conta e risco.

## Changelog

### Versão 1.0.0 (2025-12-28)
- Lançamento inicial
- Configuração completa de segurança (SSH, firewall, Fail2Ban)
- Política de senhas e atualizações automáticas
- Hardening do kernel
- Ferramentas de monitoramento
- Sistema de backup automatizado
- Interface interativa com menus coloridos
- Sistema de logging e auditoria
- Suporte para Ubuntu, Debian, CentOS, RHEL e Fedora

---
