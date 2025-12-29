# Guia de Contribuição

Obrigado por contribuir com o projeto ERP Server Setup! Este documento descreve como contribuir de forma responsável e profissional.

## Código de Conduta

Esperamos que todos os colaboradores sigam um comportamento respeitoso e profissional. Discriminação, abuso ou harassment de qualquer tipo não será tolerado.

## Como Contribuir

### 1. Reportar Bugs

Se encontrar um bug, por favor:

- **Verifique se o bug já foi reportado** no GitHub Issues
- **Forneça detalhes específicos**:
  - Distribuição Linux e versão
  - Bash version (`bash --version`)
  - Output completo do erro
  - Passos para reproduzir o problema
  - Comportamento esperado vs real
- **Exemplo de relatório bem estruturado**:

```
**Título**: SSH configure falha no Ubuntu 20.04

**Descrição**: O script falha ao tentar configurar SSH

**Passos para reproduzir**:
1. Ubuntu 20.04.5 LTS
2. Executar: `sudo ./erp-server-setup.sh`
3. Selecionar opção 2 (Segurança) > 1 (Configurar SSH)
4. Aceitar valores padrão

**Output do erro**:
[✗] Erro ao criar backup de /etc/ssh/sshd_config

**Versão**: v1.0.0
**Bash**: GNU bash 5.0.17
```

### 2. Sugerir Melhorias

Para sugerir uma feature ou melhoria:

- Abra uma issue com o label `enhancement`
- Descreva claramente o problema que resolve
- Explique a solução proposta
- Forneça exemplos de uso

### 3. Submeter Pull Requests

#### Antes de começar

1. **Fork o repositório**
2. **Clone seu fork**: `git clone https://github.com/eltongomez/server-setup.git`
3. **Crie uma branch**: `git checkout -b fix/seu-feature`

#### Padrões de Código

**Shell Script**:
- Use `#!/bin/bash` e `set -euo pipefail`
- Declare variáveis como `readonly` quando apropriado
- Use `[[ ]]` para testes condicionais, não `[ ]`
- Quote todas as variáveis: `"$var"` não `$var`
- Adicione comentários explicativos para blocos complexos
- Use funções para código reutilizável
- Mantenha linhas com máximo 100 caracteres

**Exemplo de bom código**:
```bash
# ✓ Correto
readonly CONFIG_DIR="/etc/myapp"
readonly DEFAULT_PORT=8080

configure_app() {
    local port="${1:-$DEFAULT_PORT}"
    
    if [[ ! -d "$CONFIG_DIR" ]]; then
        mkdir -p "$CONFIG_DIR"
    fi
    
    echo "Configurando porta: $port"
}

# ✗ Evitar
configureApp () {
    port=$1
    mkdir -p $CONFIG_DIR
    echo "Configurando porta: " $port
}
```

#### Commits

- **Mensagens claras e concisas**: `fix: SSH configure backup error on Ubuntu 20.04`
- **Prefixos obrigatórios**:
  - `feat:` - Nova feature
  - `fix:` - Correção de bug
  - `docs:` - Documentação
  - `test:` - Testes
  - `refactor:` - Refatoração
  - `perf:` - Performance
  - `chore:` - Manutenção, dependências

**Exemplo**:
```bash
# Bom
git commit -m "feat: add PostgreSQL backup support for automated backups"

# Evitar
git commit -m "updates" ou "mudanças aleatórias"
```

#### Testes

Antes de submeter um PR:

```bash
# Verificar sintaxe Bash
bash -n scripts/erp-server-setup.sh

# Rodar testes (quando aplicável)
cd tests && bash run_tests.sh
```

#### Documentação

- Atualize [README.md](README.md) se sua mudança afeta o uso
- Mantenha o [CHANGELOG.md](CHANGELOG.md) atualizado
- Adicione comentários no código para lógica complexa
- Documenta parâmetros de função quando aplicável

### 4. Processo de Review

1. Um mantenedor fará review de seu PR
2. Podem ser solicitadas alterações
3. Uma vez aprovado, será merged para main

## Estrutura do Projeto

```
server-setup/
├── scripts/              # Scripts principais
├── docs/                 # Documentação
├── tests/                # Testes
├── .github/workflows/    # CI/CD
├── README.md             # Documentação principal
├── CHANGELOG.md          # Histórico de mudanças
├── CONTRIBUTING.md       # Este arquivo
└── LICENSE               # Licença
```

## Desenvolvimento Local

### Ambiente de Testes

Para testar mudanças em um servidor seguro:

```bash
# Ativar modo dry-run (não faz mudanças reais)
./scripts/erp-server-setup.sh --dry-run

# Verificar contra diferentes distribuições
docker run -it ubuntu:20.04 bash
docker run -it debian:11 bash
docker run -it centos:8 bash
```

### Debugging

```bash
# Modo verbose
bash -x scripts/erp-server-setup.sh

# Ver logs da última execução
tail -f /var/log/erp-setup/setup-*.log
```

## Perguntas?

- 📧 Email: eltongslima@hotmail.com
- 💬 Issues: [GitHub Issues](https://github.com/eltongomez/server-setup/issues)
- 📖 Wiki: [GitHub Wiki](https://github.com/eltongomez/server-setup/wiki)

---

**Obrigado por contribuir!** 🙏
