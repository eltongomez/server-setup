# Plano de Features - v1.1.0

**Objetivo**: Adicionar funcionalidades de monitoramento avançado, modularização de código e melhor integração com ferramentas externas.

**Data planejada**: 2026-03-30 (3 meses após v1.0.1)

---

## 📋 Features Priorizadas para v1.1.0

### P0 - Crítica (Deve incluir)

#### 1. **Modularização do Código** (Sprint 1)
- **Descrição**: Dividir `erp-server-setup.sh` em múltiplos arquivos modulares
- **Objetivo**: Melhorar manutenibilidade, testabilidade e reutilização
- **Estrutura proposta**:
  ```
  scripts/
  ├── core/
  │   ├── functions.sh          # Funções utilitárias gerais
  │   ├── logging.sh            # Sistema de logging
  │   ├── colors.sh             # Cores e formatação
  │   └── validation.sh         # Validações gerais
  ├── modules/
  │   ├── ssh-hardening.sh      # Configuração SSH
  │   ├── firewall.sh           # Configuração UFW
  │   ├── fail2ban.sh           # Proteção contra força bruta
  │   ├── password-policy.sh    # Política de senhas
  │   ├── kernel-hardening.sh   # Hardening do kernel
  │   ├── monitoring.sh         # Ferramentas de monitoramento
  │   ├── security-updates.sh   # Atualizações de segurança
  │   └── backups.sh            # Sistema de backup
  ├── config/
  │   └── defaults.conf         # Configurações padrão
  └── erp-server-setup.sh       # Script principal (orquestrador)
  ```
- **Benefícios**:
  - Código mais limpo e testável
  - Reutilização de funções
  - Facilita contribuições da comunidade
  - Melhor documentação inline

#### 2. **Testes Automatizados com BATS** (Sprint 1-2)
- **Descrição**: Framework BATS para testes unitários e integração
- **Escopo inicial**:
  - Testes das funções utilitárias
  - Testes de validação de entrada
  - Testes de cada módulo em modo dry-run
  - Testes de rollback
- **CI/CD**: Integrar testes nos workflows GitHub Actions
- **Cobertura alvo**: 80%+

#### 3. **Sistema de Relatórios Melhorado** (Sprint 2)
- **Descrição**: Gerar relatórios HTML/JSON com status do servidor
- **Funcionalidades**:
  - Relatório pós-configuração em HTML (exportável)
  - Relatório em JSON para integração com ferramentas externas
  - Dashboard simples em HTML5 (sem dependências)
  - Exportar logs em múltiplos formatos
- **Aplicações**: Útil para compliance e auditoria

---

### P1 - Alta (Deveria incluir)

#### 4. **Integração com Prometheus/Node Exporter** (Sprint 2-3)
- **Descrição**: Configurar automáticamente Node Exporter para métricas Prometheus
- **Escopo**:
  - Instalação e configuração do Node Exporter
  - Regras Fail2Ban para alertas
  - Scrape config para Prometheus (template)
  - Métricas customizadas via textfile collector
- **Benefício**: Monitoramento centralizado com Prometheus/Grafana

#### 5. **Notificações via Webhook** (Sprint 3)
- **Descrição**: Sistema de notificação flexível via webhooks
- **Suporte**:
  - Slack: Notificar eventos importantes
  - Discord: Alternativa para comunidades
  - Generic HTTP Webhook: Customizável
- **Eventos**:
  - Configuração concluída
  - Erro durante execução
  - Eventos de segurança (falhas SSH, atualizações, etc.)

#### 6. **Modo de Auditoria Estendido** (Sprint 3)
- **Descrição**: Log detalhado para compliance (GDPR, SOX, etc.)
- **Funcionalidades**:
  - Registro de todas as mudanças com hash
  - Logs com timestamps em UTC
  - Integração com syslog remoto (rsyslog/syslog-ng)
  - Relatório de mudanças por data/hora
  - Rastreamento de quem executou o script (usuario, IP)

---

### P2 - Média (Legal ter)

#### 7. **Interface Web de Gerenciamento** (Sprint 4-5)
- **Descrição**: Dashboard web básico para visualizar/gerenciar configurações
- **Escopo MVP**:
  - Visualizar status das configurações
  - Gerar relatórios
  - Rever logs
  - Interface read-only inicialmente
- **Tech**: Node.js Express + React (ou HTML5 simples)
- **Segurança**: Autenticação, SSL/TLS obrigatório

#### 8. **API REST para Automação** (Sprint 5)
- **Descrição**: API REST para integração com ferramentas de IaC
- **Endpoints básicos**:
  - `GET /api/status` - Status atual das configurações
  - `POST /api/configure` - Aplicar configuração (com validação)
  - `GET /api/logs` - Histórico de logs
  - `GET /api/reports` - Relatórios
- **Segurança**: API Key + Rate limiting

---

### P3 - Baixa (Nice to have)

#### 9. **Suporte para Diferentes Aplicações** (Sprint 6)
- **Descrição**: Perfis otimizados para diferentes tipos de apps
- **Perfis iniciais**:
  - Web Server (Apache/Nginx)
  - Database (MySQL/PostgreSQL)
  - Kubernetes Node
  - Container Host (Docker)
  - Desenvolvimento

#### 10. **Suporte macOS/BSD** (Sprint 6)
- **Descrição**: Adaptar scripts para ambientes não-Linux
- **Escopo**: Teste com macOS 13+, FreeBSD 13+
- **Funcionalidades limitadas** por falta de UFW, etc.

---

## 📊 Roadmap Visual

```
v1.0.1 (Atual)
    ↓
v1.1.0-alpha (6 semanas)
    ├─ Semana 1-2: Modularização + BATS
    ├─ Semana 2-3: Relatórios + Prometheus
    ├─ Semana 3-4: Webhooks + Auditoria
    └─ Semana 4-6: Testes, docs, QA
    ↓
v1.1.0-beta (2 semanas)
    └─ Testes comunitários, feedback
    ↓
v1.1.0 (Março 2026)
    ↓
v1.2.0 (Junho 2026)
    ├─ Web UI
    ├─ API REST
    └─ Múltiplas aplicações
```

---

## 🛠️ Próximas Ações

### Imediato (Esta semana)
1. [ ] Revisar e aprovar features P0 e P1
2. [ ] Criar issue template para cada feature
3. [ ] Criar milestones no GitHub
4. [ ] Configurar project board para v1.1.0

### Semana que vem
1. [ ] Criar branch `develop-1.1` para novo desenvolvimento
2. [ ] Começar refatoração para modularização
3. [ ] Criar estrutura de testes BATS
4. [ ] Documentar design decisions em ADR (Architecture Decision Records)

### Comunicação
- [ ] Atualizar CHANGELOG.md com [Unreleased] planejado
- [ ] Abrir discussão na comunidade (GitHub Discussions)
- [ ] Publicar roadmap público (ROADMAP.md)

---

## 📝 Documentação Necessária

Para cada feature P0 e P1:
1. **Design Document** - Como a feature funciona
2. **User Guide** - Como o usuário utiliza
3. **Troubleshooting Guide** - Problemas comuns
4. **API Reference** - Se aplicável

---

## 🎯 Critério de Sucesso v1.1.0

- ✅ Código dividido em 80%+ de módulos independentes
- ✅ Cobertura de testes ≥ 80%
- ✅ Todas as features P0 implementadas
- ✅ Documentação completa
- ✅ Zero breaking changes
- ✅ Performance ≤ 10% mais lenta (por modularização)
- ✅ Suporte técnico para 3+ sistemas operacionais

---

## 💡 Feedback/Discussão

**Perguntas para decidir**:
1. Prioridade: Web UI vs API REST?
2. Qual distribuição testar primeiro para suporte expandido?
3. Preferência: Prometheus ou Grafana agent?
4. Suportar Kubernetes desde agora ou v1.2.0?

---

**Status**: 📋 Draft - Aguardando aprovação e feedback

**Última atualização**: 2025-12-30
