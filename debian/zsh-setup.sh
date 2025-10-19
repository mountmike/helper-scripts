#!/bin/bash
set -e

echo "==> Updating repositories..."
apt update -qq && apt upgrade -y

echo "==> Installing Zsh + Git + essentials..."
apt install -y \
  zsh \
  git \
  curl \
  wget \
  ca-certificates

echo "==> Installing Oh My Zsh..."
export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes
export ZSH="${HOME}/.oh-my-zsh"

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "==> Configuring basic .zshrc..."
ZSHRC="$HOME/.zshrc"

# Copy default template if not present
if [ ! -f "$ZSHRC" ]; then
  cp "${ZSH}/templates/zshrc.zsh-template" "$ZSHRC"
fi

# Set theme and prompt style
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$ZSHRC"

echo "==> Setting Zsh as default shell for root..."
if command -v zsh >/dev/null 2>&1; then
  chsh -s /usr/bin/zsh root || echo "⚠️ Could not change shell automatically. You may need to run: chsh -s /usr/bin/zsh"
fi

echo "==> Cleaning up..."
apt autoremove -y
apt clean

echo "==> Done! 🎉 Run 'exec zsh' to start using Oh My Zsh."