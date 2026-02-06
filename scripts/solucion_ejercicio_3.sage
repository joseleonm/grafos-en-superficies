from sage.all import *

def experimento_caras(n_semiaristas=20, n_intentos=100):
    """
    Solución al Ejercicio 3: Verificación de la fórmula de caras.
    """
    S = SymmetricGroup(n_semiaristas)
    
    # 2. Definir rho fijo: (1,2)(3,4)...
    # Creamos pares (i, i+1) para i impar
    pares = [(i, i+1) for i in range(1, n_semiaristas, 2)]
    # Construimos el string de ciclos para crear la permutación
    rho_str = ''.join(f"({a},{b})" for a, b in pares)
    rho = S(rho_str)
    
    print(f"Configuración:")
    print(f"  - Semiaristas: {n_semiaristas}")
    print(f"  - Rho fijo: {rho}")
    print(f"  - Intentos: {n_intentos}")
    print("-" * 40)
    
    coincidencias = 0
    min_caras = n_semiaristas
    max_caras = 0
    
    for i in range(n_intentos):
        # 3. Generar sigma aleatorio
        sigma = S.random_element()
        
        # 4. Calcular caras combinatoriamente (phi = rho * sigma)
        # Nota: Sage multiplica de izq a der por defecto para permutaciones
        phi = rho * sigma
        # Importante: singletons=True para contar ciclos de longitud 1
        num_caras_phi = len(phi.cycle_tuples(singletons=True))
        
        # 5. Comparar con RibbonGraph
        R = RibbonGraph(sigma, rho)
        num_fronteras_sage = R.number_boundaries()
        
        # Verificación
        if num_caras_phi == num_fronteras_sage:
            coincidencias += 1
        
        # Estadísticas
        min_caras = min(min_caras, num_caras_phi)
        max_caras = max(max_caras, num_caras_phi)
        
    print(f"Resultados:")
    print(f"  - Coincidencias: {coincidencias}/{n_intentos}")
    print(f"  - Mínimo de caras observado: {min_caras}")
    print(f"  - Máximo de caras observado: {max_caras}")
    
    if coincidencias == n_intentos:
        print("\n✅ ¡ÉXITO! La fórmula φ = ρσ coincide con RibbonGraph.boundary() en todos los casos.")
    else:
        print("\n❌ FALLO: Hubo discrepancias.")

if __name__ == "__main__":
    experimento_caras()