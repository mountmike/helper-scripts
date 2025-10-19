#!/bin/bash
set -euo pipefail

echo "==> Updating repositories..."
apt update -qq && apt upgrade -y

echo "==> Installing Zsh + essentials + Powerline fonts..."
apt install -y \
  zsh \
  git \
  curl \
  wget \
  ca-certificates \
  fonts-powerline

echo "==> Installing Oh My Zsh..."
export RUNZSH=no CHSH=no KEEP_ZSHRC=yes
export ZSH="${HOME}/.oh-my-zsh"
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# --- Pull shared profile from GitHub ---
PROFILE_URL="https://raw.githubusercontent.com/mountmike/helper-scripts/main/general/oh-my-profile.zsh"
PROFILE_DEST="$HOME/.config/zsh"
mkdir -p "$PROFILE_DEST"

echo "==> Downloading shared profile from GitHub..."
wget -qO "$PROFILE_DEST/oh-my-profile.zsh" "$PROFILE_URL"

# --- Write .zshrc to source the profile ---
ZSHRC="$HOME/.zshrc"
cat > "$ZSHRC" <<'EOF'
# Load shared Oh My Zsh profile
if [ -f "$HOME/.config/zsh/oh-my-profile.zsh" ]; then
  source "$HOME/.config/zsh/oh-my-profile.zsh"
else
  echo "⚠️  Missing shared profile: $HOME/.config/zsh/oh-my-profile.zsh"
fi
EOF

echo "==> Setting Zsh as default shell..."
if command -v zsh >/dev/null 2>&1; then
  chsh -s "$(command -v zsh)" root || echo "⚠️ Could not change shell automatically. Run manually: chsh -s $(command -v zsh)"
fi

echo "==> Cleaning up..."
apt autoremove -y && apt clean