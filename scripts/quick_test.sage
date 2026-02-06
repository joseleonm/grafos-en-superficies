#!/usr/bin/env sage
# -*- coding: utf-8 -*-
"""
Quick Test - Prueba rápida de un ejemplo
==========================================
Genera los 5 pasos de un ribbon graph simple.
"""

load('ribbongraph_visualizer.sage')

print("\n" + "="*70)
print("  RIBBON GRAPH - PRUEBA RÁPIDA")
print("="*70)

# Crear ribbon graph simple
print("\n>>> Creando ribbon graph (Toro)...")
print("σ = (1,2,3)(4,5,6)")
print("ρ = (1,4)(2,5)(3,6)")

viz = crear_ribbon_simple()

# Mostrar invariantes
print("\n>>> Invariantes:")
inv = viz.invariantes()
for key, val in inv.items():
    print(f"  • {key:25s} = {val}")

# Generar secuencia completa
print("\n>>> Generando 5 pasos...")
archivos = viz.generar_secuencia_completa(
    output_dir='../outputs/imagenes',
    prefix='test_'
)

print("\n" + "="*70)
print("  ✓ COMPLETADO")
print("="*70)
print("\nArchivos generados:")
for i, f in enumerate(archivos, 1):
    print(f"  {i}. {f}")

print("\n" + "="*70)
print("Revisa las imágenes en: outputs/imagenes/test_paso*.png")
print("="*70 + "\n")
