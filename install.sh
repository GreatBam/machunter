#!/bin/bash
# mac_hunter - Dev + Pentest Mac bootstrap script
# Author: GreatBam
# Description: Sets up essential CLI/GUI tools, zsh config, and aliases

echo "Starting mac_hunter setup..."

# Check if git is already installed
if ! command -v git &>/dev/null; then
  echo "Git not found — no worries, will be installed shortly."
fi

# Check if brew is already installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed."
fi

# Remove Homebrew telemetry
brew analytics off
echo "Homebrew telemetry disabled."

# Update Homebrew 
brew update && brew upgrade
echo "Brew updated successfully."

# Use brew to install core tools
brew install \
  zsh \
  git \
  tmux \
  htop \
  wget \
  curl \
  openssh \
  bat \
  fzf \
  tree \
  python@3.13 \
  qemu \
  docker \
  docker-compose \
  nmap \
  aircrack-ng \
  hashcat \
  masscan \
  whois \
  netcat \
  go \
  starship \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  figlet \
  lolcat || true
echo "Core tools installed."

# Switch terminal if zsh is not already the default one
if [[ "$SHELL" != "$(which zsh)" ]]; then
  chsh -s "$(which zsh)"
  echo "Zsh set as default shell."
fi

# Install NVM and Node.js LTS if not already installed
if ! command -v nvm &>/dev/null && [ ! -d "$HOME/.nvm" ]; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  echo "Installing latest Node.js LTS version..."
  nvm install --lts
  nvm use --lts
else
  echo "NVM or Node.js already installed — skipped."
fi

# Use brew to install GUI tools
brew install --cask vscodium bruno
echo "GUI tools installed."

# Update .zshrc file if not already done
if ! grep -q "# mac_hunter setup" ~/.zshrc; then
  cat <<'EOF' >> ~/.zshrc
# mac_hunter setup

# Starship prompt
eval "$(starship init zsh)"

# Zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Banner
figlet "mac_hunter" | lolcat

# Custom aliases
# ------------------------
## Nmap
# ------------------------
alias quickscan="nmap -T4 -F"
alias fullscan="nmap -A -T4"
alias livehosts="nmap -sn 192.168.1.0/24"
# ------------------------
## Docker
# ------------------------
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dcu="docker compose up -d"
alias dcd="docker compose down -v"
alias dcb="docker compose build"
alias dcl="docker compose logs -f"
alias dcr="dcd && dcu"
alias dcrr="dcd && dcb && dcu"
alias dcrrl="dcd && dcb && dcu && dcl"
alias de='f(){ docker exec -it "$@" bash;  unset -f f; }; f'
alias di="docker images"
alias dn="docker network ls"
alias drn="docker network rm"
alias dri="docker rmi"
alias dr="docker rm"
# ------------------------
## Git
# ------------------------
alias ga="git add ."
alias gc="git commit -m"
alias gpl="git pull"
alias gph="git push"
alias gco="git checkout"
alias gd="git diff"
alias gb="git blame"
alias gs="git status"
alias gl="git log"

# end of mac_hunter setup
EOF
  echo "~/.zshrc file updated."
else
  echo "~/.zshrc already contains mac_hunter config — skipped."
fi

# Reload zsh terminal
source ~/.zshrc || true
echo "~/.zshrc file loaded. Please open a new terminal or run 'exec zsh' to apply changes."

echo "mac_hunter installation fully terminated, happy hacking :) !"
