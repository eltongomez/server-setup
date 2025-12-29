#!/bin/bash

################################################################################
# Project Structure Validation
# Verifies the professional packaging structure
################################################################################

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Professional Packaging Structure Validation${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

check_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
        echo "  └─ $description"
    else
        echo -e "${YELLOW}⚠${NC} $file (missing)"
    fi
}

echo -e "${BLUE}Core Files:${NC}"
check_file "erp-server-setup.sh" "Main setup script"
check_file "package.json" "NPM metadata"
echo ""

echo -e "${BLUE}Documentation:${NC}"
check_file "README.md" "Project documentation"
check_file "CHANGELOG.md" "Version history"
check_file "CONTRIBUTING.md" "Contribution guidelines"
check_file "PACKAGING.md" "Packaging structure guide"
check_file "PPA_GUIDE.md" "PPA publication guide"
echo ""

echo -e "${BLUE}Build & Automation:${NC}"
check_file "build-deb.sh" "Debian package build script"
check_file ".ppa" "PPA configuration"
check_file ".github/workflows/build-deb.yml" "GitHub Actions CI/CD"
echo ""

echo -e "${BLUE}Debian Packaging Files (debian/):${NC}"
check_file "debian/control" "Package metadata and dependencies"
check_file "debian/rules" "Build instructions"
check_file "debian/changelog" "Debian version history"
check_file "debian/copyright" "License and copyright info"
check_file "debian/compat" "Debhelper compatibility"
check_file "debian/install" "Installation file list"
check_file "debian/postinst" "Post-installation script"
check_file "debian/preinst" "Pre-installation script"
check_file "debian/lintian-overrides" "Lintian override rules"
echo ""

echo -e "${BLUE}Configuration:${NC}"
check_file ".gitignore" "Git ignore rules (with deb artifacts)"
echo ""

echo -e "${BLUE}Quick Start:${NC}"
cat << EOF
  1. Validate bash syntax:
     bash -n erp-server-setup.sh

  2. Build binary package locally:
     chmod +x build-deb.sh
     ./build-deb.sh --binary

  3. Build source package for PPA:
     ./build-deb.sh --source

  4. Setup for PPA publication:
     - Read: PPA_GUIDE.md
     - Read: PACKAGING.md
     - Follow steps in PPA_GUIDE.md

  5. View detailed documentation:
     cat PACKAGING.md
     cat PPA_GUIDE.md
EOF

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Professional packaging structure initialized successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
