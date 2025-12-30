# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [Unreleased]

## [1.0.1] - 2025-12-30

### Fixed
- 🐛 **Issue #1**: Criar diretório de log antes de primeira tentativa de escrita
  - O script tentava escrever logs antes de criar `/var/log/erp-setup`
  - Agora cria diretórios automaticamente na inicialização
- 🐛 **Issue #2**: Melhorar tratamento de erro ao reiniciar SSH
  - Serviço SSH falhava ao reiniciar em ambientes WSL2/containers mas exibia mensagem de sucesso
  - Agora valida corretamente e oferece instruções de reinicialização manual quando necessário
  - Suporta diferentes nomes de serviço (`sshd` vs `ssh`)
- 🔧 Tratamento robusto de erros para compatibilidade com múltiplos ambientes

### Added
- 📖 GitHub Pages com Jekyll para documentação interativa
- 📄 Arquivo de índice de documentação centralizado (docs/index.md)
- 🔄 Workflow de deploy automático para GitHub Pages
- 📦 Gemfile para gerenciamento de dependências Jekyll

## [1.0.0] - 2025-12-28

### Added
- ✨ Interface interativa com menus coloridos
- 🔒 Configuração completa de SSH com hardening
- 🛡️ Firewall UFW com regras customizáveis
- 🔐 Fail2Ban para proteção contra força bruta
- 🔑 Política de senhas configurável
- 🔄 Atualizações automáticas de segurança
- 🎯 Hardening de kernel via sysctl
- 📊 Ferramentas de monitoramento (htop, iotop, nethogs, ncdu, sysstat)
- 📋 Rotação automática de logs
- 💾 Script de backup automatizado com agendamento
- 📄 Logging detalhado com timestamps
- 📈 Suporte para múltiplas distribuições Linux (Ubuntu, Debian, CentOS, RHEL, Fedora)
- 🔙 Backup automático de configurações antes de alterações
- 📊 Geração de relatórios de configuração
- 📚 Documentação completa (README.md, QUICKSTART.md, CONFIGURATIONS.md)

### Features Técnicas
- Modo seco (dry-run) para teste sem alterações
- Validação de entradas do usuário
- Tratamento robusto de erros
- Suporte para rollback de mudanças
- Verificação de dependências

### Documentação
- README.md: Guia completo do projeto
- QUICKSTART.md: Primeiros passos em 5 minutos
- CONFIGURATIONS.md: Guia detalhado de segurança e manutenção
- Exemplos de uso para cada funcionalidade

## [Planejado] - Futuro

### Planned Features
- [ ] Testes automatizados com bats
- [ ] CI/CD com GitHub Actions
- [ ] Suporte para Kubernetes
- [ ] Integração com ferramentas de monitoramento (Prometheus, ELK Stack)
- [ ] Dashboard web para gerenciamento
- [ ] Suporte para diferentes tipos de aplicações (not just ERP)
- [ ] API REST para automação
- [ ] Notificações via Slack/Discord
- [ ] Replicação e sincronização de backups

### Melhorias Planejadas
- Modularização do código em múltiplos arquivos
- Testes de cobertura completa
- Performance otimizations
- Suporte para macOS e BSD

---

## Convenções de Versionamento

- **MAJOR**: Mudanças incompatíveis na interface ou comportamento significativo
- **MINOR**: Nova funcionalidade mantendo compatibilidade
- **PATCH**: Correção de bugs

### Política de Suporte

| Versão | Status | Suportada até |
|--------|--------|---------------|
| 1.x    | ✅ Ativa | 2026-12-28 |
| 0.x    | ❌ EOL | 2025-06-28 |

---

**Data da Última Atualização**: 2025-12-28
