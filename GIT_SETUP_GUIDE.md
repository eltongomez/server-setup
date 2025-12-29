# Git Remote Configuration Guide

## Status Atual do Repositório

✅ Repositório local inicializado e estruturado profissionalmente
✅ Branch `main` com commit inicial
✅ Branch `develop` criada (pronta para desenvolvimento)
✅ Conventional Commits configurado
✅ Git Flow implementado
✅ .gitattributes configurado
✅ Pre-commit hooks disponível

---

## Próximos Passos: Conectar ao Repositório Remoto

### Opção 1: Criar Novo Repositório no GitHub

```bash
# 1. Ir para https://github.com/new
# 2. Preencher:
#    - Repository name: server-setup
#    - Description: Automated professional server setup script
#    - Public/Private: (escolha)
#    - NÃO inicializar com README, .gitignore, etc
# 3. Clicar "Create repository"

# 4. Adicionar remote ao repositório local
cd /Volumes/DATA/infra/server-setup
git remote add origin https://github.com/seu-usuario/server-setup.git

# 5. Renomear branch (GitHub usa 'main' por padrão)
git branch -M main

# 6. Fazer push das branches
git push -u origin main
git push -u origin develop

# 7. Configurar branch protection (GitHub web UI)
```

### Opção 2: Repositório GitLab

```bash
# 1. Ir para https://gitlab.com/projects/new
# 2. Preencher detalhes
# 3. Não inicializar com arquivos

cd /Volumes/DATA/infra/server-setup
git remote add origin https://gitlab.com/seu-usuario/server-setup.git
git push -u origin main
git push -u origin develop
```

### Opção 3: Repositório Privado (Gitea, GitLab Self-Hosted, etc)

```bash
cd /Volumes/DATA/infra/server-setup
git remote add origin https://seu-servidor-git/seu-usuario/server-setup.git
git push -u origin main
git push -u origin develop
```

---

## Verificar Status do Repositório

```bash
# Ver branches locais e remotas
git branch -a

# Ver remotes configurados
git remote -v

# Ver log de commits
git log --oneline --graph --all

# Ver status
git status
```

---

## Estrutura Git Atual

```
main (production ready)
  └─ chore: initial commit with professional structure...

develop (development integration)
  └─ (mesmo commit que main, aguardando features)
```

---

## Git Flow: Próximos Passos de Desenvolvimento

### Para Desenvolver Nova Feature

```bash
# 1. Criar branch de feature a partir de develop
git checkout develop
git pull origin develop  # Quando remoto estiver configurado
git checkout -b feature/descricao-curta

# 2. Fazer trabalho e commits
git add arquivo.sh
git commit -m "feat(modulo): adicionar nova funcionalidade"

# 3. Push e criar Pull Request
git push -u origin feature/descricao-curta
# No GitHub/GitLab: criar PR de feature/* para develop

# 4. Após review e merge
git checkout develop
git pull origin develop
git merge --no-ff feature/descricao-curta
git push origin develop
git branch -d feature/descricao-curta
```

### Para Fazer Release

```bash
# 1. Criar branch de release
git checkout -b release/1.1.0 develop

# 2. Atualizar versões (CHANGELOG.md, package.json, script)
git commit -m "chore(release): bump version to 1.1.0"

# 3. Merge para main com tag
git checkout main
git merge --no-ff release/1.1.0
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin main
git push origin v1.1.0

# 4. Merge de volta para develop
git checkout develop
git merge --no-ff release/1.1.0
git push origin develop

# 5. Cleanup
git branch -d release/1.1.0
```

---

## Configurar Branch Protection Rules (GitHub)

Após fazer push para GitHub:

### Para main (production)

1. Ir para: Settings → Branches → Add rule
2. Branch name pattern: `main`
3. Habilitar:
   - ✅ Require a pull request before merging
   - ✅ Require approvals (mínimo 2)
   - ✅ Require status checks to pass (lint, tests)
   - ✅ Require branches to be up to date
   - ✅ Include administrators

### Para develop

1. Branch name pattern: `develop`
2. Habilitar:
   - ✅ Require a pull request before merging
   - ✅ Require approvals (mínimo 1)
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date

---

## Configurar Code Owners (CODEOWNERS)

Criar arquivo `.github/CODEOWNERS`:

```
# Default owners for everything
* @seu-usuario

# Documentação
*.md @seu-usuario
/docs/ @seu-usuario

# Scripts
scripts/ @seu-usuario

# CI/CD
.github/ @seu-usuario

# Segurança
docs/SECURITY.md @seu-usuario
```

---

## Configurar Issue Templates (GitHub)

Criar em `.github/ISSUE_TEMPLATE/`:

### bug_report.md
```yaml
---
name: Bug report
about: Reportar um bug
---

## Descrição
<!-- Descrição clara do bug -->

## Passos para reproduzir
1. ...
2. ...

## Comportamento esperado
<!-- O que deveria acontecer -->

## Comportamento atual
<!-- O que realmente acontece -->

## Informações do sistema
- OS: 
- Bash:
- Versão do script:
```

### feature_request.md
```yaml
---
name: Feature request
about: Sugerir uma nova feature
---

## Descrição
<!-- Descrição clara da feature -->

## Caso de uso
<!-- Quando você usaria isso? -->

## Solução proposta
<!-- Como você implementaria? -->

## Alternativas
<!-- Outras soluções possíveis -->
```

---

## Workflow de Colaboração

```
1. Fork/Clone do repositório
   ↓
2. Criar branch feature/* a partir de develop
   ↓
3. Implementar com commits semânticos
   ↓
4. Push e criar Pull Request para develop
   ↓
5. Review + CI/CD checks
   ↓
6. Merge com --no-ff
   ↓
7. Delete branch remota
   ↓
8. Quando release: criar release/* de develop
   ↓
9. Merge para main com tag
   ↓
10. GitHub Actions cria release automático
```

---

## Comandos Úteis Git

```bash
# Ver diferenças
git diff main develop
git diff --stat

# Ver quem modificou cada linha
git blame arquivo.sh

# Buscar por padrão
git log -S "padrão" --oneline

# Revert de commit
git revert HASH

# Reset (cuidado!)
git reset --soft HEAD~1  # Desfazer commit, manter mudanças
git reset --hard HEAD~1  # Desfazer tudo

# Cherry-pick
git cherry-pick HASH

# Stash
git stash
git stash pop

# Rebase interativo
git rebase -i HEAD~3
```

---

## Checklist Pré-Push

Antes de fazer push para main:

```
☑️ Todos os testes passando
☑️ ShellCheck sem warnings
☑️ Markdown validado
☑️ CHANGELOG.md atualizado
☑️ package.json com versão correta
☑️ README.md atualizado (se necessário)
☑️ CONTRIBUTING.md revisado
☑️ Commits seguem Conventional Commits
☑️ Branch up-to-date com develop
☑️ Code review feito e aprovado
```

---

## Automação com GitHub Actions

Os seguintes workflows foram configurados:

- **lint.yml**: Verifica sintaxe, linting, markdown
- **test.yml**: Executa testes automatizados
- **release.yml**: Cria releases automáticas

Eles rodam automaticamente em:
- Push para main/develop
- Pull requests

---

## Políticas de Commit

- ✅ Commits atômicos (uma mudança por commit)
- ✅ Mensagens descritivas seguindo Conventional Commits
- ✅ Sem commits como "fix" ou "update"
- ✅ Referenciar issues: "Closes #123"
- ✅ Máximo 50 caracteres no subject
- ✅ Máximo 72 caracteres no body

---

## Exemplo de Workflow Completo

```bash
# 1. Começar feature
git checkout develop
git pull origin develop
git checkout -b feature/ssh-port-config

# 2. Editar e commitar
echo '# Configuração de porta SSH' >> docs/SSH.md
git add docs/SSH.md
git commit -m "docs(ssh): adicionar documentação de porta customizável"

# 3. Editar script
nano scripts/erp-server-setup.sh
git add scripts/erp-server-setup.sh
git commit -m "feat(ssh): permitir configuração de porta customizável

Usuários agora podem escolher a porta SSH ao invés
de usar a padrão 22. Adicionada validação de portas
válidas (1-65535).

Closes #15"

# 4. Push
git push -u origin feature/ssh-port-config

# 5. No GitHub: criar Pull Request
# 6. Esperar CI/CD passar
# 7. Request review
# 8. Após approval: merge com --no-ff
# 9. Delete branch remota

git checkout develop
git pull origin develop
git branch -d feature/ssh-port-config
```

---

## Próximas Ações

1. **Criar repositório remoto** (GitHub/GitLab)
2. **Executar**:
   ```bash
   git remote add origin https://seu-repo-url
   git push -u origin main
   git push -u origin develop
   ```
3. **Configurar branch protection** no GitHub/GitLab
4. **Configurar CODEOWNERS** (opcional)
5. **Configurar issue templates** (opcional)
6. **Começar development** com features em develop

---

**Status**: ✅ Repositório local pronto para push  
**Branches**: main, develop  
**Commits**: 1 (initial)  
**Próximo**: Conectar a repositório remoto
