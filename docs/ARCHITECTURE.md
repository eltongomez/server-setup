# Arquitetura e Estrutura do Projeto

## Visão Geral da Estrutura

```
server-setup/
│
├── 📄 README.md                    # Documentação principal
├── 📄 QUICKSTART.md                # Guia de início rápido
├── 📄 CONFIGURATIONS.md            # Guia técnico detalhado
├── 📄 CONTRIBUTING.md              # Guia de contribuição
├── 📄 CHANGELOG.md                 # Histórico de versões
├── 📄 LICENSE                      # Licença MIT
├── 📄 .gitignore                   # Arquivos ignorados pelo Git
│
├── 📁 scripts/                     # Scripts principais
│   ├── erp-server-setup.sh         # Script principal (migrado)
│   ├── erp-backup.sh               # Utilitário de backup (futuro)
│   └── install.sh                  # Script de instalação (futuro)
│
├── 📁 docs/                        # Documentação técnica
│   ├── ARCHITECTURE.md             # Este arquivo
│   ├── SECURITY.md                 # Guia de segurança
│   ├── TROUBLESHOOTING.md          # Resolução de problemas
│   └── API.md                      # Referência de funções (futuro)
│
├── 📁 tests/                       # Testes automatizados
│   ├── test_syntax.sh              # Verificação de sintaxe
│   ├── test_functions.sh           # Testes unitários
│   └── test_integration.sh         # Testes de integração
│
└── 📁 .github/
    └── workflows/
        ├── lint.yml                # Linting automático
        ├── test.yml                # Testes CI/CD
        └── release.yml             # Automação de release
```

## Fluxo de Execução Principal

```
┌──────────────────────────┐
│  erp-server-setup.sh     │
└──────────┬───────────────┘
           │
           ├─────────────────────────────────────┐
           │                                     │
    ┌──────▼────────┐             ┌──────────────▼────────┐
    │  Check: Root  │             │  Detect Distribution  │
    └──────┬────────┘             └──────────┬───────────┘
           │                                 │
           └────────────┬────────────────────┘
                        │
                ┌───────▼────────┐
                │  Main Menu     │
                └───┬──┬──┬──┬──┬─┘
                    │  │  │  │  │
        ┌───────────┘  │  │  │  └─────────────┐
        │              │  │  │                │
   ┌────▼────┐   ┌─────▼──┐ │  ┌──────────┐  │
   │Security │   │Monitor │  │  │ Backup   │  │
   └────┬────┘   └─────┬──┘   │  └──────────┘  │
        │              │      │                │
   ┌────┴────────────────────────────────┐     │
   │  Apply Configs & Backups            │     │
   │  Log All Operations                 │     │
   │  Verify Changes                     │     │
   └────┬─────────────────────────────────┘     │
        │                                       │
        └───────────────────┬───────────────────┘
                            │
                    ┌───────▼──────────┐
                    │  Generate Report │
                    └──────────────────┘
```

## Componentes Principais

### 1. **Security Module** (Segurança)
Responsável por hardening do servidor

```
Security
├── SSH Configuration
│   ├── Alter port
│   ├── Disable root login
│   └── Key-based authentication
├── Firewall (UFW)
│   ├── Enable firewall
│   ├── Configure rules
│   └── Manage exceptions
├── Fail2Ban
│   ├── Install & configure
│   ├── Set ban policies
│   └── Monitor intrusions
├── Password Policy
│   ├── Complexity requirements
│   ├── Expiration rules
│   └── History policy
├── Kernel Hardening (sysctl)
│   ├── IP spoofing protection
│   ├── SYN flood mitigation
│   └── Randomize ASLR
└── Automatic Updates
    └── Unattended upgrades
```

### 2. **Monitoring Module** (Monitoramento)
Ferramentas para observabilidade

```
Monitoring
├── System Tools
│   ├── htop - Process monitoring
│   ├── iotop - I/O monitoring
│   ├── nethogs - Network monitoring
│   ├── ncdu - Disk usage analyzer
│   └── sysstat - System statistics
└── Log Management
    ├── Logrotate configuration
    ├── Retention policies
    └── Compression settings
```

### 3. **Backup Module** (Backup)
Estratégia de proteção de dados

```
Backup
├── Backup Script (/usr/local/bin/erp-backup.sh)
│   ├── System configuration backup
│   ├── Application data backup
│   ├── Database backup (PostgreSQL)
│   └── Checksum verification
├── Scheduling (Cron)
│   ├── Daily, Weekly, Custom
│   └── Retention policies
└── Verification
    ├── Integrity checks (SHA256)
    └── Recovery testing
```

## Padrões de Codificação

### Convenções

| Área | Padrão |
|------|--------|
| **Shebang** | `#!/bin/bash` |
| **Error Handling** | `set -euo pipefail` |
| **Variables** | `readonly` para constantes, UPPER_CASE |
| **Functions** | snake_case, descritivas |
| **Strings** | `"$var"` sempre com quotes |
| **Conditionals** | `[[ ]]` nunca `[ ]` |
| **Line Length** | Max 100 caracteres |
| **Comments** | Explicar "por quê", não "o quê" |

### Exemplo de Função

```bash
################################################################################
# Descrição breve da função
#
# Argumentos:
#   $1 - Descrição do primeiro argumento
#   $2 - Descrição do segundo argumento (opcional)
#
# Retorna:
#   0 - Sucesso
#   1 - Erro específico
#
# Saída:
#   Mensagens de status para log
#
# Exemplo:
#   configure_service "nginx" "8080"
################################################################################
configure_service() {
    local service_name="$1"
    local port="${2:-3000}"
    
    if [[ ! -x "$(command -v "$service_name")" ]]; then
        print_message error "Serviço $service_name não encontrado"
        return 1
    fi
    
    print_message info "Configurando $service_name na porta $port"
    # ... configuração ...
    
    return 0
}
```

## Fluxo de Distribuição do Código

### Repositório Local
```
main branch (stable)
    │
    ├── develop branch (changes)
    │   │
    │   ├── feature/nova-funcionalidade (feature branches)
    │   └── fix/correcao-bug
    │
    └── tags v1.0.0, v1.1.0 (releases)
```

### CI/CD Pipeline
```
Commit Push
    ↓
├─ Lint/Syntax Check
├─ Run Tests
├─ Build Documentation
└─ Deploy to Staging (if main)
```

## Múltiplas Distribuições Suportadas

```
┌─────────────────────────────────────────────┐
│  Distribution Detection & Package Manager   │
├─────────────────────────────────────────────┤
│                                             │
│  Debian/Ubuntu Family                       │
│  ├─ Detector: /etc/debian_version          │
│  ├─ Package Manager: apt                    │
│  └─ Services: systemctl                     │
│                                             │
│  RedHat/CentOS Family                       │
│  ├─ Detector: /etc/redhat-release          │
│  ├─ Package Manager: yum/dnf               │
│  └─ Services: systemctl                     │
│                                             │
│  Fedora                                     │
│  ├─ Detector: /etc/fedora-release          │
│  ├─ Package Manager: dnf                    │
│  └─ Services: systemctl                     │
│                                             │
└─────────────────────────────────────────────┘
```

## Arquivos de Configuração Gerados

```
/etc/ssh/sshd_config                           # SSH configuration
/etc/security/pwquality.conf                   # Password policy
/etc/ufw/rules.v4 & rules.v6                   # Firewall rules
/etc/fail2ban/jail.local                       # Fail2Ban configuration
/etc/sysctl.d/99-erp-hardening.conf           # Kernel hardening
/etc/apt/apt.conf.d/50unattended-upgrades     # Auto updates (Debian)
/etc/logrotate.d/erp-custom                    # Log rotation
/usr/local/bin/erp-backup.sh                   # Backup script
```

## Backups Automáticos Criados

```
/var/backups/erp-setup/
├── sshd_config.bak
├── pwquality.conf.bak
├── jail.local.bak
└── ... (um backup antes de cada alteração)
```

## Logging

```
/var/log/erp-setup/
└── setup-YYYYMMDD-HHMMSS.log      # Logs de cada execução

Formato de Log:
[INFO]   Operação bem-sucedida
[✓]     Confirmação de sucesso
[⚠]     Aviso
[✗]     Erro crítico
```

## Métricas de Qualidade

| Métrica | Target | Status |
|---------|--------|--------|
| **Code Coverage** | > 80% | 🔄 Em desenvolvimento |
| **Documentation** | 100% | ✅ 90% |
| **Supported Distros** | ≥5 | ✅ 5 |
| **Error Handling** | Completo | ✅ Sim |
| **Security Audit** | Anual | 🔄 Próximo em Q2/2026 |

---

**Mantido por**: ERP Infrastructure Team  
**Última atualização**: 2025-12-28  
**Versão**: 1.0.0
