#!/bin/sh
set -e

echo "==> Updating repositories..."
apk update

echo "==> Installing Zsh + Git..."
apk add --no-cache zsh git curl wget ca-certificates

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
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' "$ZSHRC"

# Ensure prompt always shows user@host
if ! grep -q 'PROMPT=' "$ZSHRC"; then
  cat <<'EOF' >> "$ZSHRC"

# Override prompt to always show user@host
PROMPT='%F{cyan}%n@%m%f %F{yellow}%~%f %# '
EOF
fi

echo "==> Setting Zsh as default shell for root..."
if grep -q '/bin/ash' /etc/passwd; then
  sed -i 's|/bin/ash|/bin/zsh|' /etc/passwd
fi

echo "==> Done! 🎉 Run 'exec zsh' to start using Oh My Zsh."