#!/bin/bash
# Script para renderizar el sitio Quarto de Ribbon Graphs

echo "======================================"
echo "  Renderizando Sitio Quarto"
echo "======================================"
echo ""

# Verificar que Quarto esté instalado
if ! command -v quarto &> /dev/null; then
    echo "❌ Quarto no está instalado."
    echo ""
    echo "Para instalar Quarto:"
    echo "  macOS: brew install quarto"
    echo "  Linux: https://quarto.org/docs/get-started/"
    echo "  Windows: https://quarto.org/docs/get-started/"
    exit 1
fi

echo "✓ Quarto está instalado: $(quarto --version)"
echo ""

# Ir al directorio quarto
cd "$(dirname "$0")/../quarto" || exit 1

echo ">>> Renderizando sitio..."
echo ""

# Renderizar el sitio
quarto render

# Verificar si fue exitoso
if [ $? -eq 0 ]; then
    echo ""
    echo "======================================"
    echo "  ✓ Sitio renderizado exitosamente"
    echo "======================================"
    echo ""
    echo "El sitio está en: ../outputs/quarto-site/"
    echo ""
    echo "Para ver el sitio:"
    echo "  quarto preview"
    echo ""
    echo "O abre manualmente:"
    echo "  open ../outputs/quarto-site/index.html"
else
    echo ""
    echo "❌ Error al renderizar el sitio"
    exit 1
fi
