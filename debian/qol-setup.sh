#!/bin/bash
set -e

echo "==> Updating repositories..."
apt update -qq && apt upgrade -y

echo "==> Installing core utilities..."
apt install -y \
  build-essential \
  curl \
  file \
  git \
  ufw \
  fonts-powerline

echo "==> Cleaning up..."
apt autoremove -y
apt clean

echo "==> QoL setup complete! 🎉"