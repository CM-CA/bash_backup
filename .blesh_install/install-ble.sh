#!/bin/bash
# Script para instalar ble.sh en Arch Linux (AUR)

set -e

echo "Instalando ble.sh desde AUR..."

# Necesitas 'git' y 'base-devel' para makepkg
if ! command -v git &>/dev/null; then
    echo "git no está instalado. Instálalo primero."
    exit 1
fi

# Directorio temporal
TMPDIR=$(mktemp -d)
cd "$TMPDIR"

git clone https://aur.archlinux.org/ble.sh.git
cd ble.sh
makepkg -si

# Limpiar
cd ~
rm -rf "$TMPDIR"

echo "ble.sh instalado. Reinicia la terminal o ejecuta: source /usr/share/blesh/ble.sh"

