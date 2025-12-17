#!/usr/bin/env bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

STATE_DIR="$HOME/.config/dotfiles-installer"

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} ${GREEN}$1${NC}"
}

print_error() {
    echo -e "${RED}✗${NC} ${RED}$1${NC}"
}

list_backups() {
    echo -e "${BOLD}Available Backups:${NC}"
    echo
    
    if [[ ! -d "$STATE_DIR/backups" ]] || [[ -z "$(ls -A "$STATE_DIR/backups")" ]]; then
        print_info "No backups found"
        return 1
    fi
    
    local i=1
    for backup in "$STATE_DIR/backups"/*; do
        local date=$(basename "$backup")
        local size=$(du -sh "$backup" | cut -f1)
        echo -e "  ${BOLD}$i)${NC} $date ${BLUE}($size)${NC}"
        ((i++))
    done
    echo
}

select_backup() {
    list_backups || return 1
    
    read -p "$(echo -e ${BOLD}${YELLOW}?${NC} Select backup number to restore: )" -r selection
    
    local backup_array=("$STATE_DIR/backups"/*)
    local selected_backup="${backup_array[$((selection-1))]}"
    
    if [[ ! -d "$selected_backup" ]]; then
        print_error "Invalid selection"
        return 1
    fi
    
    echo "$selected_backup"
}

restore_backup() {
    local backup_dir="$1"
    
    echo -e "${BOLD}Restoring from: $(basename "$backup_dir")${NC}"
    echo
    
    if [[ ! -d "$backup_dir" ]]; then
        print_error "Backup directory not found"
        return 1
    fi
    
    # Find all files in backup
    local files=($(find "$backup_dir" -type f))
    local total=${#files[@]}
    local current=0
    
    for file in "${files[@]}"; do
        ((current++))
        local rel_path="${file#$backup_dir}"
        local target="$rel_path"
        
        printf "\r[%3d%%] Restoring: %-50s" $((current * 100 / total)) "$(basename "$target")"
        
        mkdir -p "$(dirname "$target")"
        cp -f "$file" "$target" 2>/dev/null || true
    done
    
    echo
    print_success "Backup restored successfully"
}

rollback_packages() {
    local rollback_file="$1"
    
    if [[ ! -f "$rollback_file" ]]; then
        print_info "No package rollback data found"
        return 0
    fi
    
    echo -e "${BOLD}Rolling back packages...${NC}"
    echo
    
    while IFS='|' read -r action package; do
        if [[ "$action" == "remove_package" ]]; then
            print_info "Removing $package..."
            sudo pacman -R --noconfirm "$package" 2>/dev/null || true
        fi
    done < <(tac "$rollback_file")
    
    print_success "Package rollback completed"
}

main() {
    echo -e "${BOLD}${BLUE}"
    cat << "EOF"
    ╔═══════════════════════════════════════════╗
    ║                                           ║
    ║     Dotfiles Rollback Manager            ║
    ║                                           ║
    ╚═══════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo "What would you like to do?"
    echo
    echo "  1) Restore configuration files from backup"
    echo "  2) Rollback installed packages"
    echo "  3) Full rollback (configs + packages)"
    echo "  4) List all backups"
    echo "  5) Exit"
    echo
    
    read -p "$(echo -e ${BOLD}${YELLOW}?${NC} Select option: )" -n 1 -r choice
    echo
    echo
    
    case $choice in
        1)
            backup_dir=$(select_backup)
            [[ -n "$backup_dir" ]] && restore_backup "$backup_dir"
            ;;
        2)
            rollback_file=$(select_backup)
            if [[ -n "$rollback_file" ]]; then
                rollback_file="$STATE_DIR/rollback-$(basename "$rollback_file").json"
                rollback_packages "$rollback_file"
            fi
            ;;
        3)
            backup_dir=$(select_backup)
            if [[ -n "$backup_dir" ]]; then
                restore_backup "$backup_dir"
                rollback_file="$STATE_DIR/rollback-$(basename "$backup_dir").json"
                rollback_packages "$rollback_file"
            fi
            ;;
        4)
            list_backups
            ;;
        5)
            exit 0
            ;;
        *)
            print_error "Invalid option"
            exit 1
            ;;
    esac
}

main "$@"
