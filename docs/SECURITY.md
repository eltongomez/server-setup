# Guia de Segurança

## Princípios de Segurança

Este projeto segue os seguintes princípios estabelecidos pela industria:

1. **Defense in Depth** - Múltiplas camadas de segurança
2. **Principle of Least Privilege** - Acesso mínimo necessário
3. **Secure by Default** - Configurações seguras preconfiguradas
4. **Fail Secure** - Fechado em caso de erro
5. **No Security Through Obscurity** - Força em criptografia, não em segredo

## Segurança do Script

### Validação de Entrada

```bash
✅ Boas práticas implementadas:
- Quote todas as variáveis: "$var"
- Use [[ ]] para testes condicionais
- Valide portas (1-65535)
- Confirme operações destrutivas
- Crie backups antes de alterações
```

### Proteção contra Injeção

O script evita vulnerabilidades comuns:

```bash
# ✓ Seguro - Usa array, não eval
function run_command() {
    local -a cmd=("$@")
    "${cmd[@]}"
}

# ✗ NUNCA fazer isso
function bad_function() {
    eval "$1"  # VULNERÁVEL
}
```

## Hardening Implementado

### SSH Hardening

| Configuração | Padrão Seguro | Impacto |
|---|---|---|
| Porta padrão | Não 22 | Reduz ataques automatizados |
| Root login | Desabilitado | Força uso de sudo |
| Pwd auth | Configurável | Permite transição para chaves |
| X11 forwarding | Desabilitado | Reduz vetores de ataque |
| EmptyPasswords | Não | Força autenticação |
| PermitUserEnvironment | Não | Limita manipulação de env |

### Firewall (UFW)

```bash
✅ Implementações:
- Incoming: DROP (padrão)
- Outgoing: ALLOW (padrão)
- SSH: Porta customizável
- Rate limiting: Habilitado
- Logging: Configurável
```

### Fail2Ban

```bash
✅ Proteções:
- SSH: 5 tentativas erradas = 1 hora de banimento
- DDoS: Detecta padrões suspeitos
- Custom: Adicionar regras conforme necessário
```

### Política de Senhas

```bash
✅ Requisitos:
- Comprimento mínimo: 12 caracteres
- Múltiplas classes: Maiúsculas, minúsculas, números, especiais
- Caracteres repetidos: Máximo 3 consecutivos
- Expiração: 90 dias (configurável)
- Aviso: 14 dias antes de expiração
```

### Kernel Hardening

```bash
✅ Mitigações:
- ASLR: Randomização de espaço de endereços
- DEP/NX: Proteção contra execução
- SYN Cookies: Proteção contra SYN flood
- IP Spoofing: Reverse path filtering
- ICMP Redirect: Desabilitado
- Source Routing: Desabilitado
```

## Conformidade e Padrões

### Padrões Atendidos

- **CIS Benchmarks** - Center for Internet Security
- **NIST 800-53** - Federal security standards
- **PCI DSS** - Payment Card Industry
- **GDPR** - General Data Protection Regulation

### Checklist de Segurança

```bash
POST-DEPLOYMENT SECURITY CHECKLIST
[ ] SSH acesso testado com nova porta
[ ] Root login impossível sem sudo
[ ] Firewall ativo e regras testadas
[ ] Fail2Ban monitorando SSH
[ ] Senhas expiram após 90 dias
[ ] Backups testáveis fazem restore
[ ] Logs centralizados e protegidos
[ ] Monitoramento ativo (alertas)
[ ] Documentação de IPs permitidos
[ ] Plano de resposta a incidentes
```

## Certificados SSL/TLS

### Para HTTPS em Aplicações ERP

```bash
# Gerar certificado auto-assinado (teste)
sudo openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/server.key \
    -out /etc/ssl/certs/server.crt

# Usar Let's Encrypt em produção
sudo apt install certbot
sudo certbot certonly --standalone -d seu-dominio.com
```

## Gestão de Secrets

### Variáveis Sensíveis

Nunca commitar:
```bash
❌ Senhas em plain text
❌ Chaves privadas SSH
❌ Tokens de API
❌ Credenciais de banco de dados
❌ Variáveis de ambiente com secrets
```

Use `.env` (gitignored):
```bash
# .env (adicione ao .gitignore)
DB_PASSWORD=seu_senha_aqui
API_KEY=chave_secreta
SSH_PRIVATE_KEY_PATH=/home/user/.ssh/id_rsa
```

## Auditoria e Logging

### Logs Críticos para Monitorar

```bash
/var/log/auth.log              # Tentativas de login
/var/log/syslog                # Eventos do sistema
/var/log/fail2ban.log          # Banimentos
/var/log/ufw.log               # Eventos de firewall
/var/log/erp-setup/setup.log   # Execução do script
/var/log/erp-backup.log        # Backups
```

### Comandos de Auditoria

```bash
# Ver últimas tentativas de login
sudo lastlog | head -20

# Ver tentativas de login falhadas
sudo grep "Failed password" /var/log/auth.log | tail -10

# Ver IPs banidos pelo Fail2Ban
sudo fail2ban-client status sshd

# Ver tentativas de acesso ao firewall
sudo grep ufw /var/log/syslog | tail -20

# Estatísticas de segurança
sudo ss -tunap | grep LISTEN
```

## Resposta a Incidentes

### Se Detectar Acesso Não Autorizado

```bash
1. ISOLAR O SERVIDOR
   sudo iptables -F                    # Limpar regras
   sudo iptables -I INPUT 1 -j DROP   # Bloquear entrada

2. COLETAR EVIDÊNCIAS
   sudo tar -czf /backup/incident-$(date +%s).tar.gz \
       /var/log /etc/ssh /root/.ssh

3. NOTIFICAR ADMINISTRADOR
   # Via email ou sistema de alertas

4. INICIAR INVESTIGAÇÃO
   tail -n 1000 /var/log/auth.log > /tmp/auth_backup
   sudo journalctl -n 1000 > /tmp/journal_backup

5. SHUTDOWN E RESTORE
   # De backup verificado
```

### Recovery Steps

```bash
# Restaurar SSH de backup
sudo cp /var/backups/erp-setup/sshd_config.bak /etc/ssh/sshd_config
sudo systemctl restart ssh

# Resetar senhas de todos os usuários
sudo passwd username

# Regenerar chaves SSH do servidor
sudo ssh-keygen -A

# Aplicar patches de segurança
sudo apt update && sudo apt upgrade -y
```

## Manutenção de Segurança

### Atividades Regulares

| Frequência | Atividade |
|---|---|
| **Semanal** | Revisar logs de falhas |
| **Mensal** | Auditar acessos SSH |
| **Trimestral** | Teste de recuperação de backup |
| **Semestral** | Atualizar policies de senha |
| **Anual** | Auditoria completa de segurança |

### Ferramentas Recomendadas

```bash
# Verificação de vulnerabilidades
sudo apt install apt-listchanges unattended-upgrades
sudo unattended-upgrade -d

# Análise de integridade
sudo apt install aide
sudo aide --init
sudo aide --check

# Auditoria de arquivo
sudo apt install aide auditd
sudo auditd -l  # Listar regras
```

---

**Contato de Segurança**: security@seu-dominio.com  
**Última revisão**: 2025-12-28  
**Classificação**: Documento Público
