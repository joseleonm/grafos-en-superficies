from sage.all import *

class VisualizadorEsquema:
    """
    Visualizador esquemático para Sistemas de Rotación.
    Dibuja los vértices como discos y muestra explícitamente el orden cíclico.
    """
    def __init__(self, sigma_str, rho_str):
        self.sigma = Permutation(sigma_str)
        self.rho = Permutation(rho_str)
        self.pos_dardos = {}

    def dibujar(self, archivo_salida):
        G = Graphics()
        
        # Obtener ciclos de vértices (sigma)
        ciclos = self.sigma.cycle_tuples()
        n_vertices = len(ciclos)
        
        # Configuración del layout
        R_layout = 4      # Radio del círculo donde se colocan los vértices
        r_vertice = 0.8   # Radio de cada vértice (disco)
        
        for i, ciclo in enumerate(ciclos):
            # Calcular centro del vértice (distribución circular)
            theta = 2 * pi * i / n_vertices if n_vertices > 1 else 0
            cx = R_layout * cos(theta) if n_vertices > 1 else 0
            cy = R_layout * sin(theta) if n_vertices > 1 else 0
            
            # 1. Dibujar el vértice (disco amarillo)
            G += circle((cx, cy), r_vertice, fill=True, rgbcolor='#FFFACD', edgecolor='black', thickness=2)
            G += text(f"V{i+1}", (cx, cy), color='black', fontsize=14, fontweight='bold')
            
            # 2. Dibujar los dardos en el borde
            n_dardos = len(ciclo)
            for j, dardo in enumerate(ciclo):
                # Ángulo local para el dardo (respetando el orden cíclico)
                # Se suma theta para orientarlos "hacia afuera" del centro global
                phi = theta + 2 * pi * j / n_dardos
                
                # Posición del punto de conexión (en el borde del disco)
                px = cx + r_vertice * cos(phi)
                py = cy + r_vertice * sin(phi)
                self.pos_dardos[dardo] = (px, py)
                
                # Posición de la etiqueta (un poco más afuera)
                lx = cx + (r_vertice + 0.4) * cos(phi)
                ly = cy + (r_vertice + 0.4) * sin(phi)
                
                # Dibujar punto y número
                G += point((px, py), color='#D32F2F', size=40, zorder=10)
                G += text(str(dardo), (lx, ly), color='#D32F2F', fontsize=10, fontweight='bold')

        # 3. Dibujar las conexiones (aristas)
        for par in self.rho.cycle_tuples():
            if len(par) == 2:
                u, v = par
                if u in self.pos_dardos and v in self.pos_dardos:
                    p1 = self.pos_dardos[u]
                    p2 = self.pos_dardos[v]
                    # Línea azul semitransparente
                    G += line([p1, p2], color='#1976D2', alpha=0.6, thickness=2, zorder=1)
        
        G.save(archivo_salida, axes=False, figsize=(8, 8))
        print(f"✅ Esquema generado: {archivo_salida}")