#!/bin/bash

# ==========================================
#  Preview de Presentación Quarto
# ==========================================

echo "======================================"
echo "  Preview de Presentación Reveal.js"
echo "======================================"
echo ""

# Cambiar al directorio del proyecto
cd "$(dirname "$0")/../quarto" || exit 1

# Listar presentaciones disponibles
echo "Presentaciones disponibles:"
echo ""
presentations=(presentaciones/*.qmd)
for i in "${!presentations[@]}"; do
    filename=$(basename "${presentations[$i]}")
    echo "  [$((i+1))] $filename"
done
echo ""

# Si solo hay una presentación, usarla directamente
if [ ${#presentations[@]} -eq 1 ]; then
    presentation="${presentations[0]}"
    echo ">>> Iniciando preview de: $(basename "$presentation")"
    echo ""
else
    # Pedir al usuario que seleccione
    read -p "Selecciona una presentación [1-${#presentations[@]}]: " choice
    presentation="${presentations[$((choice-1))]}"

    if [ ! -f "$presentation" ]; then
        echo "ERROR: Presentación no válida"
        exit 1
    fi

    echo ""
    echo ">>> Iniciando preview de: $(basename "$presentation")"
    echo ""
fi

echo "La presentación se abrirá en tu navegador."
echo "Controles:"
echo "  - Flechas: navegar"
echo "  - S: modo presentador"
echo "  - Esc: vista general"
echo "  - F: pantalla completa"
echo ""
echo "Presiona Ctrl+C para detener el servidor."
echo ""

# Iniciar preview
quarto preview "$presentation"
