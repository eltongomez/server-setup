# Resolução de Problemas

Guia completo para diagnosticar e resolver problemas comuns.

## Índice
1. [Problemas de Conexão SSH](#problemas-de-conexão-ssh)
2. [Problemas de Firewall](#problemas-de-firewall)
3. [Problemas de Backup](#problemas-de-backup)
4. [Problemas de Performance](#problemas-de-performance)
5. [Problemas de Distribuição](#problemas-de-distribuição)
6. [Debug Avançado](#debug-avançado)

---

## Problemas de Conexão SSH

### Não consigo conectar via SSH após mudança de porta

**Sintomas**: `ssh: connect to host X.X.X.X port YYYY: Connection refused`

**Solução**:
```bash
# 1. Verificar status do SSH
sudo systemctl status ssh

# 2. Verificar se a porta está escutando
sudo ss -tunap | grep sshd

# 3. Verificar se a porta está aberta no firewall
sudo ufw status | grep ALLOW

# 4. Se não estiver, adicionar exceção
sudo ufw allow PORT/tcp

# 5. Reiniciar SSH
sudo systemctl restart ssh

# 6. Teste de conexão
ssh -vv -p PORT usuario@servidor  # -vv para debug verboso
```

### Erro: "Permission denied (publickey)"

**Sintomas**: Autenticação por chave falha

**Solução**:
```bash
# 1. Verificar permissões de arquivo
ls -la ~/.ssh/
# Deve ser: rw------- (700)
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa

# 2. Verificar authorized_keys
ls -la ~/.ssh/authorized_keys
# Deve ser: rw------- (600)
chmod 600 ~/.ssh/authorized_keys

# 3. Verificar conteúdo da chave pública
cat ~/.ssh/id_rsa.pub
# Deve estar em authorized_keys:
cat ~/.ssh/authorized_keys

# 4. Testar verbosamente
ssh -vvv -i ~/.ssh/id_rsa usuario@servidor

# 5. Verificar configuração SSH do servidor
sudo nano /etc/ssh/sshd_config
# Procure por:
# PubkeyAuthentication yes
# AuthorizedKeysFile .ssh/authorized_keys

sudo systemctl restart ssh
```

### Erro: "Too many authentication failures"

**Sintomas**: Bloqueado temporariamente após várias tentativas

**Solução**:
```bash
# 1. Verificar banimento pelo Fail2Ban
sudo fail2ban-client status sshd

# 2. Desbanir seu IP
sudo fail2ban-client set sshd unbanip seu_ip

# 3. Aumentar tentativas (temporário)
ssh -o ConnectionAttempts=5 usuario@servidor

# 4. Se problema persistir, desabilitar Fail2Ban temporariamente
sudo systemctl stop fail2ban
# ... faça o teste ...
sudo systemctl start fail2ban
```

---

## Problemas de Firewall

### Firewall bloqueia portas legítimas

**Sintomas**: Portas permitem conexões mas parecem bloqueadas

**Solução**:
```bash
# 1. Listar todas as regras
sudo ufw status verbose

# 2. Testar conectividade de porta específica
nc -zv servidor porta  # Linux
telnet servidor porta  # Teste de conexão

# 3. Adicionar exceção se necessário
sudo ufw allow 8080/tcp description "App ERP"
sudo ufw allow 5432/tcp from 192.168.1.100 description "DB Access"

# 4. Reload regras
sudo ufw reload

# 5. Ver logs de bloqueio
sudo grep ufw /var/log/syslog | tail -20
```

### UFW não inicia

**Sintomas**: `ERROR: problem running ufw-init`

**Solução**:
```bash
# 1. Resetar UFW
sudo ufw reset

# 2. Reconfigurar
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 3. Reabilitar
sudo ufw enable

# 4. Verificar logs
sudo journalctl -u ufw | tail -50
```

---

## Problemas de Backup

### Backup falha com "Permission denied"

**Sintomas**: `tar: Permission denied` ao fazer backup

**Solução**:
```bash
# 1. Verificar permissões do diretório de backup
ls -la /backup/
# Mudar permissões se necessário
sudo chmod 755 /backup

# 2. Verificar propriedade
sudo chown root:root /backup

# 3. Verificar permissões do arquivo
ls -la /usr/local/bin/erp-backup.sh
sudo chmod 755 /usr/local/bin/erp-backup.sh

# 4. Executar com privilégios
sudo /usr/local/bin/erp-backup.sh

# 5. Ver log
sudo tail -f /var/log/erp-backup.log
```

### Backup muito lento

**Sintomas**: Backup demora horas ou não completa

**Solução**:
```bash
# 1. Monitorar I/O em tempo real
sudo iotop -o -b

# 2. Ver uso de CPU
top -b -n 1 | head -15

# 3. Se disco está cheio
df -h
du -sh /*

# 4. Otimizar script de backup
# Desabilitar compressão se rede é lenta:
tar -cf arquivo.tar diretorio  # sem -z

# Ou usar compressão mais rápida
tar -cf - arquivo | gzip -1 > arquivo.tar.gz1  # -1 = menor compressão

# 5. Limpar backups antigos manualmente
find /backup -type d -mtime +30 -exec rm -rf {} \;
```

### Restauração de backup falha

**Sintomas**: Erro ao descompactar ou restaurar arquivos

**Solução**:
```bash
# 1. Verificar integridade do backup
cd /backup/erp-backup-YYYYMMDD-HHMMSS
sha256sum -c checksums.txt

# 2. Se falhar, tentar restaurar com tar verboso
tar -xzvf system-config.tar.gz -C / --verbose

# 3. Restaurar arquivo específico
tar -xzf sistema-config.tar.gz -C / etc/ssh/sshd_config

# 4. Se backup está corrompido, usar versão anterior
ls -lh /backup/
```

---

## Problemas de Performance

### Servidor lento ou não responsivo

**Sintomas**: Aplicações lentas, timeouts, alta latência

**Solução**:
```bash
# 1. Verificar uso de CPU
top -b -n 1
ps aux --sort=-%cpu | head -10

# 2. Verificar uso de memória
free -h
vmstat 1 5

# 3. Verificar I/O de disco
iostat -x 1 5
iotop -o

# 4. Verificar rede
nethogs
ss -tunap | grep LISTEN
netstat -tan | grep ESTABLISHED | wc -l

# 5. Ver processo específico
htop  # Interface interativa
ps aux | grep processo_name
lsof -p PID  # Arquivos abertos por processo

# 6. Encontrar problemas de disco
du -sh /* | sort -rh
find / -type f -size +100M

# 7. Limpar espaço em disco
sudo apt clean
sudo apt autoclean
sudo journalctl --vacuum=30d  # Manter apenas 30 dias

# 8. Verificar processos "zumbis"
ps aux | grep defunct
```

### Memória insuficiente

**Sintomas**: OOM (Out of Memory) killer, swap alto

**Solução**:
```bash
# 1. Ver memória disponível
free -h

# 2. Processos mais pesados
ps aux --sort=-%mem | head -10

# 3. Ver uso de swap
swapon -s
free | grep Swap

# 4. Criar swap temporário se necessário
sudo dd if=/dev/zero of=/swapfile bs=1G count=2
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 5. Aumentar limite de memória da aplicação
# Editar /etc/default/aplicacao ou configuration file
```

---

## Problemas de Distribuição

### Script falha em distribuição X

**Sintomas**: Comando não encontrado, sintaxe inválida

**Solução**:
```bash
# 1. Identificar distribuição
cat /etc/os-release
lsb_release -a

# 2. Verificar versão do Bash
bash --version

# 3. Verificar se packae manager está correto
which apt || which yum || which dnf

# 4. Executar script com debug
bash -x /caminho/script.sh 2>&1 | tee debug.log

# 5. Verificar se pacotes obrigatórios estão instalados
dpkg -l | grep pacote  # Debian
rpm -qa | grep pacote  # RedHat

# 6. Se falta pacote:
sudo apt install pacote  # Debian
sudo yum install pacote  # RedHat
```

---

## Debug Avançado

### Ativar modo verbose no script

```bash
# Executar com debug completo
bash -x erp-server-setup.sh 2>&1 | tee setup-debug.log

# Ou dentro do script, adicione:
set -x  # Ativar debug
# ... código ...
set +x  # Desativar debug
```

### Analisar logs em tempo real

```bash
# Ver logs conforme são gerados
sudo tail -f /var/log/erp-setup/setup-*.log

# Filtrar por tipo de mensagem
grep "\[ERROR\]" /var/log/erp-setup/setup-*.log

# Buscar por timestamp específico
grep "2025-12-28 14:30" /var/log/erp-setup/setup-*.log

# Contar eventos por tipo
grep -o "\[.\+\]" /var/log/erp-setup/setup-*.log | sort | uniq -c
```

### Verificar logs do sistema

```bash
# Ver mensagens de erro recentes
sudo journalctl -p err -n 50

# Ver logs de serviço específico
sudo journalctl -u ssh -n 50
sudo journalctl -u fail2ban -n 50

# Ver logs desde última execução
sudo journalctl --since "1 hour ago"

# Seguir logs em tempo real
sudo journalctl -f
```

### Testar configurações antes de aplicar

```bash
# SSH - verificar sintaxe
sudo sshd -t

# Firewall - modo dry-run não existe, mas você pode revisar
sudo ufw show added

# Systemctl - verificar unidade
sudo systemctl status ssh

# Bash - verificar sintaxe
bash -n script.sh
```

---

## Contatos de Suporte

- **Documentação**: [README.md](../README.md)
- **Issue Tracker**: GitHub Issues
- **Email**: support@seu-dominio.com
- **Slack**: #infra-support

---

**Última atualização**: 2025-12-28  
**Versão**: 1.0.0
