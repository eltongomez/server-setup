# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [Unreleased]

### [1.1.0] - Planejado (Março 2026)

#### P0 - Features Críticas
- 🔧 Modularização do código em múltiplos arquivos (scripts/core, scripts/modules)
- 🧪 Testes automatizados com BATS (cobertura ≥ 80%)
- 📊 Relatórios avançados em HTML/JSON com dashboard
- 🔄 Integração com Prometheus/Node Exporter para monitoramento

#### P1 - Features Altas
- 🔔 Sistema de notificações via Slack/Discord/Webhook
- 📋 Modo de auditoria estendido com rastreamento completo
- 🔐 Logging remoto via syslog para compliance

#### P2 - Features Médias (v1.2.0)
- 🌐 Interface web de gerenciamento (dashboard)
- 🚀 API REST para automação e integração
- 📱 Suporte para diferentes perfis de aplicação

#### P3 - Features Baixas (v1.2.0+)
- 🍎 Suporte para macOS e BSD
- ☸️ Otimizações para Kubernetes

### Documentação Adicional
- 📚 [ROADMAP.md](ROADMAP.md) - Roadmap completo do projeto
- 🏗️ Architecture Decision Records (ADR) para design decisions
- 🧪 Teste strategy e cobertura de testes

## [1.0.1] - 2025-12-30

### Fixed
- 🐛 Criação de diretório de logs antes da primeira tentativa de escrita (#1)
- 🐛 Tratamento robusto de erro ao reiniciar serviço SSH em ambientes WSL2/containers (#2)
- ✅ Validação de configuração SSH antes de reinicializar serviço
- 📋 Mensagens de erro mais claras para diagnóstico

### Changed
- 🔧 Melhor compatibilidade com diferentes ambientes Linux
- 📝 Instruções de reinicialização manual quando necessário

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
