#!/bin/sh
set -e

echo "==> Updating repositories..."
apk update

echo "==> Installing Zsh + essentials..."
apk add --no-cache \
  zsh \
  git \
  curl \
  wget \
  ca-certificates \
  font-powerline \
  bash \
  ncurses-terminfo-base \
  tzdata

echo "==> Configuring UTF-8 locale..."
# Alpine doesn’t ship full locale-gen by default, but we can ensure UTF-8 defaults
echo "export LANG=en_US.UTF-8" >> /etc/profile
echo "export LC_ALL=en_US.UTF-8" >> /etc/profile
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "==> Installing Oh My Zsh..."
export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes
export ZSH="${HOME}/.oh-my-zsh"

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSHRC="$HOME/.zshrc"

# Copy default template if not present
if [ ! -f "$ZSHRC" ]; then
  cp "${ZSH}/templates/zshrc.zsh-template" "$ZSHRC"
fi

# Set theme to agnoster
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$ZSHRC"

echo "==> Setting Zsh as default shell for root..."
if grep -q '/bin/ash' /etc/passwd; then
  sed -i 's|/bin/ash|/bin/zsh|' /etc/passwd
fi

echo "==> Forcing Zsh for root login sessions..."
cat <<'EOF' > /root/.profile
# Force Zsh as login shell
if [ -t 1 ] && [ -x /bin/zsh ]; then
  export SHELL=/bin/zsh
  exec /bin/zsh
fi
EOF

echo "==> Cleaning up..."
rm -rf /var/cache/apk/*

echo "==> Done! 🎉"
echo "Run 'exec zsh' to start using Oh My Zsh."