#!/usr/bin/env bash

################################################################################
# Build and Package Script for PPA Publication
# Usage: ./build-deb.sh [options]
################################################################################

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_message() {
    local type="$1"
    shift
    case "$type" in
        info) echo -e "${BLUE}ℹ${NC} $*" ;;
        success) echo -e "${GREEN}✓${NC} $*" ;;
        warning) echo -e "${YELLOW}⚠${NC} $*" ;;
        error) echo -e "${RED}✗${NC} $*" ;;
    esac
}

# Check dependencies
check_deps() {
    print_message info "Checking build dependencies..."
    
    local required_tools=("dpkg-dev" "debhelper" "fakeroot" "bash")
    local missing=()
    
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null && ! dpkg -l | grep -q "^ii.*$tool"; then
            missing+=("$tool")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        print_message error "Missing dependencies: ${missing[*]}"
        print_message info "Install with: sudo apt-get install ${missing[*]}"
        exit 1
    fi
    
    print_message success "All dependencies satisfied"
}

# Validate bash syntax
validate_script() {
    print_message info "Validating bash script syntax..."
    
    if bash -n erp-server-setup.sh; then
        print_message success "Script validation passed"
    else
        print_message error "Script validation failed"
        exit 1
    fi
}

# Build the package
build_package() {
    print_message info "Building Debian package..."
    
    # Clean previous builds
    rm -rf debian/erp-server-setup/
    
    # Build the package
    if dpkg-buildpackage -us -uc -b; then
        print_message success "Package built successfully"
    else
        print_message error "Package build failed"
        exit 1
    fi
}

# Create source package for PPA
build_source_package() {
    print_message info "Building source package for PPA..."
    
    if dpkg-buildpackage -S -us -uc; then
        print_message success "Source package created successfully"
    else
        print_message error "Source package creation failed"
        exit 1
    fi
}

# Display help
show_help() {
    cat << EOF
Usage: ./build-deb.sh [OPTIONS]

Options:
    -b, --binary        Build binary package (.deb)
    -s, --source        Build source package for PPA
    -a, --all          Build both binary and source packages
    -c, --clean         Clean build artifacts
    -v, --validate      Only validate syntax
    -h, --help          Display this help message

Examples:
    ./build-deb.sh --binary                 # Build .deb package
    ./build-deb.sh --source                 # Build for PPA submission
    ./build-deb.sh --all                    # Build everything
    ./build-deb.sh --validate              # Check syntax only

For PPA submission:
    1. Build source package: ./build-deb.sh --source
    2. Sign the package: debsign -k<KEY_ID> *.changes
    3. Upload: dput ppa:username/ppa *.changes

EOF
}

# Main script
main() {
    local action="${1:-help}"
    
    case "$action" in
        -b|--binary)
            check_deps
            validate_script
            build_package
            ;;
        -s|--source)
            check_deps
            validate_script
            build_source_package
            ;;
        -a|--all)
            check_deps
            validate_script
            build_package
            build_source_package
            ;;
        -c|--clean)
            print_message info "Cleaning build artifacts..."
            rm -rf debian/erp-server-setup/ *.deb *.changes *.dsc *.orig.tar.* *.build
            print_message success "Cleanup complete"
            ;;
        -v|--validate)
            validate_script
            ;;
        -h|--help)
            show_help
            ;;
        *)
            print_message error "Unknown option: $action"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
