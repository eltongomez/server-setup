#!/bin/bash
# Script para conectar repositório local ao remoto e fazer push
# Uso: ./push-to-remote.sh

set -euo pipefail

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Git Push to Remote - ERP Server Setup                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}\n"

# Verificar se está em repositório Git
if [ ! -d .git ]; then
    echo -e "${RED}✗ Erro: Não está em um repositório Git${NC}"
    exit 1
fi

# Verificar se tem remote
if git remote | grep -q origin; then
    echo -e "${GREEN}✓ Remote 'origin' já configurada${NC}"
    git remote -v
else
    echo -e "${YELLOW}⚠ Remote 'origin' não configurada${NC}\n"
    echo "Escolha uma opção:"
    echo "1) GitHub SSH (recomendado com chaves SSH)"
    echo "2) GitHub HTTPS"
    echo "3) GitLab"
    echo "4) Outro (você digitará a URL)"
    read -r -p "Opção (1-4): " option
    
    case $option in
        1)
            read -r -p "Username GitHub: " github_user
            git remote add origin "git@github.com:${github_user}/server-setup.git"
            ;;
        2)
            read -r -p "Username GitHub: " github_user
            git remote add origin "https://github.com/${github_user}/server-setup.git"
            ;;
        3)
            read -r -p "Username GitLab: " gitlab_user
            git remote add origin "https://gitlab.com/${gitlab_user}/server-setup.git"
            ;;
        4)
            read -r -p "URL do repositório: " remote_url
            git remote add origin "$remote_url"
            ;;
        *)
            echo -e "${RED}✗ Opção inválida${NC}"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}✓ Remote configurada${NC}\n"
    git remote -v
fi

echo -e "\n${BLUE}Verificando branches...${NC}"
git branch -a

echo -e "\n${BLUE}Fazendo push das branches...${NC}"

# Push main
echo -e "\n${YELLOW}→ Fazendo push de 'main'...${NC}"
git push -u origin main || echo -e "${RED}✗ Erro ao fazer push de 'main'${NC}"

# Push develop
echo -e "\n${YELLOW}→ Fazendo push de 'develop'...${NC}"
git push -u origin develop || echo -e "${RED}✗ Erro ao fazer push de 'develop'${NC}"

# Push tags (se existirem)
echo -e "\n${YELLOW}→ Fazendo push de tags...${NC}"
git push origin --tags 2>/dev/null || echo -e "${YELLOW}(Sem tags ainda)${NC}"

echo -e "\n${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    ✅ PUSH CONCLUÍDO                          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${BLUE}Próximos passos:${NC}"
echo -e "1. Ir para seu repositório remoto (GitHub/GitLab)"
echo -e "2. Configurar Branch Protection:"
echo -e "   - main: requer 2 approvals + checks"
echo -e "   - develop: requer 1 approval + checks"
echo -e "3. Ativar GitHub Actions (se GitHub)"
echo -e "4. Começar a desenvolver com git checkout -b feature/..."
echo -e "\n${GREEN}✓ Repositório remoto configurado com sucesso!${NC}"
