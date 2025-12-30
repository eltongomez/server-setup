#!/bin/bash

################################################################################
# Script de Configuração Automatizada de Servidores
# Versão: 1.0.1
# Descrição: Configura segurança, monitoramento e backup para servidores
# Data: Dezembro 2025
################################################################################

set -euo pipefail

# Cores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Diretórios e arquivos
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_DIR="/var/log/erp-setup"
readonly LOG_FILE="${LOG_DIR}/setup-$(date +%Y%m%d-%H%M%S).log"
readonly BACKUP_DIR="/var/backups/erp-setup"
readonly CONFIG_FILE="${SCRIPT_DIR}/erp-setup.conf"

# Variáveis globais
DISTRO=""
PACKAGE_MANAGER=""
DRY_RUN=false
INTERACTIVE=true

################################################################################
# Funções de Utilidade
################################################################################

# Função para imprimir mensagens coloridas
print_message() {
    local type="$1"
    shift
    local message="$*"
    local timestamp="[$(date '+%Y-%m-%d %H:%M:%S')]"
    
    case "$type" in
        info)
            echo -e "${BLUE}${BOLD}[INFO]${NC} ${message}" | tee -a "$LOG_FILE"
            ;;
        success)
            echo -e "${GREEN}${BOLD}[✓]${NC} ${message}" | tee -a "$LOG_FILE"
            ;;
        warning)
            echo -e "${YELLOW}${BOLD}[⚠]${NC} ${message}" | tee -a "$LOG_FILE"
            ;;
        error)
            echo -e "${RED}${BOLD}[✗]${NC} ${message}" | tee -a "$LOG_FILE"
            ;;
        header)
            echo -e "\n${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${CYAN}${BOLD}  $message${NC}"
            echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
            ;;
        *)
            echo "$message" | tee -a "$LOG_FILE"
            ;;
    esac
}

# Função para exibir banner
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    cat << "EOF"
╔════════════════════════════════════════════════════════════════════════╗
║                                                                        ║
║      ███████╗██████╗ ██████╗     ███████╗███████╗██████╗ ██╗   ██╗     ║
║      ██╔════╝██╔══██╗██╔══██╗    ██╔════╝██╔════╝██╔══██╗██║   ██║     ║
║      █████╗  ██████╔╝██████╔╝    ███████╗█████╗  ██████╔╝██║   ██║     ║
║      ██╔══╝  ██╔══██╗██╔═══╝     ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝     ║
║      ███████╗██║  ██║██║         ███████║███████╗██║  ██║ ╚████╔╝      ║
║      ╚══════╝╚═╝  ╚═╝╚═╝         ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝       ║
║                                                                        ║
║            Script de Configuração Automatizada v1.0.0                  ║
║                    Segurança • Monitoramento • Backup                  ║
║                                                                        ║
╚════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"
}

# Função para verificar se o script está rodando como root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_message error "Este script deve ser executado como root (sudo)"
        exit 1
    fi
}

# Função para detectar distribuição Linux
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO="$ID"
        
        case "$DISTRO" in
            ubuntu|debian)
                PACKAGE_MANAGER="apt"
                ;;
            centos|rhel|fedora)
                PACKAGE_MANAGER="yum"
                ;;
            *)
                print_message warning "Distribuição $DISTRO pode não ser totalmente suportada"
                PACKAGE_MANAGER="apt"
                ;;
        esac
        
        print_message info "Distribuição detectada: $DISTRO ($VERSION)"
    else
        print_message error "Não foi possível detectar a distribuição Linux"
        exit 1
    fi
}

# Função para criar diretórios necessários
setup_directories() {
    print_message info "Criando diretórios necessários..."
    
    mkdir -p "$LOG_DIR" "$BACKUP_DIR"
    chmod 750 "$LOG_DIR" "$BACKUP_DIR"
    
    print_message success "Diretórios criados com sucesso"
}

# Função para fazer backup de arquivo de configuração
backup_file() {
    local file="$1"
    
    if [[ -f "$file" ]]; then
        local backup_name="$(basename "$file").backup-$(date +%Y%m%d-%H%M%S)"
        cp -p "$file" "${BACKUP_DIR}/${backup_name}"
        print_message success "Backup criado: ${backup_name}"
    fi
}

# Função para perguntar sim/não
ask_yes_no() {
    local prompt="$1"
    local default="${2:-n}"
    local response
    
    if [[ "$default" == "y" ]]; then
        prompt="${prompt} [S/n]: "
    else
        prompt="${prompt} [s/N]: "
    fi
    
    while true; do
        read -r -p "$(echo -e "${CYAN}${prompt}${NC}")" response
        response="${response:-$default}"
        
        case "$response" in
            [Ss]|[Yy]|[Ss][Ii][Mm]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Ãã][Oo]|[Nn][Oo])
                return 1
                ;;
            *)
                echo "Por favor, responda sim ou não."
                ;;
        esac
    done
}

# Função para ler input com valor padrão
read_with_default() {
    local prompt="$1"
    local default="$2"
    local varname="$3"
    local value
    
    read -r -p "$(echo -e "${CYAN}${prompt} [${default}]: ${NC}")" value
    value="${value:-$default}"
    
    eval "$varname='$value'"
}

# Função para exibir menu
show_menu() {
    local title="$1"
    shift
    local options=("$@")
    
    echo -e "\n${BOLD}${title}${NC}\n"
    
    local i=1
    for option in "${options[@]}"; do
        echo -e "  ${BOLD}${i}.${NC} ${option}"
        ((i++))
    done
    
    echo -e "  ${BOLD}0.${NC} Voltar/Sair\n"
}

################################################################################
# Funções de Configuração - Segurança
################################################################################

configure_ssh() {
    print_message header "Configuração SSH"
    
    local ssh_port
    local disable_root
    local password_auth
    
    if ask_yes_no "Deseja configurar o SSH?" "y"; then
        backup_file "/etc/ssh/sshd_config"
        
        read_with_default "Porta SSH" "22" ssh_port
        
        if ask_yes_no "Desabilitar login root via SSH?" "y"; then
            disable_root="yes"
        else
            disable_root="no"
        fi
        
        if ask_yes_no "Desabilitar autenticação por senha (requer chave SSH)?" "n"; then
            password_auth="no"
            print_message warning "ATENÇÃO: Certifique-se de ter uma chave SSH configurada antes de continuar!"
            if ! ask_yes_no "Você tem certeza que deseja continuar?" "n"; then
                password_auth="yes"
            fi
        else
            password_auth="yes"
        fi
        
        # Aplicar configurações
        cat > /etc/ssh/sshd_config.d/erp-hardening.conf << EOF
# Configurações de segurança ERP - Gerado automaticamente
Port ${ssh_port}
PermitRootLogin ${disable_root}
PasswordAuthentication ${password_auth}
PubkeyAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding no
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
MaxAuthTries 3
LoginGraceTime 60
ClientAliveInterval 300
ClientAliveCountMax 2
EOF
        
        # Validar configuração
        if sshd -t 2>/dev/null; then
            # Tentar reiniciar SSH (compatível com diferentes ambientes)
            if systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null; then
                print_message success "SSH configurado com sucesso na porta ${ssh_port}"
            else
                # Em alguns ambientes (WSL2, containers), o serviço pode não estar disponível
                print_message warning "SSH configurado, mas não foi possível reiniciar o serviço (pode estar desabilitado)"
                print_message info "Reinicie manualmente ou aguarde o próximo boot: sudo systemctl restart ssh"
            fi
        else
            print_message error "Erro na configuração SSH. Restaurando backup..."
            cp "${BACKUP_DIR}/sshd_config.backup-"* /etc/ssh/sshd_config 2>/dev/null || true
            return 1
        fi
    fi
}

configure_firewall() {
    print_message header "Configuração de Firewall"
    
    if ask_yes_no "Deseja configurar o firewall (UFW)?" "y"; then
        # Instalar UFW se necessário
        if ! command -v ufw &> /dev/null; then
            print_message info "Instalando UFW..."
            $PACKAGE_MANAGER install -y ufw
        fi
        
        # Configurar regras básicas
        print_message info "Configurando regras de firewall..."
        
        ufw --force reset
        ufw default deny incoming
        ufw default allow outgoing
        
        # SSH
        local ssh_port
        read_with_default "Porta SSH para liberar" "22" ssh_port
        ufw allow "$ssh_port"/tcp comment 'SSH'
        
        # HTTP/HTTPS
        if ask_yes_no "Liberar portas HTTP (80) e HTTPS (443)?" "y"; then
            ufw allow 80/tcp comment 'HTTP'
            ufw allow 443/tcp comment 'HTTPS'
        fi
        
        # Portas customizadas
        if ask_yes_no "Deseja adicionar portas customizadas?" "n"; then
            while true; do
                local custom_port
                read -r -p "$(echo -e "${CYAN}Digite a porta (ou 'fim' para terminar): ${NC}")" custom_port
                
                if [[ "$custom_port" == "fim" ]]; then
                    break
                fi
                
                if [[ "$custom_port" =~ ^[0-9]+$ ]] && [ "$custom_port" -ge 1 ] && [ "$custom_port" -le 65535 ]; then
                    local protocol
                    read_with_default "Protocolo (tcp/udp)" "tcp" protocol
                    ufw allow "$custom_port"/"$protocol"
                    print_message success "Porta $custom_port/$protocol adicionada"
                else
                    print_message error "Porta inválida"
                fi
            done
        fi
        
        # Ativar firewall
        ufw --force enable
        print_message success "Firewall configurado e ativado"
        
        echo -e "\n${BOLD}Status do Firewall:${NC}"
        ufw status verbose
    fi
}

configure_fail2ban() {
    print_message header "Configuração Fail2Ban"
    
    if ask_yes_no "Deseja instalar e configurar Fail2Ban?" "y"; then
        # Instalar Fail2Ban
        if ! command -v fail2ban-client &> /dev/null; then
            print_message info "Instalando Fail2Ban..."
            $PACKAGE_MANAGER install -y fail2ban
        fi
        
        backup_file "/etc/fail2ban/jail.local"
        
        local bantime
        local maxretry
        
        read_with_default "Tempo de banimento em segundos" "3600" bantime
        read_with_default "Número máximo de tentativas" "5" maxretry
        
        cat > /etc/fail2ban/jail.local << EOF
[DEFAULT]
bantime = ${bantime}
findtime = 600
maxretry = ${maxretry}
destemail = root@localhost
sendername = Fail2Ban
action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s

[sshd-ddos]
enabled = true
port = ssh
logpath = %(sshd_log)s
EOF
        
        systemctl enable fail2ban
        systemctl restart fail2ban
        
        print_message success "Fail2Ban configurado com sucesso"
        print_message info "Banimento: ${bantime}s após ${maxretry} tentativas"
    fi
}

configure_password_policy() {
    print_message header "Política de Senhas"
    
    if ask_yes_no "Deseja configurar política de senhas?" "y"; then
        # Instalar libpam-pwquality
        if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
            $PACKAGE_MANAGER install -y libpam-pwquality
        else
            $PACKAGE_MANAGER install -y libpwquality
        fi
        
        backup_file "/etc/security/pwquality.conf"
        
        local minlen
        local minclass
        local maxrepeat
        
        read_with_default "Comprimento mínimo da senha" "12" minlen
        read_with_default "Número mínimo de classes de caracteres (maiúsculas, minúsculas, dígitos, especiais)" "3" minclass
        read_with_default "Número máximo de caracteres repetidos consecutivos" "3" maxrepeat
        
        cat > /etc/security/pwquality.conf << EOF
# Política de senhas ERP - Gerado automaticamente
minlen = ${minlen}
minclass = ${minclass}
maxrepeat = ${maxrepeat}
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
EOF
        
        # Configurar expiração de senhas
        if ask_yes_no "Configurar expiração de senhas?" "y"; then
            backup_file "/etc/login.defs"
            
            local pass_max_days
            local pass_min_days
            local pass_warn_age
            
            read_with_default "Dias máximos de validade da senha" "90" pass_max_days
            read_with_default "Dias mínimos entre mudanças de senha" "7" pass_min_days
            read_with_default "Dias de aviso antes da expiração" "14" pass_warn_age
            
            sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t${pass_max_days}/" /etc/login.defs
            sed -i "s/^PASS_MIN_DAYS.*/PASS_MIN_DAYS\t${pass_min_days}/" /etc/login.defs
            sed -i "s/^PASS_WARN_AGE.*/PASS_WARN_AGE\t${pass_warn_age}/" /etc/login.defs
            
            print_message success "Expiração de senhas configurada"
        fi
        
        print_message success "Política de senhas configurada com sucesso"
    fi
}

configure_automatic_updates() {
    print_message header "Atualizações Automáticas"
    
    if ask_yes_no "Deseja configurar atualizações automáticas de segurança?" "y"; then
        if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
            $PACKAGE_MANAGER install -y unattended-upgrades apt-listchanges
            
            backup_file "/etc/apt/apt.conf.d/50unattended-upgrades"
            
            cat > /etc/apt/apt.conf.d/50unattended-upgrades << 'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
    "${distro_id}ESMApps:${distro_codename}-apps-security";
    "${distro_id}ESM:${distro_codename}-infra-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
EOF
            
            cat > /etc/apt/apt.conf.d/20auto-upgrades << EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF
            
            print_message success "Atualizações automáticas de segurança configuradas"
        else
            $PACKAGE_MANAGER install -y yum-cron
            
            sed -i 's/apply_updates = no/apply_updates = yes/' /etc/yum/yum-cron.conf
            systemctl enable yum-cron
            systemctl start yum-cron
            
            print_message success "Yum-cron configurado para atualizações automáticas"
        fi
    fi
}

################################################################################
# Funções de Configuração - Monitoramento
################################################################################

install_monitoring_tools() {
    print_message header "Instalação de Ferramentas de Monitoramento"
    
    if ask_yes_no "Deseja instalar ferramentas básicas de monitoramento?" "y"; then
        print_message info "Instalando ferramentas de monitoramento..."
        
        local tools="htop iotop nethogs ncdu sysstat"
        
        $PACKAGE_MANAGER install -y $tools
        
        # Habilitar coleta de estatísticas
        if [[ -f /etc/default/sysstat ]]; then
            sed -i 's/ENABLED="false"/ENABLED="true"/' /etc/default/sysstat
            systemctl enable sysstat
            systemctl start sysstat
        fi
        
        print_message success "Ferramentas de monitoramento instaladas:"
        echo "  • htop - Monitor de processos interativo"
        echo "  • iotop - Monitor de I/O de disco"
        echo "  • nethogs - Monitor de uso de rede por processo"
        echo "  • ncdu - Analisador de uso de disco"
        echo "  • sysstat - Coleta de estatísticas do sistema"
    fi
}

configure_logrotate() {
    print_message header "Configuração de Rotação de Logs"
    
    if ask_yes_no "Deseja configurar rotação de logs?" "y"; then
        local rotate_days
        local compress
        
        read_with_default "Manter logs por quantos dias?" "30" rotate_days
        
        if ask_yes_no "Comprimir logs antigos?" "y"; then
            compress="compress"
        else
            compress="nocompress"
        fi
        
        cat > /etc/logrotate.d/erp-custom << EOF
# Rotação de logs ERP - Gerado automaticamente
/var/log/erp/*.log {
    daily
    rotate ${rotate_days}
    missingok
    notifempty
    ${compress}
    delaycompress
    sharedscripts
    postrotate
        systemctl reload rsyslog > /dev/null 2>&1 || true
    endscript
}
EOF
        
        print_message success "Rotação de logs configurada (${rotate_days} dias)"
    fi
}

################################################################################
# Funções de Configuração - Backup
################################################################################

configure_backup_script() {
    print_message header "Configuração de Script de Backup"
    
    if ask_yes_no "Deseja criar um script de backup automatizado?" "y"; then
        local backup_dir
        local backup_retention
        local backup_schedule
        
        read_with_default "Diretório de destino dos backups" "/backup/erp" backup_dir
        read_with_default "Dias de retenção dos backups" "30" backup_retention
        
        mkdir -p "$backup_dir"
        
        # Criar script de backup
        cat > /usr/local/bin/erp-backup.sh << 'BACKUP_SCRIPT'
#!/bin/bash
# Script de Backup ERP - Gerado automaticamente

set -euo pipefail

BACKUP_DIR="__BACKUP_DIR__"
RETENTION_DAYS=__RETENTION_DAYS__
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="erp-backup-${TIMESTAMP}"
LOG_FILE="/var/log/erp-backup.log"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log_message "Iniciando backup: ${BACKUP_NAME}"

# Criar diretório de backup
mkdir -p "${BACKUP_DIR}/${BACKUP_NAME}"

# Backup de configurações do sistema
log_message "Backup de configurações do sistema..."
tar -czf "${BACKUP_DIR}/${BACKUP_NAME}/system-config.tar.gz" \
    /etc/ssh \
    /etc/security \
    /etc/fail2ban \
    /etc/ufw 2>/dev/null || true

# Backup de dados da aplicação (ajuste conforme necessário)
if [ -d "/opt/erp/data" ]; then
    log_message "Backup de dados da aplicação..."
    tar -czf "${BACKUP_DIR}/${BACKUP_NAME}/app-data.tar.gz" /opt/erp/data
fi

# Backup de banco de dados (exemplo para PostgreSQL)
if command -v pg_dumpall &> /dev/null; then
    log_message "Backup de banco de dados PostgreSQL..."
    sudo -u postgres pg_dumpall | gzip > "${BACKUP_DIR}/${BACKUP_NAME}/database.sql.gz"
fi

# Criar checksum
cd "${BACKUP_DIR}/${BACKUP_NAME}"
sha256sum * > checksums.txt

# Remover backups antigos
log_message "Removendo backups com mais de ${RETENTION_DAYS} dias..."
find "${BACKUP_DIR}" -maxdepth 1 -type d -name "erp-backup-*" -mtime +${RETENTION_DAYS} -exec rm -rf {} \;

log_message "Backup concluído com sucesso: ${BACKUP_NAME}"
log_message "Localização: ${BACKUP_DIR}/${BACKUP_NAME}"

# Estatísticas
BACKUP_SIZE=$(du -sh "${BACKUP_DIR}/${BACKUP_NAME}" | cut -f1)
log_message "Tamanho do backup: ${BACKUP_SIZE}"

exit 0
BACKUP_SCRIPT
        
        # Substituir variáveis
        sed -i "s|__BACKUP_DIR__|${backup_dir}|g" /usr/local/bin/erp-backup.sh
        sed -i "s|__RETENTION_DAYS__|${backup_retention}|g" /usr/local/bin/erp-backup.sh
        
        chmod +x /usr/local/bin/erp-backup.sh
        
        print_message success "Script de backup criado: /usr/local/bin/erp-backup.sh"
        
        # Configurar agendamento
        if ask_yes_no "Deseja agendar backups automáticos?" "y"; then
            show_menu "Frequência de Backup" \
                "Diário (03:00)" \
                "Semanal (Domingo 03:00)" \
                "Personalizado"
            
            read -r -p "Escolha uma opção: " backup_schedule
            
            case "$backup_schedule" in
                1)
                    cron_schedule="0 3 * * *"
                    ;;
                2)
                    cron_schedule="0 3 * * 0"
                    ;;
                3)
                    read -r -p "Digite a expressão cron (ex: 0 3 * * *): " cron_schedule
                    ;;
                *)
                    print_message warning "Opção inválida, usando padrão diário"
                    cron_schedule="0 3 * * *"
                    ;;
            esac
            
            # Adicionar ao crontab
            (crontab -l 2>/dev/null | grep -v erp-backup.sh; echo "${cron_schedule} /usr/local/bin/erp-backup.sh") | crontab -
            
            print_message success "Backup agendado com sucesso"
            print_message info "Agendamento: ${cron_schedule}"
        fi
        
        # Testar backup
        if ask_yes_no "Deseja executar um backup de teste agora?" "n"; then
            print_message info "Executando backup de teste..."
            /usr/local/bin/erp-backup.sh
        fi
    fi
}

################################################################################
# Funções de Configuração - Sistema
################################################################################

configure_sysctl() {
    print_message header "Hardening do Kernel"
    
    if ask_yes_no "Deseja aplicar configurações de hardening do kernel?" "y"; then
        backup_file "/etc/sysctl.conf"
        
        cat > /etc/sysctl.d/99-erp-hardening.conf << 'EOF'
# Hardening do Kernel - Gerado automaticamente

# Proteção contra IP spoofing
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Desabilitar roteamento de pacotes IP
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0

# Desabilitar source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Ignorar broadcasts ICMP
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Ignorar mensagens ICMP malformadas
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Logar pacotes suspeitos
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# Proteção SYN flood
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5

# Desabilitar ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Randomização de espaço de endereços
kernel.randomize_va_space = 2

# Restrição de acesso a dmesg
kernel.dmesg_restrict = 1

# Restrição de acesso a kernel pointers
kernel.kptr_restrict = 2
EOF
        
        # Aplicar configurações
        sysctl -p /etc/sysctl.d/99-erp-hardening.conf
        
        print_message success "Hardening do kernel aplicado com sucesso"
    fi
}

disable_unnecessary_services() {
    print_message header "Desabilitar Serviços Desnecessários"
    
    if ask_yes_no "Deseja desabilitar serviços desnecessários?" "y"; then
        local services_to_disable=(
            "avahi-daemon"
            "cups"
            "bluetooth"
            "iscsid"
        )
        
        print_message info "Verificando serviços..."
        
        for service in "${services_to_disable[@]}"; do
            if systemctl is-enabled "$service" &>/dev/null; then
                if ask_yes_no "Desabilitar ${service}?" "y"; then
                    systemctl stop "$service" 2>/dev/null || true
                    systemctl disable "$service" 2>/dev/null || true
                    print_message success "${service} desabilitado"
                fi
            fi
        done
    fi
}

################################################################################
# Menu Principal
################################################################################

main_menu() {
    while true; do
        show_menu "MENU PRINCIPAL - Configuração do Servidor" \
            "Configuração Completa (Recomendado)" \
            "Segurança" \
            "Monitoramento" \
            "Backup" \
            "Sistema" \
            "Gerar Relatório" \
            "Sair"
        
        read -r -p "Escolha uma opção: " choice
        
        case "$choice" in
            1)
                full_configuration
                ;;
            2)
                security_menu
                ;;
            3)
                monitoring_menu
                ;;
            4)
                backup_menu
                ;;
            5)
                system_menu
                ;;
            6)
                generate_report
                ;;
            0|7)
                print_message info "Encerrando script..."
                exit 0
                ;;
            *)
                print_message error "Opção inválida"
                ;;
        esac
        
        echo -e "\n${BOLD}Pressione ENTER para continuar...${NC}"
        read -r
    done
}

security_menu() {
    while true; do
        show_menu "MENU DE SEGURANÇA" \
            "Configurar SSH" \
            "Configurar Firewall (UFW)" \
            "Configurar Fail2Ban" \
            "Política de Senhas" \
            "Atualizações Automáticas" \
            "Hardening do Kernel" \
            "Voltar"
        
        read -r -p "Escolha uma opção: " choice
        
        case "$choice" in
            1) configure_ssh ;;
            2) configure_firewall ;;
            3) configure_fail2ban ;;
            4) configure_password_policy ;;
            5) configure_automatic_updates ;;
            6) configure_sysctl ;;
            0|7) return ;;
            *) print_message error "Opção inválida" ;;
        esac
    done
}

monitoring_menu() {
    while true; do
        show_menu "MENU DE MONITORAMENTO" \
            "Instalar Ferramentas de Monitoramento" \
            "Configurar Rotação de Logs" \
            "Voltar"
        
        read -r -p "Escolha uma opção: " choice
        
        case "$choice" in
            1) install_monitoring_tools ;;
            2) configure_logrotate ;;
            0|3) return ;;
            *) print_message error "Opção inválida" ;;
        esac
    done
}

backup_menu() {
    while true; do
        show_menu "MENU DE BACKUP" \
            "Configurar Script de Backup" \
            "Executar Backup Manual" \
            "Voltar"
        
        read -r -p "Escolha uma opção: " choice
        
        case "$choice" in
            1) configure_backup_script ;;
            2)
                if [[ -x /usr/local/bin/erp-backup.sh ]]; then
                    /usr/local/bin/erp-backup.sh
                else
                    print_message error "Script de backup não encontrado. Configure primeiro."
                fi
                ;;
            0|3) return ;;
            *) print_message error "Opção inválida" ;;
        esac
    done
}

system_menu() {
    while true; do
        show_menu "MENU DE SISTEMA" \
            "Desabilitar Serviços Desnecessários" \
            "Atualizar Sistema" \
            "Voltar"
        
        read -r -p "Escolha uma opção: " choice
        
        case "$choice" in
            1) disable_unnecessary_services ;;
            2)
                print_message info "Atualizando sistema..."
                $PACKAGE_MANAGER update -y
                $PACKAGE_MANAGER upgrade -y
                print_message success "Sistema atualizado"
                ;;
            0|3) return ;;
            *) print_message error "Opção inválida" ;;
        esac
    done
}

full_configuration() {
    print_message header "CONFIGURAÇÃO COMPLETA DO SERVIDOR"
    
    print_message info "Esta opção irá configurar:"
    echo "  • SSH seguro"
    echo "  • Firewall (UFW)"
    echo "  • Fail2Ban"
    echo "  • Política de senhas"
    echo "  • Atualizações automáticas"
    echo "  • Hardening do kernel"
    echo "  • Ferramentas de monitoramento"
    echo "  • Rotação de logs"
    echo "  • Script de backup"
    echo ""
    
    if ask_yes_no "Deseja continuar com a configuração completa?" "y"; then
        configure_ssh
        configure_firewall
        configure_fail2ban
        configure_password_policy
        configure_automatic_updates
        configure_sysctl
        install_monitoring_tools
        configure_logrotate
        configure_backup_script
        disable_unnecessary_services
        
        print_message success "Configuração completa finalizada!"
        generate_report
    fi
}

generate_report() {
    print_message header "RELATÓRIO DE CONFIGURAÇÃO"
    
    local report_file="${LOG_DIR}/config-report-$(date +%Y%m%d-%H%M%S).txt"
    
    {
        echo "=========================================="
        echo "RELATÓRIO DE CONFIGURAÇÃO DO SERVIDOR ERP"
        echo "Data: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Hostname: $(hostname)"
        echo "=========================================="
        echo ""
        
        echo "SISTEMA:"
        echo "  Distribuição: $DISTRO"
        echo "  Kernel: $(uname -r)"
        echo "  Uptime: $(uptime -p)"
        echo ""
        
        echo "SEGURANÇA:"
        if systemctl is-active --quiet ufw; then
            echo "  ✓ Firewall (UFW): Ativo"
        else
            echo "  ✗ Firewall (UFW): Inativo"
        fi
        
        if systemctl is-active --quiet fail2ban; then
            echo "  ✓ Fail2Ban: Ativo"
        else
            echo "  ✗ Fail2Ban: Inativo"
        fi
        
        if systemctl is-active --quiet ssh || systemctl is-active --quiet sshd; then
            echo "  ✓ SSH: Ativo"
        else
            echo "  ✗ SSH: Inativo"
        fi
        echo ""
        
        echo "MONITORAMENTO:"
        for tool in htop iotop nethogs sysstat; do
            if command -v "$tool" &> /dev/null; then
                echo "  ✓ $tool: Instalado"
            else
                echo "  ✗ $tool: Não instalado"
            fi
        done
        echo ""
        
        echo "BACKUP:"
        if [[ -x /usr/local/bin/erp-backup.sh ]]; then
            echo "  ✓ Script de backup: Configurado"
            if crontab -l 2>/dev/null | grep -q erp-backup.sh; then
                echo "  ✓ Agendamento: Configurado"
            else
                echo "  ✗ Agendamento: Não configurado"
            fi
        else
            echo "  ✗ Script de backup: Não configurado"
        fi
        echo ""
        
        echo "LOGS:"
        echo "  Diretório de logs: $LOG_DIR"
        echo "  Arquivo de log: $LOG_FILE"
        echo ""
        
    } | tee "$report_file"
    
    print_message success "Relatório salvo em: $report_file"
}

################################################################################
# Função Principal
################################################################################

main() {
    # Verificar se está rodando como root
    check_root
    
    # Criar diretório de logs IMEDIATAMENTE (antes de qualquer output de log)
    mkdir -p "$LOG_DIR" "$BACKUP_DIR" 2>/dev/null || true
    chmod 750 "$LOG_DIR" "$BACKUP_DIR" 2>/dev/null || true
    
    # Mostrar banner
    show_banner
    
    # Setup inicial
    detect_distro
    setup_directories
    
    print_message info "Iniciando configuração do servidor ..."
    print_message info "Log: $LOG_FILE"
    
    # Menu principal
    main_menu
}

# Executar script
main "$@"
