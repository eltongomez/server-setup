---
layout: default
---

# 🖥️ ERP Server Setup

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub version](https://img.shields.io/badge/version-1.0.0-green.svg)]()
[![Bash 4.0+](https://img.shields.io/badge/bash-4.0%2B-blue.svg)]()
[![Linux](https://img.shields.io/badge/linux-5%20distros-brightgreen.svg)]()

**Script profissional de configuração automatizada para servidores Linux em ambiente de produção**

Automatize segurança, monitoramento e backup com um único script interativo.

---

## ✨ Características Principais

### 🔒 Segurança
- SSH hardening com autenticação por chave
- Firewall UFW com regras customizáveis
- Fail2Ban para proteção contra força bruta
- Política de senhas configurável
- Atualizações automáticas de segurança
- Hardening de kernel via sysctl

### 📊 Monitoramento
- Ferramentas integradas: htop, iotop, nethogs, ncdu, sysstat
- Logging detalhado com timestamps
- Geração de relatórios de configuração
- Validação contínua de configurações

### 💾 Backup & Recuperação
- Script de backup automatizado com agendamento
- Backup automático de configurações
- Rollback facilitado com histórico
- Rotação automática de logs

### 🚀 Praticidade
- Interface interativa com menus coloridos
- Valores padrão inteligentes
- Personalização completa
- Suporte multi-distribuição

---

## 📋 Requisitos Mínimos

| Componente | Especificação |
|:---|:---|
| **SO** | Ubuntu 18.04+, Debian 10+, CentOS 7+, RHEL 7+, Fedora 30+ |
| **Privilégios** | root (sudo) |
| **Shell** | Bash 4.0+ |
| **Disco** | 500 MB livres |
| **RAM** | 1 GB (2 GB recomendado) |

---

## 🚀 Quick Start (5 minutos)

```bash
# Download e preparação
wget https://github.com/eltongomez/server-setup/raw/main/erp-server-setup.sh
chmod +x erp-server-setup.sh

# Executar
sudo ./erp-server-setup.sh

# Escolha opção 1 para Configuração Completa
```

**Primeiro uso?** Veja [Quick Start Guide](../QUICKSTART.md)

---

## 📚 Documentação Completa

### Para Começar
- **[Quick Start Guide](../QUICKSTART.md)** - 5 minutos para começar
- **[README Completo](../README.md)** - Guia detalhado

### Documentação Técnica
- **[Arquitetura](docs/ARCHITECTURE.md)** - Componentes e design
- **[Segurança](docs/SECURITY.md)** - Best practices de hardening
- **[Configurações](../CONFIGURATIONS.md)** - Guia completo de parâmetros
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Resolvendo problemas

### Para Contribuidores
- **[Contributing](../CONTRIBUTING.md)** - Como contribuir
- **[Git Setup](../GIT_SETUP_GUIDE.md)** - Workflow Git
- **[Changelog](../CHANGELOG.md)** - Histórico de versões

---

## 💡 Casos de Uso

✅ **Novos Servidores** - Configuração completa e segura em minutos  
✅ **Hardening** - Aplicar best practices de segurança  
✅ **Automação** - Reduzir configuração manual  
✅ **Compliance** - Atender requisitos de segurança  
✅ **Monitoramento** - Visibilidade contínua do servidor  

---

## 🔗 Links Úteis

- **[Repositório GitHub](https://github.com/eltongomez/server-setup)** - Código-fonte
- **[Releases](https://github.com/eltongomez/server-setup/releases)** - Versões
- **[Issues](https://github.com/eltongomez/server-setup/issues)** - Reporte bugs
- **[Discussões](https://github.com/eltongomez/server-setup/discussions)** - Comunidade

---

## 📞 Contato

**Autor**: Elton Gomez  
**Email**: eltongslima@hotmail.com  
**GitHub**: [@eltongomez](https://github.com/eltongomez)  

---

## 📄 Licença

Licenciado sob [MIT License](../LICENSE)

---

**Versão**: 1.0.0 | **Última atualização**: 29 de dezembro de 2025

