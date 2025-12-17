#!/usr/bin/env bash

set -e

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
STATE_DIR="$HOME/.config/dotfiles-installer"
BACKUP_DIR="$STATE_DIR/backups/$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$STATE_DIR/install-$(date +%Y%m%d-%H%M%S).log"
STATE_FILE="$STATE_DIR/state.json"
ROLLBACK_FILE="$STATE_DIR/rollback-$(date +%Y%m%d-%H%M%S).json"

# Create necessary directories
mkdir -p "$STATE_DIR/backups"
mkdir -p "$BACKUP_DIR"

# Initialize state
declare -A COMPLETED_STEPS
declare -A INSTALLED_PACKAGES
declare -a ROLLBACK_ACTIONS

# Load previous state if exists
load_state() {
    if [[ -f "$STATE_FILE" ]]; then
        while IFS='=' read -r key value; do
            COMPLETED_STEPS["$key"]="$value"
        done < <(jq -r 'to_entries | .[] | "\(.key)=\(.value)"' "$STATE_FILE" 2>/dev/null || true)
    fi
}

# Save state
save_state() {
    local step="$1"
    COMPLETED_STEPS["$step"]="true"
    
    # Convert associative array to JSON
    printf '%s\n' "${!COMPLETED_STEPS[@]}" | jq -R -s -c 'split("\n")[:-1] | map({(.): true}) | add' > "$STATE_FILE"
}

# Check if step is completed
is_completed() {
    [[ "${COMPLETED_STEPS[$1]}" == "true" ]]
}

# Add rollback action
add_rollback() {
    local action="$1"
    ROLLBACK_ACTIONS+=("$action")
    echo "$action" >> "$ROLLBACK_FILE"
}

# Spinner animation
spinner() {
    local pid=$1
    local message=$2
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local temp
    
    tput civis # Hide cursor
    while kill -0 $pid 2>/dev/null; do
        temp=${spinstr#?}
        printf " ${CYAN}%c${NC}  %s" "$spinstr" "$message"
        spinstr=$temp${spinstr%"$temp"}
        sleep 0.1
        printf "\r"
    done
    tput cnorm # Show cursor
    printf "\r"
}

# Progress bar
progress_bar() {
    local current=$1
    local total=$2
    local message=$3
    local width=40
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    printf "\r${BOLD}${BLUE}["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "]${NC} ${CYAN}%3d%%${NC} ${message}                    " $percentage
    
    if [[ $current -eq $total ]]; then
        echo
    fi
}

# Print functions
print_header() {
    echo
    echo -e "${BOLD}${MAGENTA}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
    echo -e "${BOLD}${CYAN}$1${NC}"
    echo -e "${BOLD}${MAGENTA}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
    echo
}

print_step() {
    echo -e "\n${BOLD}${BLUE}➜${NC} ${BOLD}$1${NC}"
}

print_substep() {
    echo -e "  ${DIM}${BLUE}•${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1" | tee -a "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}✓${NC} ${GREEN}$1${NC}" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} ${YELLOW}$1${NC}" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}✗${NC} ${RED}$1${NC}" | tee -a "$LOG_FILE"
}

print_skip() {
    echo -e "${DIM}${CYAN}↷${NC} ${DIM}$1 (already completed)${NC}"
}

# Confirmation prompt
ask_confirm() {
    local prompt="$1"
    local default="${2:-y}"
    
    if [[ "$default" == "y" ]]; then
        prompt="${BOLD}${YELLOW}?${NC} $prompt ${DIM}[Y/n]${NC}: "
    else
        prompt="${BOLD}${YELLOW}?${NC} $prompt ${DIM}[y/N]${NC}: "
    fi
    
    read -p "$(echo -e $prompt)" -n 1 -r
    echo
    
    if [[ "$default" == "y" ]]; then
        [[ ! $REPLY =~ ^[Nn]$ ]]
    else
        [[ $REPLY =~ ^[Yy]$ ]]
    fi
}

# Backup file or directory
backup_path() {
    local path="$1"
    if [[ -e "$path" ]]; then
        local backup_target="$BACKUP_DIR${path}"
        mkdir -p "$(dirname "$backup_target")"
        cp -r "$path" "$backup_target"
        add_rollback "restore|$path|$backup_target"
        print_substep "Backed up: $path"
    fi
}

# Execute with rollback support
execute_with_rollback() {
    local command="$1"
    local rollback_command="$2"
    local description="$3"
    
    if eval "$command" >> "$LOG_FILE" 2>&1; then
        [[ -n "$rollback_command" ]] && add_rollback "$rollback_command"
        return 0
    else
        print_error "Failed: $description"
        return 1
    fi
}

# Rollback function
perform_rollback() {
    print_header "PERFORMING ROLLBACK"
    
    if [[ ! -f "$ROLLBACK_FILE" ]]; then
        print_warning "No rollback file found"
        return 0
    fi
    
    local total_actions=$(wc -l < "$ROLLBACK_FILE")
    local current=0
    
    # Read rollback actions in reverse order
    while IFS= read -r action; do
        ((current++))
        progress_bar $current $total_actions "Rolling back..."
        
        IFS='|' read -ra parts <<< "$action"
        case "${parts[0]}" in
            restore)
                cp -r "${parts[2]}" "${parts[1]}" 2>> "$LOG_FILE" || true
                ;;
            remove_package)
                sudo pacman -R --noconfirm "${parts[1]}" >> "$LOG_FILE" 2>&1 || true
                ;;
            disable_service)
                sudo systemctl disable "${parts[1]}" >> "$LOG_FILE" 2>&1 || true
                ;;
        esac
    done < <(tac "$ROLLBACK_FILE")
    
    print_success "Rollback completed"
}

# Trap errors
trap_error() {
    print_error "Installation failed at line $1"
    if ask_confirm "Do you want to rollback changes?"; then
        perform_rollback
    fi
    exit 1
}

trap 'trap_error $LINENO' ERR

# Check prerequisites
check_prerequisites() {
    local step_name="prerequisites"
    
    if is_completed "$step_name"; then
        print_skip "Prerequisites check"
        return 0
    fi
    
    print_step "Checking Prerequisites"
    
    # Check pacman
    print_substep "Checking for pacman..."
    if ! command -v pacman &> /dev/null; then
        print_error "This script requires an Arch-based system with pacman"
        exit 1
    fi
    print_success "Found pacman"
    
    # Check internet
    print_substep "Checking internet connection..."
    (
        ping -c 1 archlinux.org &> /dev/null &
        spinner $! "Testing connection to archlinux.org"
        wait $!
    )
    print_success "Internet connection active"
    
    save_state "$step_name"
    print_success "Prerequisites check completed"
}

# Install yay
install_yay() {
    local step_name="yay"
    
    if command -v yay &> /dev/null; then
        print_skip "yay installation"
        save_state "$step_name"
        return 0
    fi
    
    if is_completed "$step_name"; then
        print_skip "yay installation"
        return 0
    fi
    
    print_step "Installing yay AUR Helper"
    
    print_substep "Installing base-devel and git..."
    sudo pacman -S --needed --noconfirm git base-devel >> "$LOG_FILE" 2>&1
    
    print_substep "Cloning yay repository..."
    (
        cd /tmp
        rm -rf yay
        git clone https://aur.archlinux.org/yay.git >> "$LOG_FILE" 2>&1 &
        spinner $! "Cloning yay from AUR"
        wait $!
    )
    
    print_substep "Building and installing yay..."
    (
        cd /tmp/yay
        makepkg -si --noconfirm >> "$LOG_FILE" 2>&1 &
        spinner $! "Building yay (this may take a moment)"
        wait $!
    )
    
    save_state "$step_name"
    print_success "yay installed successfully"
}

# Update system
update_system() {
    local step_name="system_update"
    
    if is_completed "$step_name"; then
        if ! ask_confirm "System already updated. Update again?"; then
            return 0
        fi
    fi
    
    if ! ask_confirm "Update system packages first?"; then
        return 0
    fi
    
    print_step "Updating System"
    
    (
        sudo pacman -Syu --noconfirm >> "$LOG_FILE" 2>&1 &
        spinner $! "Updating system packages"
        wait $!
    )
    
    save_state "$step_name"
    print_success "System updated"
}

# Install packages
install_packages() {
    local step_name="packages"
    
    print_step "Installing Packages"
    
    source "$SCRIPT_DIR/packages.sh"
    
    # Install official packages
    local total=${#OFFICIAL_PACKAGES[@]}
    local current=0
    
    echo
    print_substep "Installing official repository packages..."
    for pkg in "${OFFICIAL_PACKAGES[@]}"; do
        ((current++))
        
        if pacman -Qi "$pkg" &> /dev/null; then
            progress_bar $current $total "Already installed: $pkg"
        else
            progress_bar $current $total "Installing: $pkg"
            if sudo pacman -S --needed --noconfirm "$pkg" >> "$LOG_FILE" 2>&1; then
                add_rollback "remove_package|$pkg"
                INSTALLED_PACKAGES["$pkg"]="official"
            else
                print_warning "Failed to install $pkg"
            fi
        fi
    done
    
    # Install AUR packages
    total=${#AUR_PACKAGES[@]}
    current=0
    
    echo
    print_substep "Installing AUR packages..."
    for pkg in "${AUR_PACKAGES[@]}"; do
        ((current++))
        
        if pacman -Qi "$pkg" &> /dev/null; then
            progress_bar $current $total "Already installed: $pkg"
        else
            progress_bar $current $total "Installing: $pkg"
            if yay -S --needed --noconfirm "$pkg" >> "$LOG_FILE" 2>&1; then
                add_rollback "remove_package|$pkg"
                INSTALLED_PACKAGES["$pkg"]="aur"
            else
                print_warning "Failed to install $pkg"
            fi
        fi
    done
    
    save_state "$step_name"
    print_success "Package installation completed"
}

# Deploy dotfiles
deploy_dotfiles() {
    local step_name="dotfiles"
    
    print_step "Deploying Dotfiles"
    
    cd "$DOTFILES_DIR"
    
    # Backup existing .config directories
    print_substep "Backing up existing configurations..."
    if [[ -d "$HOME/.config" ]]; then
        # Find all config subdirectories that will be stowed
        if [[ -d "$DOTFILES_DIR/.config" ]]; then
            local config_dirs=($(find "$DOTFILES_DIR/.config" -mindepth 1 -maxdepth 1 -type d -printf '%f\n'))
            local total=${#config_dirs[@]}
            local current=0
            
            echo
            for dir in "${config_dirs[@]}"; do
                ((current++))
                progress_bar $current $total "Checking: $dir"
                
                if [[ -e "$HOME/.config/$dir" ]]; then
                    backup_path "$HOME/.config/$dir"
                fi
            done
        fi
    fi
    
    # Backup root-level dotfiles (if any exist in dotfiles repo)
    print_substep "Checking for root-level dotfiles..."
    local root_files=($(find "$DOTFILES_DIR" -maxdepth 1 -name '.*' -not -name '.git' -not -name '.gitignore' -not -name '.' -not -name '..' -type f -printf '%f\n'))
    
    if [[ ${#root_files[@]} -gt 0 ]]; then
        echo
        local total=${#root_files[@]}
        local current=0
        
        for file in "${root_files[@]}"; do
            ((current++))
            progress_bar $current $total "Checking: $file"
            
            if [[ -e "$HOME/$file" ]]; then
                backup_path "$HOME/$file"
            fi
        done
    fi
    
    # Stow dotfiles
    print_substep "Deploying dotfiles with GNU Stow..."
    echo
    
    # Try to stow everything
    if stow -v -t "$HOME" --ignore='scripts' --ignore='README.md' --ignore='.git' . >> "$LOG_FILE" 2>&1; then
        add_rollback "unstow|.|$DOTFILES_DIR"
        progress_bar 1 1 "Successfully stowed all dotfiles"
        print_success "Dotfiles deployed successfully"
    else
        print_warning "Conflicts detected during stow"
        echo
        
        # Show conflicting files
        print_info "Checking for conflicts..."
        local conflicts=$(stow -n -v -t "$HOME" --ignore='scripts' --ignore='README.md' --ignore='.git' . 2>&1 | grep -i "existing" || true)
        
        if [[ -n "$conflicts" ]]; then
            echo -e "${DIM}Conflicting files:${NC}"
            echo "$conflicts" | head -10
            [[ $(echo "$conflicts" | wc -l) -gt 10 ]] && echo -e "${DIM}... and more${NC}"
            echo
        fi
        
        if ask_confirm "Adopt existing files into dotfiles? (This will overwrite repo files with your current configs)"; then
            print_substep "Adopting existing configurations..."
            
            if stow -v -t "$HOME" --adopt --ignore='scripts' --ignore='README.md' --ignore='.git' . >> "$LOG_FILE" 2>&1; then
                add_rollback "unstow|.|$DOTFILES_DIR"
                print_success "Dotfiles adopted and deployed"
                echo
                print_warning "Your dotfiles repo now contains your existing configs"
                print_info "Review changes with: cd $DOTFILES_DIR && git diff"
                print_info "To restore repo versions: cd $DOTFILES_DIR && git checkout ."
            else
                print_error "Failed to adopt dotfiles"
                return 1
            fi
        else
            print_info "Skipping dotfiles deployment due to conflicts"
            print_info "You can manually resolve conflicts and run again"
            return 1
        fi
    fi
    
    # Verify deployment
    print_substep "Verifying deployment..."
    local verified=0
    local failed=0
    
    if [[ -d "$DOTFILES_DIR/.config" ]]; then
        local config_dirs=($(find "$DOTFILES_DIR/.config" -mindepth 1 -maxdepth 1 -type d -printf '%f\n'))
        
        for dir in "${config_dirs[@]}"; do
            if [[ -L "$HOME/.config/$dir" ]] || [[ -e "$HOME/.config/$dir" ]]; then
                ((verified++))
            else
                ((failed++))
                print_warning "Not deployed: $dir"
            fi
        done
    fi
    
    echo
    print_success "Verified: $verified configurations"
    [[ $failed -gt 0 ]] && print_warning "Failed: $failed configurations"
    
    save_state "$step_name"
    print_success "Dotfiles deployment completed"
}

# Enable services
enable_services() {
    local step_name="services"
    
    if is_completed "$step_name"; then
        print_skip "Service enablement"
        return 0
    fi
    
    print_step "Enabling System Services"
    
    local services=(
        "bluetooth.service"
        "docker.service"
        "sddm.service"
    )
    
    local total=${#services[@]}
    local current=0
    
    echo
    for service in "${services[@]}"; do
        ((current++))
        
        if systemctl is-enabled "$service" &> /dev/null; then
            progress_bar $current $total "Already enabled: $service"
        else
            progress_bar $current $total "Enabling: $service"
            if sudo systemctl enable "$service" >> "$LOG_FILE" 2>&1; then
                add_rollback "disable_service|$service"
            else
                print_warning "Failed to enable $service"
            fi
        fi
    done
    
    save_state "$step_name"
    print_success "Services enabled"
}

# Configure shell
configure_shell() {
    local step_name="shell"
    
    if is_completed "$step_name"; then
        if ! ask_confirm "Shell already configured. Reconfigure?"; then
            return 0
        fi
    fi
    
    if ! ask_confirm "Set fish as default shell?"; then
        return 0
    fi
    
    print_step "Configuring Shell"
    
    local current_shell=$(getent passwd $USER | cut -d: -f7)
    backup_path "/etc/passwd"
    
    print_substep "Changing default shell to fish..."
    chsh -s /usr/bin/fish
    
    save_state "$step_name"
    print_success "Default shell changed to fish"
}

# Configure Docker
configure_docker() {
    local step_name="docker"
    
    if is_completed "$step_name"; then
        print_skip "Docker configuration"
        return 0
    fi
    
    if groups $USER | grep -q docker; then
        print_skip "Docker group configuration"
        save_state "$step_name"
        return 0
    fi
    
    if ! ask_confirm "Add user to docker group?"; then
        return 0
    fi
    
    print_step "Configuring Docker"
    
    print_substep "Adding user to docker group..."
    backup_path "/etc/group"
    sudo usermod -aG docker "$USER"
    
    save_state "$step_name"
    print_success "User added to docker group (re-login required)"
}

# Post-install tasks
post_install() {
    local step_name="post_install"
    
    if is_completed "$step_name"; then
        print_skip "Post-installation tasks"
        return 0
    fi
    
    print_step "Post-Installation Configuration"
    
    # Create directories
    print_substep "Creating necessary directories..."
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/share"
    
    # Configure fcitx5
    if ask_confirm "Configure fcitx5 environment variables?"; then
        if [[ ! -f "$HOME/.profile" ]] || ! grep -q "GTK_IM_MODULE" "$HOME/.profile"; then
            backup_path "$HOME/.profile"
            cat >> "$HOME/.profile" << 'EOF'

# fcitx5
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF
            print_success "fcitx5 configured"
        fi
    fi
    
    save_state "$step_name"
    print_success "Post-installation tasks completed"
}

# Print summary
print_summary() {
    print_header "INSTALLATION SUMMARY"
    
    echo -e "${BOLD}Installed Packages:${NC} ${#INSTALLED_PACKAGES[@]}"
    echo -e "${BOLD}Backup Location:${NC} $BACKUP_DIR"
    echo -e "${BOLD}Log File:${NC} $LOG_FILE"
    echo -e "${BOLD}Rollback File:${NC} $ROLLBACK_FILE"
    echo
    
    if [[ ${#INSTALLED_PACKAGES[@]} -gt 0 ]]; then
        echo -e "${DIM}View installed packages:${NC}"
        echo -e "${DIM}  cat $STATE_DIR/packages.txt${NC}"
        printf '%s\n' "${!INSTALLED_PACKAGES[@]}" > "$STATE_DIR/packages.txt"
    fi
    
    echo
}

main() {
    clear
    echo -e "${BOLD}${CYAN}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗ ║
    ║  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝ ║
    ║  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗   ║
    ║  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝   ║
    ║  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗ ║
    ║  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝ ║
    ║                                                          ║
    ║         EndeavourOS + Hyprland Automated Setup          ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${DIM}Installation log: $LOG_FILE${NC}"
    echo -e "${DIM}Backup directory: $BACKUP_DIR${NC}"
    echo
    
    # Load previous state
    load_state
    
    if ! ask_confirm "Start installation?"; then
        print_info "Installation cancelled"
        exit 0
    fi
    
    # Run installation steps
    check_prerequisites
    install_yay
    update_system
    install_packages
    deploy_dotfiles
    enable_services
    configure_shell
    configure_docker
    post_install
    
    # Print summary
    print_summary
    
    echo
    print_success "Installation completed successfully!"
    echo
    print_warning "Please reboot your system to apply all changes"
    echo
    
    if ask_confirm "Reboot now?"; then
        sudo reboot
    fi
}

# Handle script arguments
case "${1:-}" in
    --rollback)
        perform_rollback
        exit 0
        ;;
    --reset)
        rm -f "$STATE_FILE"
        print_success "State reset. Next run will be a fresh installation."
        exit 0
        ;;
    --status)
        if [[ -f "$STATE_FILE" ]]; then
            echo -e "${BOLD}Completed Steps:${NC}"
            jq -r 'keys[]' "$STATE_FILE" 2>/dev/null || echo "None"
        else
            echo "No installation state found"
        fi
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
