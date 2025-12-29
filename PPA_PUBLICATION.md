# 📦 PPA Publication Guide

Este guia explica como publicar o `erp-server-setup` no Launchpad PPA (Personal Package Archive).

## ⚠️ Importante: macOS vs Linux

**No macOS**: Ferramentas como `dput`, `debsign` e `dpkg-buildpackage` não estão disponíveis nativamente.

**Solução**: Use uma VM Linux ou SSH em um servidor Ubuntu para fazer o build e upload.

---

## 📋 Pré-Requisitos

### No Linux (Ubuntu/Debian):
```bash
sudo apt-get install -y \
    gnupg \
    dput \
    devscripts \
    debian-goodies \
    dpkg-dev \
    build-essential
```

### GPG Key (Global - macOS ou Linux):
```bash
gpg --full-generate-key

# Escolha:
# - Type: RSA (1)
# - Size: 4096
# - Validity: 1y (1 ano) ou 2y
# - Name: Seu Nome
# - Email: eltongslima@hotmail.com
# - Passphrase: Use uma senha forte!

# Obtenha o ID da chave:
gpg --list-keys | grep -A1 "eltongslima@hotmail.com"
# Resultado será: sec   rsa4096/XXXXXXXXXX
# Use: XXXXXXXXXX (últimos 16 caracteres)

export KEY_ID="XXXXXXXXXX"
```

---

## 🚀 Step-by-Step: Publicar no PPA

### **1. Criar Conta e PPA no Launchpad**

- Acesse: https://launchpad.net/~eltongomez
- Clique: "Create a new PPA"
- Nome: `server-setup`
- Descrição: `ERP Server Setup - Automated server configuration script`
- Clique: "Create PPA"

Resultado: `ppa:eltongomez/server-setup`

### **2. Adicionar Chave GPG ao Launchpad**

```bash
# Exporte sua chave pública
gpg --armor --export $KEY_ID > gpg-public-key.txt

# Copie o conteúdo (incluindo BEGIN e END)
cat gpg-public-key.txt
```

- Vá em: https://launchpad.net/~eltongomez/+gpg-keys
- Cole a chave no campo "Import New PPA Key"
- Clique: "Import Key"
- Confirme via email

### **3. Configurar Local de Build**

```bash
# Clone o repositório
git clone https://github.com/eltongomez/server-setup.git
cd server-setup

# Configure devscripts (arquivo ~/.devscripts)
cat >> ~/.devscripts << EOF
DEBSIGN_KEYID=$KEY_ID
DEBUILD_DPKG_BUILDPACKAGE_OPTS="-i -I"
EOF

# Ou exporte a variável direto
export DEBSIGN_KEYID=$KEY_ID
```

### **4. Build do Pacote Source**

```bash
cd server-setup

# Build source package
dpkg-buildpackage -S -sa -k$KEY_ID

# Resultado em ../
ls -lh ../*.changes ../*.dsc ../*.tar.gz
```

**Esperado:**
- `server-setup_1.0.0-1.dsc`
- `server-setup_1.0.0-1_source.changes`
- `server-setup_1.0.0-1.tar.gz`

### **5. Verificar Integridade**

```bash
# Verificar assinatura
debsign -k$KEY_ID ../*.changes

# Validar pacote
lintian ../*.changes
```

### **6. Upload para PPA**

```bash
# Upload
dput ppa:eltongomez/server-setup ../*_source.changes

# Resultado esperado:
# "Uploading to ppa (via sftp) ..."
# "Successfully uploaded packages."
```

### **7. Monitorar Build**

- Acesse: https://launchpad.net/~eltongomez/+builds
- Aguarde o build para cada distribuição (Focal, Jammy, Mantic, etc)
- Quando completar, estará disponível em `ppa:eltongomez/server-setup`

---

## ✅ Usar o PPA Publicado

Uma vez disponível, usuários poderão instalar com:

```bash
sudo add-apt-repository ppa:eltongomez/server-setup
sudo apt update
sudo apt install erp-server-setup
```

---

## 🤖 Script Automatizado

Há um script pronto: `ppa-publish.sh`

```bash
# Torne executável
chmod +x ppa-publish.sh

# Execute (após preparar o ambiente)
export DEBSIGN_KEYID="your-key-id"
./ppa-publish.sh
```

---

## 🔧 Troubleshooting

### Erro: "Packages were not signed"
```bash
# Assine manualmente
debsign -k$KEY_ID *_source.changes
```

### Erro: "Authentication failed"
- Verifique se a chave GPG está adicionada no Launchpad
- Confirme o email de confirmação

### Erro: "Lintian warnings"
```bash
# Se as warning são ok, upload mesmo assim
dput -f ppa:eltongomez/server-setup *_source.changes
```

### Verificar versão na PPA
```bash
# Acesse
https://launchpad.net/~eltongomez/+archive/ubuntu/server-setup
```

---

## 📚 Recursos Úteis

- [Launchpad PPA Guide](https://help.launchpad.net/Packaging/PPA)
- [dput Documentation](https://manpages.ubuntu.com/manpages/focal/man1/dput.1.html)
- [Debian Packaging](https://wiki.debian.org/PackagingTutorial)
- [GPG Key Guide](https://help.launchpad.net/YourAccount/ImportingYourGPGKey)

---

## 🎯 Resumo Rápido

```bash
# 1. Criar chave GPG
gpg --full-generate-key
export KEY_ID="your-key-id"

# 2. Criar PPA em https://launchpad.net
# 3. Adicionar chave GPG ao Launchpad
# 4. Em um servidor Ubuntu:

git clone https://github.com/eltongomez/server-setup.git
cd server-setup

# 5. Build
dpkg-buildpackage -S -sa -k$KEY_ID

# 6. Upload
dput ppa:eltongomez/server-setup ../*_source.changes

# 7. Monitorar em https://launchpad.net/~eltongomez/+builds
```

---

**Última atualização**: 29 de dezembro de 2025  
**Status**: ✅ Pronto para publicação
