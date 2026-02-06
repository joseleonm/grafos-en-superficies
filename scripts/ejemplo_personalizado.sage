#!/usr/bin/env sage
# -*- coding: utf-8 -*-
"""
Ejemplo Personalizado
=====================
Plantilla para crear tus propios ribbon graphs.
"""

load('ribbongraph_visualizer.sage')

print("\n" + "="*70)
print("  CREAR TU PROPIO RIBBON GRAPH")
print("="*70)

# =============================================================================
# DEFINE TUS PERMUTACIONES AQUÍ
# =============================================================================

# Ejemplo 1: Cambiar estas permutaciones por las que quieras
sigma = '(1,2,3)(4,5,6)'      # Orden cíclico de dardos en vértices
rho = '(1,4)(2,5)(3,6)'        # Emparejamiento de dardos en aristas

# Ejemplo 2: Otro ribbon graph (descomenta para probar)
# sigma = '(1,2,3,4,5)'         # 1 vértice de grado 5
# rho = '(1,2)(3,4)'            # 2 aristas (self-loops)

# Ejemplo 3: Cuadrado (descomenta para probar)
# sigma = '(1,2)(3,4)(5,6)(7,8)'  # 4 vértices de grado 2
# rho = '(1,3)(2,5)(4,7)(6,8)'    # 4 aristas formando cuadrado

# =============================================================================

print(f"\nσ = {sigma}")
print(f"ρ = {rho}")

# Crear el visualizador
viz = RibbonGraphVisualizer(sigma, rho, phase=0.0)

# Calcular y mostrar invariantes
print("\n>>> INVARIANTES TOPOLÓGICOS")
print("="*70)
inv = viz.invariantes()

print(f"\nGénero (g):                    {inv['genus']}")
print(f"  → Número de 'agujeros' de la superficie")

print(f"\nVértices (V):                  {inv['vertices']}")
print(f"  → Número de ciclos en σ")

print(f"Aristas (E):                   {inv['aristas']}")
print(f"  → Número de 2-ciclos en ρ")

print(f"\nCaras μ (F):                   {inv['caras_mu']}")
print(f"  → Número de ciclos en μ = σ·ρ")

print(f"\nComponentes de frontera (b):  {inv['componentes_frontera']}")
print(f"  → Número de 'bordes' de la superficie")

print(f"\nCaracterística de Euler (χ):  {inv['euler_char_superficie']}")
print(f"  → χ = 2 - 2g - b = 2 - 2({inv['genus']}) - {inv['componentes_frontera']}")

print(f"\nVerificación V - E + F:       {inv['V-E+F(mu)']}")
print(f"  → {inv['vertices']} - {inv['aristas']} + {inv['caras_mu']}")

# Generar visualizaciones
print("\n>>> GENERANDO VISUALIZACIONES")
print("="*70)

archivos = viz.generar_secuencia_completa(
    output_dir='../outputs/imagenes',
    prefix='mi_ribbon_'
)

# Resumen
print("\n" + "="*70)
print("  ✓ COMPLETADO")
print("="*70)

print("\nSe generaron 5 imágenes:")
pasos = [
    "Paso 1: Grafo base (sin estructura ribbon)",
    "Paso 2: Con semiaristas (dardos en el borde)",
    "Paso 3: Vértices engrosados (discos)",
    "Paso 4: Ribbon completo (con cintas)",
    "Paso 5: Componentes de frontera"
]

for i, (archivo, desc) in enumerate(zip(archivos, pasos), 1):
    print(f"\n{i}. {desc}")
    print(f"   → {archivo}")

print("\n" + "="*70)
print("INTERPRETACIÓN")
print("="*70)

if inv['genus'] == 0 and inv['componentes_frontera'] == 0:
    superficie = "Esfera cerrada (sin agujeros ni bordes)"
elif inv['genus'] == 0:
    superficie = f"Esfera con {inv['componentes_frontera']} borde(s)"
elif inv['genus'] == 1 and inv['componentes_frontera'] == 0:
    superficie = "Toro cerrado (sin bordes)"
elif inv['genus'] == 1:
    superficie = f"Toro con {inv['componentes_frontera']} borde(s)"
else:
    superficie = f"Superficie de género {inv['genus']} con {inv['componentes_frontera']} borde(s)"

print(f"\nEste ribbon graph representa: {superficie}")

print("\n" + "="*70)
print("PARA PROBAR OTROS EJEMPLOS:")
print("="*70)
print("""
1. Edita este archivo (ejemplo_personalizado.sage)
2. Cambia las líneas que definen sigma y rho
3. Ejecuta de nuevo: sage ejemplo_personalizado.sage

Ejemplos que puedes probar:

• Theta graph (3 aristas paralelas):
  sigma = '(1,2,3)(4,5,6)'
  rho = '(1,6)(2,4)(3,5)'

• Bouquet (1 vértice, múltiples loops):
  sigma = '(1,2,3,4,5,6)'
  rho = '(1,2)(3,4)(5,6)'

• Cubo:
  sigma = '(1,2,3)(4,5,6)(7,8,9)(10,11,12)(13,14,15)(16,17,18)(19,20,21)(22,23,24)'
  rho = '(1,4)(2,7)(3,10)(5,13)(6,16)(8,19)(9,22)(11,14)(12,17)(15,20)(18,23)(21,24)'
""")

print("="*70 + "\n")
