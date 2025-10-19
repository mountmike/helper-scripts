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

echo "==> Setting Zsh as the default login shell for root..."

# Fix /etc/passwd entry
if grep -q '^root:.*:/bin/sh' /etc/passwd; then
  sed -i 's|^root:\(.*\):/bin/sh$|root:\1:/bin/zsh|' /etc/passwd
elif grep -q '^root:.*:/bin/ash' /etc/passwd; then
  sed -i 's|^root:\(.*\):/bin/ash$|root:\1:/bin/zsh|' /etc/passwd
fi

# Ensure fallback via ~/.profile (for console logins)
PROFILE="/root/.profile"
if ! grep -q 'exec /bin/zsh' "$PROFILE" 2>/dev/null; then
  echo "exec /bin/zsh" >> "$PROFILE"
fi

echo "==> Default shell now set to $(grep root /etc/passwd | awk -F: '{print $7}')"
echo "==> Run 'exec zsh' to start using Oh My Zsh immediately."