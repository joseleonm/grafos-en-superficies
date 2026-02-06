#!/usr/bin/env sage
# -*- coding: utf-8 -*-

import numpy as np
from sage.all import (
    RibbonGraph, SymmetricGroup, Graph, Graphics,
    circle, line, text, point, polygon, sqrt
)
from math import pi, cos, sin


class RibbonGraphVisualizer:
    """
    Visualizador combinatorio de Ribbon Graphs.
    Enfatiza: orden cíclico (sigma), emparejamiento (rho) y fronteras (boundary()).
    """

    def __init__(self, sigma, rho, n=None, phase=0.0):
        """
        Args:
            sigma, rho: permutaciones (str o elementos del SymmetricGroup)
            n: grado del grupo simétrico (opcional)
            phase: rotación global (para acomodar dibujos)
        """
        self.phase = phase

        # --- inferir n si hace falta ---
        if isinstance(sigma, str) or isinstance(rho, str):
            import re
            nums_sigma = [int(x) for x in re.findall(r'\d+', str(sigma))]
            nums_rho   = [int(x) for x in re.findall(r'\d+', str(rho))]
            if n is None:
                n = max(nums_sigma + nums_rho) if (nums_sigma + nums_rho) else 1
        elif n is None:
            try:
                n = sigma.parent().degree()
            except Exception:
                n = rho.parent().degree()

        self.S = SymmetricGroup(n)

        self.sigma = self.S(sigma) if isinstance(sigma, str) else self.S(sigma)
        self.rho   = self.S(rho)   if isinstance(rho, str)   else self.S(rho)

        self.ribbon_graph = RibbonGraph(self.sigma, self.rho)

        # construcción del grafo subyacente (opcional)
        self.graph = self._construir_grafo()

        # posiciones (se recalculan según radio en cada paso)
        self._calcular_posiciones_vertices()

    # ------------------------------------------------------------
    # Construcción básica
    # ------------------------------------------------------------
    def _construir_grafo(self):
        sigma_cycles = self.sigma.cycle_tuples()
        rho_cycles = self.rho.cycle_tuples()

        dart_to_vertex = {}
        for v_idx, cycle in enumerate(sigma_cycles):
            for dart in cycle:
                dart_to_vertex[dart] = v_idx

        edges = []
        for edge in rho_cycles:
            if len(edge) == 2:
                d1, d2 = edge
                v1 = dart_to_vertex.get(d1, None)
                v2 = dart_to_vertex.get(d2, None)
                if v1 is not None and v2 is not None:
                    edges.append((v1, v2))

        return Graph(edges, multiedges=False, loops=True)

    def _calcular_posiciones_vertices(self, R=3.0):
        """Vértices en un círculo grande."""
        sigma_cycles = self.sigma.cycle_tuples()
        nV = len(sigma_cycles)
        self.vertex_positions = {}
        for i in range(nV):
            ang = self.phase + (2*pi*i/nV if nV > 1 else 0.0)
            self.vertex_positions[i] = (R*cos(ang), R*sin(ang))

    def _dart_to_vertex_map(self):
        sigma_cycles = self.sigma.cycle_tuples()
        d2v = {}
        for v_idx, cycle in enumerate(sigma_cycles):
            for d in cycle:
                d2v[d] = v_idx
        return d2v

    def _calcular_posiciones_dardos_en_borde(self, radio_vertice=0.35):
        """
        Coloca cada dardo (semiarista) sobre el borde del disco del vértice,
        respetando el orden cíclico de sigma.
        """
        sigma_cycles = self.sigma.cycle_tuples()
        nV = len(sigma_cycles)
        self.dart_positions = {}

        for v_idx, cycle in enumerate(sigma_cycles):
            cx, cy = self.vertex_positions[v_idx]
            k = len(cycle)
            # ángulos equiespaciados *locales* al vértice
            for j, d in enumerate(cycle):
                ang = self.phase + (2*pi*j/k if k > 0 else 0.0)
                self.dart_positions[d] = (cx + radio_vertice*cos(ang),
                                          cy + radio_vertice*sin(ang))

    # ------------------------------------------------------------
    # Invariantes (tu versión estaba bien; dejo igual, sólo limpio)
    # ------------------------------------------------------------
    def invariantes(self):
        mu = self.sigma * self.rho  # ojo: caras tipo Lando suelen usar rho^{-1}sigma^{-1}
        num_caras = len(mu.cycle_tuples())
        num_vertices = len(self.sigma.cycle_tuples())
        num_aristas = len(self.rho.cycle_tuples())

        g = self.ribbon_graph.genus()
        b = self.ribbon_graph.number_boundaries()
        euler_char = 2 - 2*g - b

        return {
            'genus': g,
            'caras_mu': num_caras,
            'vertices': num_vertices,
            'aristas': num_aristas,
            'componentes_frontera': b,
            'euler_char_superficie': euler_char,
            'V-E+F(mu)': num_vertices - num_aristas + num_caras
        }

    # ------------------------------------------------------------
    # PASO 1: grafo base
    # ------------------------------------------------------------
    def paso_1_grafo_base(self, save_to=None):
        G = Graphics()
        sigma_cycles = self.sigma.cycle_tuples()
        rho_cycles = self.rho.cycle_tuples()
        d2v = self._dart_to_vertex_map()

        # aristas (entre centros)
        for (d1, d2) in rho_cycles:
            v1, v2 = d2v[d1], d2v[d2]
            p1, p2 = self.vertex_positions[v1], self.vertex_positions[v2]
            G += line([p1, p2], color='black', thickness=2)

        # vértices
        for v_idx in range(len(sigma_cycles)):
            p = self.vertex_positions[v_idx]
            G += circle(p, 0.15, color='red', fill=True, thickness=2)
            G += text(f'v{v_idx}', (p[0], p[1]-0.45), fontsize=14, color='black')

        G.set_aspect_ratio(1); G.axes(False)
        if save_to: G.save(save_to, figsize=8)
        return G

    # ------------------------------------------------------------
    # PASO 2: dardos (semiaristas) sobre el borde de cada vértice
    # ------------------------------------------------------------
    def paso_2_mostrar_dardos(self, radio_vertice=0.35, save_to=None):
        G = Graphics()
        sigma_cycles = self.sigma.cycle_tuples()
        rho_cycles = self.rho.cycle_tuples()
        d2v = self._dart_to_vertex_map()
        self._calcular_posiciones_dardos_en_borde(radio_vertice=radio_vertice)

        # aristas finas (entre centros)
        for (d1, d2) in rho_cycles:
            v1, v2 = d2v[d1], d2v[d2]
            p1, p2 = self.vertex_positions[v1], self.vertex_positions[v2]
            G += line([p1, p2], color='lightgray', thickness=1)

        # discos de vértices
        for v_idx, cycle in enumerate(sigma_cycles):
            c = self.vertex_positions[v_idx]
            G += circle(c, radio_vertice, color='white', fill=True, edgecolor='black', thickness=2)
            G += text(f'v{v_idx}', c, fontsize=12, color='black')

            # dardos y etiquetas en orden de sigma
            for d in cycle:
                p = self.dart_positions[d]
                G += point(p, size=70, color='red', zorder=10)
                # etiqueta ligeramente hacia afuera
                cx, cy = c
                dx, dy = (p[0]-cx, p[1]-cy)
                L = sqrt(dx*dx + dy*dy)
                q = (p[0] + 0.18*dx/L, p[1] + 0.18*dy/L) if L > 0 else p
                G += text(str(d), q, fontsize=10, color='darkred', fontweight='bold',
                          background_color='white')

        G.set_aspect_ratio(1); G.axes(False)
        if save_to: G.save(save_to, figsize=8)
        return G

    # ------------------------------------------------------------
    # PASO 3: “engrosar” vértices (discos + marcas de orden)
    # ------------------------------------------------------------
    def paso_3_engrosar_vertices(self, radio_vertice=0.45, save_to=None):
        G = Graphics()
        sigma_cycles = self.sigma.cycle_tuples()
        d2v = self._dart_to_vertex_map()
        self._calcular_posiciones_dardos_en_borde(radio_vertice=radio_vertice)

        for v_idx, cycle in enumerate(sigma_cycles):
            c = self.vertex_positions[v_idx]
            G += circle(c, radio_vertice, color='lightyellow', fill=True,
                        edgecolor='orange', thickness=3)
            G += text(f'v{v_idx}', c, fontsize=12, color='black', fontweight='bold')

            # marcas pequeñas en el borde (muestran el orden cíclico)
            for d in cycle:
                p = self.dart_positions[d]
                G += point(p, size=80, color='red', zorder=10)

        G.set_aspect_ratio(1); G.axes(False)
        if save_to: G.save(save_to, figsize=8)
        return G

    # ------------------------------------------------------------
    # PASO 4: ribbon completo (cintas por rho)
    # ------------------------------------------------------------
    def paso_4_ribbon_completo(self, radio_vertice=0.45, ancho_cinta=0.18, save_to=None):
        G = Graphics()
        sigma_cycles = self.sigma.cycle_tuples()
        rho_cycles = self.rho.cycle_tuples()
        d2v = self._dart_to_vertex_map()
        self._calcular_posiciones_dardos_en_borde(radio_vertice=radio_vertice)

        # Cintas entre puntos de pegado (dardos)
        for (d1, d2) in rho_cycles:
            p1 = self.dart_positions[d1]
            p2 = self.dart_positions[d2]

            dx, dy = (p2[0]-p1[0], p2[1]-p1[1])
            L = sqrt(dx*dx + dy*dy)
            if L == 0:
                continue
            # perpendicular
            px, py = (-dy/L*ancho_cinta, dx/L*ancho_cinta)

            ribbon_points = [
                (p1[0]+px, p1[1]+py),
                (p2[0]+px, p2[1]+py),
                (p2[0]-px, p2[1]-py),
                (p1[0]-px, p1[1]-py),
            ]
            G += polygon(ribbon_points, color='lightblue', alpha=0.7,
                         edgecolor='blue', thickness=2)

        # discos de vértices encima (para “tapar” un poco y que se vea pegado)
        for v_idx, cycle in enumerate(sigma_cycles):
            c = self.vertex_positions[v_idx]
            G += circle(c, radio_vertice, color='lightyellow', fill=True,
                        edgecolor='orange', thickness=3)
            G += text(f'v{v_idx}', c, fontsize=12, color='black', fontweight='bold')

        # dardos y etiquetas
        for v_idx, cycle in enumerate(sigma_cycles):
            c = self.vertex_positions[v_idx]
            for d in cycle:
                p = self.dart_positions[d]
                G += point(p, size=90, color='red', zorder=10)
                dx, dy = (p[0]-c[0], p[1]-c[1])
                L = sqrt(dx*dx + dy*dy)
                q = (p[0] + 0.22*dx/L, p[1] + 0.22*dy/L) if L > 0 else p
                G += text(str(d), q, fontsize=11, color='darkred',
                          fontweight='bold', background_color='white')

        G.set_aspect_ratio(1); G.axes(False)
        if save_to: G.save(save_to, figsize=8)
        return G

    # ------------------------------------------------------------
    # PASO 5: dibujar fronteras usando RibbonGraph.boundary()
    # ------------------------------------------------------------
    def paso_5_fronteras(self, radio_vertice=0.45, ancho_cinta=0.18, save_to=None):
        """
        Dibuja el ribbon completo y encima traza las componentes de frontera
        que Sage devuelve con boundary().

        Nota: boundary() devuelve listas de dardos en orden a lo largo de la frontera.
        Aquí lo aproximamos conectando puntos de pegado de esos dardos.
        """
        G = self.paso_4_ribbon_completo(radio_vertice=radio_vertice, ancho_cinta=ancho_cinta)

        self._calcular_posiciones_dardos_en_borde(radio_vertice=radio_vertice)

        boundaries = self.ribbon_graph.boundary()  # lista de listas
        # Para que se distingan, alternamos estilos sin depender de colores muy específicos:
        # (Sage usa por defecto colores; aquí sólo variamos grosor/alpha.)
        for bd in boundaries:
            if len(bd) < 2:
                continue
            pts = [self.dart_positions[d] for d in bd if d in self.dart_positions]
            # boundary() a veces repite dardos; conectar tal cual ayuda a "ver" el ciclo
            for i in range(len(pts)-1):
                G += line([pts[i], pts[i+1]], thickness=4, alpha=0.6)

            # cerrar si no cierra explícitamente
            if pts and (pts[0] != pts[-1]):
                G += line([pts[-1], pts[0]], thickness=4, alpha=0.6)

        G.set_aspect_ratio(1); G.axes(False)
        if save_to: G.save(save_to, figsize=8)
        return G

    # ------------------------------------------------------------
    # Secuencia completa
    # ------------------------------------------------------------
    def generar_secuencia_completa(self, output_dir='./outputs', prefix=''):
        import os
        os.makedirs(output_dir, exist_ok=True)

        archivos = []
        print("\n>>> Generando secuencia de engrosamiento...")

        f1 = f'{output_dir}/{prefix}paso1_grafo_base.png'
        self.paso_1_grafo_base(save_to=f1); archivos.append(f1); print(f"  ✓ Paso 1 → {f1}")

        f2 = f'{output_dir}/{prefix}paso2_con_semiaristas.png'
        self.paso_2_mostrar_dardos(save_to=f2); archivos.append(f2); print(f"  ✓ Paso 2 → {f2}")

        f3 = f'{output_dir}/{prefix}paso3_vertices_engrosados.png'
        self.paso_3_engrosar_vertices(save_to=f3); archivos.append(f3); print(f"  ✓ Paso 3 → {f3}")

        f4 = f'{output_dir}/{prefix}paso4_ribbon_completo.png'
        self.paso_4_ribbon_completo(save_to=f4); archivos.append(f4); print(f"  ✓ Paso 4 → {f4}")

        f5 = f'{output_dir}/{prefix}paso5_fronteras.png'
        self.paso_5_fronteras(save_to=f5); archivos.append(f5); print(f"  ✓ Paso 5 → {f5}")

        return archivos


# ------------------ Ejemplos ------------------

def crear_ribbon_simple():
    # ejemplo típico (genus 1, 1 boundary en Sage)
    return RibbonGraphVisualizer('(1,2,3)(4,5,6)', '(1,4)(2,5)(3,6)', phase=0.2)

def crear_ribbon_selfloop():
    return RibbonGraphVisualizer('(1,2,3,4)', '(1,2)(3,4)', phase=0.0)
