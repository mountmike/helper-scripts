#!/bin/sh

echo "==> Updating repositories..."
apk update

echo "==> Installing core utilities..."
apk add --no-cache \
  bash \
  nano curl git \
  openssh-client

echo "==> Setting bash as default shell for root..."
sed -i 's|/bin/ash|/bin/bash|' /etc/passwd

echo "==> Cleaning up..."
apk cache clean

echo "==> QoL setup complete! 🎉"