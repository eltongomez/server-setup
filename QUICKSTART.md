# Guia Rápido - Script de Configuração ERP

## Início Rápido (5 minutos)

### 1. Download e Preparação
```bash
# Tornar executável
chmod +x erp-server-setup.sh

# Executar como root
sudo ./erp-server-setup.sh
```

### 2. Configuração Recomendada para Novos Servidores

Escolha a opção **1. Configuração Completa** no menu principal.

O script irá perguntar sobre as seguintes configurações principais:

| Configuração | Recomendação | Observação |
|:---|:---|:---|
| **Porta SSH** | Alterar para porta não padrão (ex: 2222) | Reduz ataques automatizados |
| **Login Root SSH** | Desabilitar | Use sudo com usuário normal |
| **Autenticação por Senha** | Manter habilitada inicialmente | Desabilite após configurar chaves SSH |
| **Firewall HTTP/HTTPS** | Habilitar se for servidor web | Portas 80 e 443 |
| **Fail2Ban** | Habilitar | Padrão: 5 tentativas, ban de 1 hora |
| **Política de Senhas** | Habilitar | Mínimo 12 caracteres, 3 classes |
| **Atualizações Automáticas** | Habilitar | Apenas patches de segurança |
| **Backup Diário** | Habilitar | Às 03:00, retenção de 30 dias |

### 3. Após a Configuração

```bash
# Gerar relatório
sudo ./erp-server-setup.sh
# Escolher opção 6

# Testar nova porta SSH (se alterou)
ssh -p NOVA_PORTA usuario@servidor

# Verificar status do firewall
sudo ufw status verbose

# Verificar status do Fail2Ban
sudo fail2ban-client status sshd
```

## Comandos Úteis

### Monitoramento
```bash
htop                    # Monitor de processos
sudo iotop              # Monitor de I/O
sudo nethogs            # Monitor de rede
ncdu /                  # Uso de disco
```

### Backup
```bash
# Executar backup manual
sudo /usr/local/bin/erp-backup.sh

# Ver log de backup
sudo tail -f /var/log/erp-backup.log

# Listar backups
ls -lh /backup/erp/
```

### Segurança
```bash
# Status do firewall
sudo ufw status numbered

# Adicionar porta ao firewall
sudo ufw allow PORTA/tcp

# Ver IPs banidos pelo Fail2Ban
sudo fail2ban-client status sshd

# Desbanir um IP
sudo fail2ban-client set sshd unbanip IP_ADDRESS
```

### Logs
```bash
# Ver logs do script
sudo tail -f /var/log/erp-setup/setup-*.log

# Ver últimas tentativas de login SSH
sudo tail -f /var/log/auth.log

# Ver logs do sistema
sudo journalctl -f
```

## Solução Rápida de Problemas

### Não consigo conectar via SSH
```bash
# Verifique se o SSH está rodando
sudo systemctl status sshd

# Verifique a porta configurada
sudo grep "^Port" /etc/ssh/sshd_config

# Verifique o firewall
sudo ufw status
```

### Restaurar configuração SSH
```bash
sudo cp /var/backups/erp-setup/sshd_config.backup-* /etc/ssh/sshd_config
sudo systemctl restart sshd
```

### Firewall bloqueou acesso
```bash
# Desabilitar temporariamente
sudo ufw disable

# Adicionar porta necessária
sudo ufw allow PORTA/tcp

# Reabilitar
sudo ufw enable
```

## Checklist Pós-Configuração

- [ ] Consegue conectar via SSH na nova porta
- [ ] Firewall permite apenas portas necessárias
- [ ] Fail2Ban está ativo e monitorando
- [ ] Backup manual executado com sucesso
- [ ] Backup agendado configurado no cron
- [ ] Relatório de configuração gerado
- [ ] Documentação atualizada com configurações customizadas
- [ ] Equipe informada sobre novas políticas de senha
- [ ] Acesso de emergência ao console disponível

## Configurações Padrão

| Item | Valor Padrão |
|:---|:---|
| Porta SSH | 22 (recomendado alterar) |
| Fail2Ban - Banimento | 3600 segundos (1 hora) |
| Fail2Ban - Tentativas | 5 |
| Senha - Comprimento | 12 caracteres |
| Senha - Expiração | 90 dias |
| Backup - Retenção | 30 dias |
| Backup - Horário | 03:00 |
| Logs - Retenção | 30 dias |

## Próximos Passos

1. **Configurar Chaves SSH**: Após confirmar que tudo funciona, configure autenticação por chave SSH
2. **Monitoramento Avançado**: Considere instalar Prometheus + Grafana para monitoramento visual
3. **Backup Off-site**: Configure backup remoto seguindo a regra 3-2-1
4. **Testes de Penetração**: Execute testes de segurança periódicos
5. **Documentação**: Mantenha documentação atualizada das configurações

## Suporte

Para mais informações, consulte o arquivo `erp-server-setup-README.md` completo.

---

**Versão**: 1.0.0  
**Última Atualização**: Dezembro 2025
