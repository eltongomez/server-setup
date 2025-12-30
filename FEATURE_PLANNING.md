# v1.1.0 Feature Planning Discussion

## 🎯 Objetivo

Planejar e definir features para a próxima release major (v1.1.0) com foco em modularização, testes e integrações avançadas.

## 📋 Features Propostas

Veja o arquivo [ROADMAP.md](ROADMAP.md) para uma análise detalhada de cada feature incluindo:

- **Descrição** - O que a feature faz
- **Escopo** - Funcionalidades incluídas
- **Benefícios** - Por que é importante
- **Prioridade** - P0 (crítica), P1 (alta), P2 (média), P3 (baixa)

## 🗳️ Votar nas Features

Se você tem interesse em usar a v1.1.0, vote com reactions nos comentários abaixo:

- 👍 **Aprovo** - Implementar essa feature
- 👎 **Desaprovo** - Não é prioritário
- 🤔 **Dúvida** - Precisa de mais informação
- 📌 **Importante para meu caso de uso**

## 💬 Discussão por Tópico

### 1. Modularização de Código
**Descrição**: Dividir script monolítico em múltiplos arquivos modulares.

Reações esperadas: 
- Desenvolvedores contribuidores 👍
- Usuários que usam via package manager 👍

**Questões**:
- Preferência por estrutura de pastas?
- Backward compatibility com configuração existente?

---

### 2. Testes Automatizados (BATS)
**Descrição**: Framework de testes para validar cada módulo.

**Questões**:
- Cobertura mínima (80%, 90%)?
- Testes em quais distribuições?
- Testes de integração também?

---

### 3. Relatórios HTML/JSON
**Descrição**: Gerar relatório pós-configuração exportável.

**Questões**:
- Incluir métricas de security scan?
- Formato JSON para integração com Terraform/Ansible?
- Dashboard interativo ou estático?

---

### 4. Integração Prometheus
**Descrição**: Preparar servidor para coleta de métricas com Prometheus.

**Questões**:
- Node Exporter apenas ou custom exporters também?
- Alertas pré-configurados?
- Suporte para outras soluções (Datadog, New Relic)?

---

### 5. Notificações (Slack/Discord/Webhook)
**Descrição**: Notificar eventos importantes em tempo real.

**Questões**:
- Qual é a prioridade: Slack, Discord ou Webhook genérico?
- Quais eventos notificar?
- Integração com Mattermost também?

---

### 6. Modo Auditoria Estendido
**Descrição**: Logging detalhado para compliance (GDPR, SOX).

**Questões**:
- Qual é o seu caso de uso de compliance?
- Qual syslog remoto usar? (rsyslog, syslog-ng, CloudWatch, Stackdriver)
- Precisa de criptografia e assinatura de logs?

---

### 7. Web UI (v1.2.0)
**Descrição**: Dashboard para visualizar e gerenciar configurações.

**Questões**:
- Preferência: React, Vue ou HTML5 simples?
- Read-only (visualização) ou full-featured (edição)?
- Autenticação: Local, OAuth2 ou ambos?

---

### 8. API REST (v1.2.0)
**Descrição**: API para automação e integração com ferramentas IaC.

**Questões**:
- Suportar apenas GET ou também POST/PATCH/DELETE?
- Rate limiting necessário?
- Versioning (v1, v2)?

---

## 🚀 Timeline Proposta

```
Janeiro 2026:  Modularização + BATS
Fevereiro 2026: Relatórios + Prometheus + Webhooks + Auditoria
Março 2026:    v1.1.0 release
Junho 2026:    v1.2.0 com Web UI + API
```

**Flexível baseado em feedback da comunidade**.

---

## 📞 Como Participar

1. **Vote nas features** usando reactions
2. **Comente** com sua opinião/caso de uso
3. **Sugira features** que faltam nessa lista
4. **Ofereça-se** para ajudar no desenvolvimento

## 🤝 Contribuindo

Se quer ajudar com desenvolvimento:

1. Veja [CONTRIBUTING.md](CONTRIBUTING.md) para guidelines
2. Escolha uma feature em que quer trabalhar
3. Comente nessa issue indicando seu interesse
4. Abriremos uma PR para discussão/review

---

## 📚 Referências

- [ROADMAP.md](ROADMAP.md) - Documento técnico completo
- [CHANGELOG.md](CHANGELOG.md) - Histórico de releases
- [CONTRIBUTING.md](CONTRIBUTING.md) - Guia de contribuição

---

**Discussão aberta até**: 2026-01-15

Sua opinião importa! 💙
