#!/usr/bin/env sage
from sage.all import RibbonGraph, SymmetricGroup

print("="*70)
print("DIFERENCIA ENTRE CARAS Y FRONTERAS EN RIBBON GRAPHS")
print("="*70)
print()

S = SymmetricGroup(4)

# Caso A: sigma=(1,2,3,4), rho=(1,2)(3,4)
print("CASO A: sigma=(1,2,3,4), rho=(1,2)(3,4)")
print("-"*70)
sigma = S('(1,2,3,4)')
rho = S('(1,2)(3,4)')
R = RibbonGraph(sigma, rho)

# Calcular phi = rho * sigma^-1 para obtener las CARAS
phi = rho * sigma.inverse()

print("Estructura combinatoria:")
print("  sigma (vértices):", sigma, "→", len(sigma.cycle_tuples(singletons=True)), "vértice(s)")
print("  rho (aristas):", rho, "→", len(rho.cycle_tuples()), "arista(s)")
print("  phi=ρσ⁻¹ (caras):", phi, "→", len(phi.cycle_tuples(singletons=True)), "cara(s)")
print()

# Invariantes de Euler
V = len(sigma.cycle_tuples(singletons=True))
E = len(rho.cycle_tuples())
F = len(phi.cycle_tuples(singletons=True))
chi = V - E + F
g_calc = 1 - chi/2

print("Cálculo manual de invariantes:")
print("  V =", V)
print("  E =", E)
print("  F =", F)
print("  χ = V - E + F =", chi)
print("  g = 1 - χ/2 =", g_calc)
print()

print("RibbonGraph.boundary() devuelve:", R.boundary())
print("  ↳ Número de componentes de frontera:", R.number_boundaries())
print("  ↳ Género según RibbonGraph:", R.genus())
print()

print("INTERPRETACIÓN:")
print("• Las CARAS son los ciclos de φ = ρσ⁻¹")
print("• Las FRONTERAS (boundary) son los bordes de la superficie resultante")
print("• En este caso: superficie con GÉNERO 0 y 3 COMPONENTES DE FRONTERA")
print("  (como 3 discos disjuntos)")
print()
print()

# Caso B: sigma=(1,3,2,4), rho=(1,2)(3,4)
print("CASO B: sigma=(1,3,2,4), rho=(1,2)(3,4)")
print("-"*70)
sigma2 = S('(1,3,2,4)')
rho2 = S('(1,2)(3,4)')
R2 = RibbonGraph(sigma2, rho2)

# Calcular phi = rho * sigma^-1 para obtener las CARAS
phi2 = rho2 * sigma2.inverse()

print("Estructura combinatoria:")
print("  sigma (vértices):", sigma2, "→", len(sigma2.cycle_tuples(singletons=True)), "vértice(s)")
print("  rho (aristas):", rho2, "→", len(rho2.cycle_tuples()), "arista(s)")
print("  phi=ρσ⁻¹ (caras):", phi2, "→", len(phi2.cycle_tuples(singletons=True)), "cara(s)")
print()

# Invariantes de Euler
V2 = len(sigma2.cycle_tuples(singletons=True))
E2 = len(rho2.cycle_tuples())
F2 = len(phi2.cycle_tuples(singletons=True))
chi2 = V2 - E2 + F2
g_calc2 = 1 - chi2/2

print("Cálculo manual de invariantes:")
print("  V =", V2)
print("  E =", E2)
print("  F =", F2)
print("  χ = V - E + F =", chi2)
print("  g = 1 - χ/2 =", g_calc2)
print()

print("RibbonGraph.boundary() devuelve:", R2.boundary())
print("  ↳ Número de componentes de frontera:", R2.number_boundaries())
print("  ↳ Género según RibbonGraph:", R2.genus())
print()

print("INTERPRETACIÓN:")
print("• Las CARAS son los ciclos de φ = ρσ⁻¹")
print("• En este caso: 1 sola CARA (ciclo de longitud 4)")
print("• Superficie CERRADA (sin frontera) con GÉNERO 1 (toro)")
print()
print()

print("="*70)
print("CONCLUSIÓN")
print("="*70)
print()
print("En SageMath, RibbonGraph distingue entre:")
print()
print("1. CARAS (faces): ciclos de φ = ρσ⁻¹")
print("   → Número de regiones del encaje del grafo")
print("   → Se usan para calcular χ = V - E + F")
print()
print("2. FRONTERAS (boundaries): componentes del borde de la superficie")
print("   → Si boundary() es vacío: superficie CERRADA")
print("   → Si boundary() no es vacío: superficie con AGUJEROS")
print()
print("El método boundary() NO calcula las caras, sino las componentes")
print("de frontera de la superficie resultante del engrosamiento.")
print()
print("Para CARAS, debes calcular manualmente φ = ρσ⁻¹ y contar sus ciclos.")
