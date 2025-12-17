# Markenzas dotfiles

Daily driver dotfiles for the systems that I use. Includes idempotency, rollbacks with backups.
- Tracks completed steps in `~/.config/dotfiles-installer/state.json`;
- Backs up configs (with timestamps) in `~/.config/dotfiles-installer/backups/`;
- Skips already completed steps on re-run, safe to interrupt and resume;
- Tracks all changes in rollback file, with interactive rollback script.

## Installation

```bash
cd ~
git clone https://github.com/markenzas/dotfiles.git
cd dotfiles
chmod +x scripts/*.sh
./scripts/install.sh
```

## Commands

### Fresh Installation
```bash
./scripts/install.sh
```

### Check Installation Status
```bash
./scripts/install.sh --status
```

### Reset State (Start Fresh)
```bash
./scripts/install.sh --reset
```

### Rollback Changes
```bash
./scripts/rollback.sh
```

Or use the install script:
```bash
./scripts/install.sh --rollback
```

## Troubleshooting

### View Installation Log
```bash
cat ~/.config/dotfiles-installer/install-*.log
```

### View Completed Steps
```bash
./scripts/install.sh --status
```

### Restore Previous Config
```bash
./scripts/rollback.sh
# Select option 1, then choose backup timestamp
```

### Start Fresh Installation
```bash
./scripts/install.sh --reset
./scripts/install.sh
```

## File Locations

- **State**: `~/.config/dotfiles-installer/state.json`
- **Backups**: `~/.config/dotfiles-installer/backups/`
- **Logs**: `~/.config/dotfiles-installer/install-*.log`
- **Rollback**: `~/.config/dotfiles-installer/rollback-*.json`
