#!/bin/sh

echo "==> Updating repositories..."
apk update

echo "==> Installing core utilities..."
apk add --no-cache \
  bash bash-completion \
  nano curl wget git \
  openssh-client ca-certificates sudo

echo "==> Enabling bash completion..."
if [ ! -f /etc/profile.d/bash_completion.sh ]; then
  echo ". /etc/profile.d/bash_completion.sh" >> /etc/profile
fi

echo "==> Setting bash as default shell for root..."
sed -i 's|/bin/ash|/bin/bash|' /etc/passwd

echo "==> Updating certificate store..."
update-ca-certificates

echo "==> Cleaning up..."
apk cache clean

echo "==> QoL setup complete! 🎉"