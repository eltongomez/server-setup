# Packaging Structure

Esta documentação descreve a estrutura profissional de packaging do projeto para distribuição em repositórios PPA APT.

## 📦 Estrutura de Diretórios

```
debian/
├── control          # Metadados do pacote (dependências, descrição)
├── rules            # Instruções de build
├── changelog        # Histórico de versões
├── copyright        # Informações de licença
├── compat           # Versão de compatibilidade do debhelper
├── install          # Arquivos a instalar
├── postinst         # Script executado após instalação
└── preinst          # Script executado antes da instalação

.ppa                 # Configuração do PPA (informações de publicação)
build-deb.sh         # Script para build local
PPA_GUIDE.md         # Guia detalhado de publicação
PACKAGING.md         # Este arquivo
```

## 📋 Arquivos de Packaging

### debian/control
Define metadados essenciais do pacote:
- **Source**: Nome do pacote fonte
- **Section**: Categoria (admin, libs, etc)
- **Priority**: Prioridade de instalação
- **Maintainer**: Informações do mantenedor
- **Build-Depends**: Dependências para compilação
- **Standards-Version**: Versão dos padrões Debian
- **Homepage**: Página do projeto
- **Vcs-***: Informações de controle de versão

Cada pacote binário defini:
- **Architecture**: Arquitetura suportada (all, amd64, etc)
- **Depends**: Dependências obrigatórias
- **Recommends**: Dependências recomendadas
- **Suggests**: Dependências opcionais

### debian/rules
Script Makefile que controla o build:
- Validação de sintaxe bash
- Cópia de arquivos para destinos apropriados
- Instalação de documentação
- Aplicação de flags de hardening

### debian/changelog
Histórico de versões em formato Debian:
- Versão do pacote
- Distribuição alvo
- Urgência
- Mudanças realizadas
- Data e mantenedor

### debian/copyright
Informações de licença e autoria:
- Upstream information
- Detalhes de copyright por arquivo
- Texto completo da licença (MIT)

### debian/compat
Versão de compatibilidade do debhelper (atualmente 13)

### debian/install
Lista de arquivos a instalar:
- Formato: `source_file destination_directory`
- Inclui script principal, docs, etc

### debian/postinst
Script executado após instalação:
- Criar diretórios necessários
- Configurar permissões
- Criar symlinks
- Exibir mensagens pós-instalação

### debian/preinst
Script executado antes da instalação:
- Validações pré-instalação
- Verificação de dependências
- Limpeza de versões antigas

## 🔨 Build Local

### Pré-requisitos
```bash
sudo apt-get install dpkg-dev debhelper devscripts
```

### Compilar Pacote Binário
```bash
./build-deb.sh --binary
# ou
dpkg-buildpackage -us -uc -b
```

Resultado: `erp-server-setup_1.0.0-1_amd64.deb`

### Compilar Pacote Fonte para PPA
```bash
./build-deb.sh --source
# ou
dpkg-buildpackage -S -us -uc
```

Resultado:
- `erp-server-setup_1.0.0-1.dsc`
- `erp-server-setup_1.0.0-1.debian.tar.gz`
- `erp-server-setup_1.0.0-1.changes`

### Compilar Tudo
```bash
./build-deb.sh --all
```

### Apenas Validar Sintaxe
```bash
./build-deb.sh --validate
```

## 📤 Publicação em PPA

### Fluxo Geral

1. **Criar PPA no Launchpad**
   - Acesso: https://launchpad.net/~username/+create-ppa

2. **Configurar chave GPG**
   ```bash
   gpg --full-generate-key
   gpg --send-keys <KEY_ID>
   ```

3. **Configurar dput**
   ```bash
   cat > ~/.dput.cf << EOF
   [ppa]
   fqdn = ppa.launchpad.net
   method = sftp
   incoming = ~%(ppa)s/ubuntu/
   login = username
   EOF
   ```

4. **Build e assinatura**
   ```bash
   ./build-deb.sh --source
   debsign -k<KEY_ID> *.changes
   ```

5. **Upload**
   ```bash
   dput ppa:eltongomez/erp-server-setup *.changes
   ```

### Instalação pelo PPA

```bash
sudo add-apt-repository ppa:eltongomez/erp-server-setup
sudo apt-get update
sudo apt-get install erp-server-setup
```

## 🔍 Verificação de Qualidade

### Lint do Debian
```bash
lintian erp-server-setup_1.0.0-1_amd64.deb
```

### Verificar Conteúdo do Pacote
```bash
dpkg-deb -c erp-server-setup_1.0.0-1_amd64.deb
```

### Verificar Metadados
```bash
dpkg-deb -I erp-server-setup_1.0.0-1_amd64.deb
```

## 📝 Versionamento

Formato Debian: `UPSTREAM_VERSION-DEBIAN_REVISION`

Exemplo: `1.0.0-1`
- `1.0.0`: Versão upstream do projeto
- `1`: Revisão Debian (incrementar para mudanças no packaging)

Para nova versão upstream:
```bash
# Atualizar version em package.json
# Atualizar debian/changelog com nova entrada
debchange -i  # Ou editar manualmente
```

## 🚀 Automação com GitHub Actions

O projeto inclui workflow automatizado em `.github/workflows/build-deb.yml`:

- ✅ Build automático em cada push
- ✅ Testes de instalação
- ✅ Validação de sintaxe
- ✅ Publicação em releases (para tags)
- ✅ Artefatos preservados por 30-90 dias

## 📊 Distribuições Suportadas

No `debian/control`, especificamos suporte para:
- Ubuntu 16.04 LTS (Xenial)
- Ubuntu 18.04 LTS (Bionic)
- Ubuntu 20.04 LTS (Focal)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)

## 🔧 Manutenção

### Atualizar para Nova Versão

1. Editar `debian/changelog`:
   ```bash
   debchange -i
   ```

2. Atualizar versão em `package.json`

3. Fazer commit e criar tag:
   ```bash
   git add debian/changelog package.json
   git commit -m "chore: bump version to 1.1.0"
   git tag v1.1.0
   git push origin main
   git push origin v1.1.0
   ```

4. O GitHub Actions automaticamente:
   - Constrói pacotes
   - Cria release com artefatos

5. Para PPA:
   ```bash
   ./build-deb.sh --source
   debsign -k<KEY_ID> *.changes
   dput ppa:eltongomez/erp-server-setup *.changes
   ```

## 📚 Referências

- [Debian Packaging Guide](https://www.debian.org/doc/manuals/packaging-tutorial/)
- [Ubuntu PPA Help](https://help.launchpad.net/Packaging/PPA)
- [Debhelper Manual](https://manpages.debian.org/debhelper)
- [Debian Policy Manual](https://www.debian.org/doc/debian-policy/)
- [Lintian](https://manpages.debian.org/lintian)

## ✅ Checklist para Publicação

- [ ] Versão atualizada em `package.json`
- [ ] `debian/changelog` atualizado
- [ ] Validação de sintaxe bash: `bash -n erp-server-setup.sh`
- [ ] Build local bem-sucedido: `./build-deb.sh --binary`
- [ ] Lintian sem erros críticos
- [ ] Git commit e tag criados
- [ ] PPA assinado e enviado
- [ ] Instalação testada do PPA
- [ ] GitHub Release criado com artefatos
