# 🔐 GitHub Token Setup

## ⚡ Quick Start

### 1️⃣ Criar arquivo `.env`

```bash
# Copiar template
cp .env.example .env

# Editar e adicionar seu token real
nano .env
# ou
code .env
```

### 2️⃣ Adicionar token do GitHub

```bash
# Abrir .env
GITHUB_TOKEN="ghp_seu_token_real_aqui"
```

### 3️⃣ Carregar no terminal

```bash
# No terminal do VS Code:
source .env

# Verificar
echo $GITHUB_TOKEN
```

### 4️⃣ Rodar scripts

```bash
python3 /tmp/create_issues.py
```

---

## 🔑 Como Obter um Token

1. Ir para: https://github.com/settings/tokens
2. Clicar **"Generate new token"** → **"Generate new token (classic)"**
3. **Nome**: `server-setup-automation`
4. **Escopos**:
   - ✅ `repo` - Acesso a repositórios
   - ✅ `project` - Ler/escrever projects
5. **Expiração**: 30 ou 90 dias
6. **Copiar token** (aparece apenas uma vez!)

---

## 🔒 Segurança

| ✅ Fazer | ❌ Evitar |
|---------|----------|
| `.env` com permissões `600` | Commitar `.env` no git |
| Usar `source .env` | Expor token em logs |
| Rotacionar mensalmente | Compartilhar token |
| Escopo mínimo necessário | Token pessoal em automação |

---

## 📋 Arquivos de Configuração

```
.env.example  ← Template (commitado, sem valores reais)
.env          ← Seu token real (NO .gitignore, NÃO commitado)
```

---

## 🚀 Integração VS Code

### Opção A: Terminal (Recomendado)

```bash
# No terminal integrado do VS Code:
cd /Volumes/DATA/infra/server-setup
source .env
echo $GITHUB_TOKEN
```

### Opção B: Automático (Editar `~/.zshrc`)

```bash
# Adicionar ao ~/.zshrc:
if [ -f "$PWD/.env" ]; then
    source "$PWD/.env"
fi

# Recarregar:
source ~/.zshrc
```

---

## ✅ Verificação

```bash
# 1. Verificar se arquivo existe
ls -la .env

# 2. Verificar permissões (deve ser 600)
ls -l .env
# -rw------- ...

# 3. Verificar token carregado
echo $GITHUB_TOKEN
# Deve mostrar: ghp_xxxxxxxxxxxxx

# 4. Testar criação de issue
python3 /tmp/create_issues.py
```

---

## 🆘 Troubleshooting

### Token não aparece
```bash
# Verificar se arquivo existe
test -f .env && echo "Existe" || echo "Não existe"

# Carregar novamente
source .env

# Verificar conteúdo
cat .env
```

### Permissão negada
```bash
# Deve ser leitura/escrita apenas para você
chmod 600 .env
```

### Token expirou
```bash
# Gerar novo em: https://github.com/settings/tokens
# Atualizar .env
nano .env
```

---

**Última atualização**: 2025-12-30
