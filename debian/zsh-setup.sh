#!/bin/bash
set -e

echo "==> Updating repositories..."
apt update -qq && apt upgrade -y

echo "==> Configuring UTF-8 locale..."
apt install -y locales
sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
update-locale LANG=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "==> Installing Zsh + essentials..."
apt install -y \
  zsh \
  git \
  curl \
  wget \
  fonts-powerline \
  ca-certificates

echo "==> Installing Oh My Zsh..."
export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes
export ZSH="${HOME}/.oh-my-zsh"

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSHRC="${HOME}/.zshrc"

# Copy default template if missing
if [ ! -f "$ZSHRC" ]; then
  cp "${ZSH}/templates/zshrc.zsh-template" "$ZSHRC"
fi

# Set theme to agnoster
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$ZSHRC"

echo "==> Setting Zsh as default shell..."
if command -v zsh >/dev/null 2>&1; then
  chsh -s "$(command -v zsh)" root || echo "⚠️ Could not set default shell automatically."
fi

echo "==> Cleaning up..."
apt autoremove -y
apt clean

echo "==> Done! 🎉"
echo "Run 'exec zsh' to start using Oh My Zsh."