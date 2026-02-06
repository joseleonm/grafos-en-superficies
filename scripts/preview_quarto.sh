#!/bin/bash
# Script para hacer preview del sitio Quarto

echo "======================================"
echo "  Preview del Sitio Quarto"
echo "======================================"
echo ""

# Verificar que Quarto esté instalado
if ! command -v quarto &> /dev/null; then
    echo "❌ Quarto no está instalado."
    echo ""
    echo "Para instalar:"
    echo "  macOS: brew install quarto"
    exit 1
fi

# Ir al directorio quarto
cd "$(dirname "$0")/../quarto" || exit 1

echo ">>> Iniciando servidor de preview..."
echo ""
echo "El sitio se abrirá en tu navegador."
echo "Presiona Ctrl+C para detener el servidor."
echo ""

# Iniciar preview
quarto preview
