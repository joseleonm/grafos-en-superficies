#!/usr/bin/env sage
# -*- coding: utf-8 -*-
"""
BR_lens_spaces.sage
===================
Calcula el polinomio de Bollobás-Riordan R(G_{p,q}; x, y, z) para los
ribbon graphs de Heegaard de los espacios lente L(p,q).

USO:
    sage BR_lens_spaces.sage

OPTIMIZACIONES FRENTE A LA VERSIÓN ANTERIOR:
  1. Reducción por órbitas (Z/pZ para p primo): en vez de iterar sobre los
     2^{2p} subconjuntos y descartar los no-canónicos, enumeramos directamente
     los representantes canónicos usando collares ("necklaces") de longitud p.
     Coste: O(2^{2p} / p) computaciones de BR en lugar de O(2^{2p}).

  2. Sin objetos Sage en el bucle interno: sigma, rho, phi se representan como
     listas Python puras. El polinomio de Sage se construye UNA SOLA VEZ al
     final, acumulando coeficientes enteros en un dict durante el bucle.

  3. bytearray para flags activos y visitados (más rápido que list[bool]).

  4. Tabla de Pascal precalculada para expansión binomial de (x-1)^s sin
     multiplicaciones repetidas.

COMPLEJIDAD (Python puro, un núcleo):
    p=7   → ~0.5 s    (2^14  /  7  ≈   2 340 pares canónicos)
    p=11  → ~5  s    (2^22  / 11  ≈ 382 K  pares canónicos)
    p=13  → ~60 s    (2^26  / 13  ≈   5 M  pares canónicos)
    p=17  → horas    (2^34  / 17  ≈   1 G  pares canónicos; necesita C/Cython)

SALIDA:
    - Tabla por pantalla
    - JSON: BR_lens_spaces_YYYYMMDD_HHMMSS.json
    - LaTeX: BR_lens_spaces_YYYYMMDD_HHMMSS.tex
"""

import time, json, os, sys, re
from datetime import datetime

# ─────────────────────────────────────────────────────────────
# 1.  CONSTRUCCIÓN DEL RIBBON GRAPH (arrays Python puros)
# ─────────────────────────────────────────────────────────────

def build_heegaard(p, q):
    """
    Construye el ribbon graph de Heegaard de L(p,q).

    Etiquetado de darts (0-indexed, 0 .. 4p-1):
        alfa_i  ->  d_out = 2i,        d_in = 2i+1
        beta_i  ->  d_out = 2p+2i,    d_in = 2p+2i+1

    sigma en vértice i (ciclo de longitud 4):
        (a_out(i), b_out(i), a_in((i-1)%p), b_in((i-q)%p))

    Retorna (phi_arr, edge_darts, vertex_of):
        phi_arr    : lista de n enteros, phi[d] = siguiente dart en la cara
        edge_darts : lista de 2p pares (d1, d2)
        vertex_of  : lista de n enteros, vertex_of[d] = índice del vértice de d
    """
    assert gcd(p, q) == 1 and 1 <= q < p

    n = 4 * p

    # Funciones de acceso a darts
    def ao(i): return 2 * i
    def ai(i): return 2 * i + 1
    def bo(i): return 2 * p + 2 * i
    def bi(i): return 2 * p + 2 * i + 1

    sigma = [0] * n
    rho   = [0] * n

    for i in range(p):
        cyc = [ao(i), bo(i), ai((i - 1) % p), bi((i - q) % p)]
        for j in range(4):
            sigma[cyc[j]] = cyc[(j + 1) % 4]

    for i in range(p):
        rho[ao(i)] = ai(i);  rho[ai(i)] = ao(i)
        rho[bo(i)] = bi(i);  rho[bi(i)] = bo(i)

    phi = [rho[sigma[d]] for d in range(n)]

    # Arista idx: alfa_i -> darts (2i, 2i+1), beta_i -> darts (2p+2i, 2p+2i+1)
    edge_darts = [(ao(i), ai(i)) for i in range(p)] + \
                 [(bo(i), bi(i)) for i in range(p)]

    # vertex_of: ciclos de sigma
    vertex_of = [-1] * n
    vis = bytearray(n)
    vi = 0
    for s in range(n):
        if not vis[s]:
            d = s
            while not vis[d]:
                vis[d] = 1
                vertex_of[d] = vi
                d = sigma[d]
            vi += 1

    return phi, edge_darts, vertex_of


# ─────────────────────────────────────────────────────────────
# 2.  COLLARES ("NECKLACES") PARA LA REDUCCIÓN POR ÓRBITAS
# ─────────────────────────────────────────────────────────────

def find_necklaces(p):
    """
    Devuelve todos los enteros a en [0, 2^p) que son el mínimo de su
    órbita bajo la rotación cíclica de p bits.
    Coste: O(2^p * p).
    """
    mask_p = (1 << p) - 1
    result = []
    for a in range(1 << p):
        cur = a
        is_min = True
        for _ in range(p - 1):
            cur = ((cur << 1) | (cur >> (p - 1))) & mask_p
            if cur < a:
                is_min = False
                break
        if is_min:
            result.append(a)
    return result


# ─────────────────────────────────────────────────────────────
# 3.  CÁLCULO DEL POLINOMIO BR  (bucle principal)
# ─────────────────────────────────────────────────────────────

def BR_lens(p, q, verbose=True):
    """
    Calcula R(G_{p,q}; x, y, z).

    Estrategia de enumeración (p primo):
        Una máscara de 2p bits representa un subconjunto A ⊆ E:
            bits 0..p-1   → aristas alfa
            bits p..2p-1  → aristas beta

        La rotación de vértices en Z/pZ actúa como:
            rotate(a, b) = (rotate_p(a), rotate_p(b))

        Un par (a, b) es canónico iff a es un "collar" (mínimo de su órbita
        de p bits). Si a ∉ {0, 111…1}, el tamaño de la órbita de (a,b) es p
        para cualquier b. Si a ∈ {0, 111…1}, la órbita de (a,b) tiene tamaño
        p a menos que b también sea un collar especial {0, 111…1}.

        Enumeramos:
            a ∈ {0, all1}  → b recorre todos los collares de p bits
            a collar primitivo  → b recorre todos los enteros [0, 2^p)
    """
    phi, edge_darts, vertex_of = build_heegaard(p, q)

    n  = 4 * p
    m  = 2 * p    # número de aristas
    V  = p        # número de vértices
    kG = 1        # G_{p,q} es conexo

    # Tabla de Pascal hasta m
    binom = [[0] * (m + 2) for _ in range(m + 2)]
    binom[0][0] = 1
    for ii in range(1, m + 2):
        binom[ii][0] = 1
        for jj in range(1, ii + 1):
            binom[ii][jj] = binom[ii - 1][jj - 1] + binom[ii - 1][jj]

    mask_p = (1 << p) - 1
    all1   = mask_p
    p_prime = is_prime(p)

    necklaces      = find_necklaces(p)
    necklace_set   = set(necklaces)
    prim_necklaces = [a for a in necklaces if a not in (0, all1)]

    coeffs        = {}              # {(ex, ey, ez): coeficiente entero}
    active        = bytearray(n)   # flag: dart activo en la máscara actual
    vis           = bytearray(n)   # flag: dart visitado al contar caras
    active_vertex = bytearray(V)   # flag: vértice con al menos un dart activo

    # Contadores de progreso
    t0 = time.time()
    n_canonical_approx = 2 * len(necklaces) + len(prim_necklaces) * (1 << p)
    processed = 0

    if verbose:
        print(f"  L({p},{q}): {n_canonical_approx:,} representantes canónicos estimados")

    # ── Función interna: procesar una máscara con su peso de órbita ──────────
    def procesar(mask, orb_sz):
        # Reiniciar darts activos
        for d in range(n):
            active[d] = 0
        eA = 0
        for idx in range(m):
            if (mask >> idx) & 1:
                d1, d2 = edge_darts[idx]
                active[d1] = 1
                active[d2] = 1
                eA += 1

        # k(A): componentes conexas del grafo (V, A) via Union-Find
        vp = list(range(V))

        def vfind(x):
            root = x
            while vp[root] != root:
                root = vp[root]
            # compresión de camino
            while vp[x] != root:
                vp[x], x = root, vp[x]
            return root

        for idx in range(m):
            if (mask >> idx) & 1:
                r1 = vfind(vertex_of[edge_darts[idx][0]])
                r2 = vfind(vertex_of[edge_darts[idx][1]])
                if r1 != r2:
                    vp[r1] = r2

        roots = set()
        for i in range(V):
            roots.add(vfind(i))
        kA = len(roots)

        # f(A): ciclos de phi_H restringida a darts activos + vértices aislados
        #
        # phi_H(d) = rho(sigma_H(d)), donde sigma_H salta darts inactivos en
        # la órbita de sigma.  En nuestro etiquetado, rho(d) = d^^1 (XOR), por lo que
        # sigma(d) = rho(phi(d)) = phi(d)^^1.  Así:
        #   sigma_H(d) = primer dart activo siguiendo sigma desde d
        #   phi_H(d)   = rho(sigma_H(d)) = sigma_H(d)^^1
        for d in range(n):
            vis[d] = 0
        for i in range(V):
            active_vertex[i] = 0
        fA = 0
        for start in range(n):
            if not active[start]:
                continue
            active_vertex[vertex_of[start]] = 1
            if vis[start]:
                continue
            fA += 1
            d = start
            while not vis[d]:
                vis[d] = 1
                nxt = phi[d] ^^ 1         # sigma(d)
                while not active[nxt]:
                    nxt = phi[nxt] ^^ 1   # sigma(nxt)
                d = nxt ^^ 1              # phi_H(d) = rho(sigma_H(d))
        # Cada vértice aislado contribuye 1 cara de frontera
        for i in range(V):
            if not active_vertex[i]:
                fA += 1

        # Invariantes
        gamma = 2 * kA - V + eA - fA   # = 2 * g(A), ∈ {0, 2}
        if gamma < 0:
            raise ValueError(
                f"gamma={gamma} < 0 — bug en conteo de caras "
                f"(mask={mask:#x}, kA={kA}, eA={eA}, fA={fA})"
            )
        s_exp = kA - kG                 # exponente de (x-1)
        t_exp = eA - V + kA             # nulidad

        # Expansión binomial de (x-1)^s_exp × peso × y^t × z^gamma
        for j in range(s_exp + 1):
            c = binom[s_exp][j] * orb_sz
            if (s_exp - j) & 1:
                c = -c
            key = (j, t_exp, gamma)
            old = coeffs.get(key, 0)
            new_val = old + c
            if new_val:
                coeffs[key] = new_val
            elif key in coeffs:
                del coeffs[key]

    # ── Enumeración de pares canónicos ───────────────────────────────────────

    # Caso 1: a ∈ {0, all1}  →  b recorre collares
    for a in (0, all1):
        for b in necklaces:
            mask = a | (b << p)
            # tamaño de la órbita de (a, b)
            if b == 0 or b == all1:
                orb_sz = 1
            else:
                orb_sz = p
            procesar(mask, orb_sz)
            processed += 1

    # Caso 2: a collar primitivo  →  b recorre [0, 2^p)
    progress_step = max(1, len(prim_necklaces) * (1 << p) // 20)
    for a in prim_necklaces:
        for b in range(1 << p):
            procesar(a | (b << p), p)
            processed += 1
            if verbose and processed % progress_step == 0:
                pct = 100.0 * processed / n_canonical_approx
                print(f"    {pct:5.1f}% | {processed:,} | {time.time()-t0:.1f}s")

    elapsed = time.time() - t0
    if verbose:
        print(f"  Completado: {processed:,} pares en {elapsed:.2f}s")

    # ── Construir el polinomio de Sage (una sola vez) ────────────────────────
    P = PolynomialRing(ZZ, 'x,y,z')
    x_v, y_v, z_v = P.gens()
    poly = P.zero()
    for (ex, ey, ez), c in coeffs.items():
        poly += c * x_v**ex * y_v**ey * z_v**ez

    return poly, elapsed


# ─────────────────────────────────────────────────────────────
# 4.  VERIFICACIÓN CONTRA EL POLINOMIO DE TUTTE
# ─────────────────────────────────────────────────────────────

def verificar(p, q, poly, verbose=True):
    """
    Comprueba R(G; x, y, 1) = T(G; x, y+1), donde T es el polinomio de Tutte.

    G_{p,q} se construye como multigrafo explícito para manejar q=1 (y q=p-1)
    donde las aristas alfa y beta conectan los mismos pares de vértices.
    """
    # Multigrafo explícito: p vértices, aristas alfa_i (i→i+1) y beta_i (i→i+q)
    G = Graph(multiedges=True)
    G.add_vertices(range(p))
    for i in range(p):
        G.add_edge(i, (i + 1) % p, f'a{i}')
        G.add_edge(i, (i + q) % p, f'b{i}')
    T = G.tutte_polynomial()

    P_BR = poly.parent()
    x_br, y_br, z_br = P_BR.gens()
    R_z1 = poly.subs({z_br: 1})

    P_T = T.parent()
    x_t, y_t = P_T.gens()
    T_shifted = T.subs({y_t: y_t + 1})

    # Comparar en un anillo común ZZ[x,y]
    P2 = PolynomialRing(ZZ, ['x', 'y'])
    x2, y2 = P2.gens()
    try:
        lhs = P2(R_z1)
        rhs = P2(T_shifted)
        ok = (lhs == rhs)
    except Exception:
        # Fallback: comparación por string si la coerción falla
        lhs_s = str(R_z1).replace(' ', '')
        rhs_s = str(T_shifted).replace(' ', '')
        ok = (lhs_s == rhs_s)

    if verbose:
        mark = "✓" if ok else "✗ FALLO"
        print(f"  Verificación Tutte: R(x,y,1) == T(x,y+1)  {mark}")
    return ok


# ─────────────────────────────────────────────────────────────
# 5.  CLASES DE HOMEOMORFISMO
# ─────────────────────────────────────────────────────────────

def orbita(q, p):
    q_inv = power_mod(q, -1, p)
    return frozenset({q % p, (-q) % p, q_inv % p, (-q_inv) % p} & set(range(1, p)))


def representantes(p):
    """Lista de representantes mínimos de cada clase de homeomorfismo de L(p,q)."""
    seen = set()
    reps = []
    for q in range(1, p):
        if gcd(q, p) != 1 or q in seen:
            continue
        orb = orbita(q, p)
        seen |= orb
        reps.append(min(orb))
    return sorted(reps)


# ─────────────────────────────────────────────────────────────
# 6.  SALIDA DE RESULTADOS
# ─────────────────────────────────────────────────────────────

def guardar_web_json(results, outpath):
    """
    Guarda un JSON compacto optimizado para la exploración web interactiva.

    Estructura por caso:
      { "p", "q", "label", "orbit", "homeomorphism_class",
        "n_terms", "max_ex", "max_ey", "max_ez", "time_s",
        "crest_profile": {"t": [...], "S": [...]},
        "terms": [[ex, ey, ez, coeff], ...] }
    """
    cases = []
    for (p, q), (poly, orb, t) in sorted(results.items()):
        # Extraer términos como [ex, ey, ez, coeff]
        if not hasattr(poly, 'monomials'):
            print(f"  ADVERTENCIA: R(G_{{{p},{q}}}) es FractionFieldElement — omitido del JSON")
            continue
        terms = []
        for (ex, ey, ez), c in zip(
            [m.exponents()[0] for m in poly.monomials()],
            poly.coefficients()
        ):
            terms.append([int(ex), int(ey), int(ez), int(c)])
        # Orden: ez desc, ey desc, ex desc  (facilita lectura)
        terms.sort(key=lambda t: (-t[2], -t[1], -t[0]))

        max_ex = max((t[0] for t in terms), default=0)
        max_ey = max((t[1] for t in terms), default=0)
        max_ez = max((t[2] for t in terms), default=0)

        # Perfil de cresta: S_t = max{ex : term [ex,t,2,*] existe}
        crest_t, crest_S = [], []
        ez2 = [(t[0], t[1]) for t in terms if t[2] == 2 and t[3] != 0]
        if ez2:
            ey_vals = sorted(set(ey for _, ey in ez2))
            for ey_val in ey_vals:
                s_val = max(ex for ex, ey in ez2 if ey == ey_val)
                crest_t.append(int(ey_val))
                crest_S.append(int(s_val))

        orb_sorted = sorted(int(v) for v in orb)
        cases.append({
            "p": int(p),
            "q": int(q),
            "label": f"L({p},{q})",
            "orbit": orb_sorted,
            "orbit_label": "{" + ",".join(str(v) for v in orb_sorted) + "}",
            "homeomorphism_class": " \u2245 ".join(f"L({p},{v})" for v in orb_sorted),
            "n_terms": len(terms),
            "max_ex": max_ex,
            "max_ey": max_ey,
            "max_ez": max_ez,
            "time_s": float(f"{float(t):.3f}"),
            "crest_profile": {"t": crest_t, "S": crest_S},
            "terms": terms,
        })

    os.makedirs(os.path.dirname(outpath), exist_ok=True)
    data = {
        "generated": datetime.now().isoformat(),
        "description": "Bollobás-Riordan polynomials R(G_{p,q}; x,y,z) "
                       "for Heegaard ribbon graphs of lens spaces L(p,q). "
                       "Terms encoded as [ex, ey, ez, coeff].",
        "cases": cases,
    }
    with open(outpath, 'w', encoding='utf-8') as f:
        json.dump(data, f, separators=(',', ':'), ensure_ascii=False)
    sz = float(os.path.getsize(outpath)) / 1024.0
    print(f"Web JSON → {outpath}  ({sz:.1f} KB, {len(cases)} casos)")


def guardar_resultados(results, outdir="."):
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")

    # ── JSON ─────────────────────────────────────────────────
    json_data = {}
    for (p, q), (poly, orb, t) in results.items():
        json_data[f"L({p},{q})"] = {
            "p": int(p), "q": int(q),
            "orbit": sorted(int(v) for v in orb),
            "polynomial": str(poly),
            "time_s": float(f"{float(t):.3f}"),
        }
    jpath = os.path.join(outdir, f"BR_lens_spaces_{ts}.json")
    with open(jpath, 'w') as f:
        json.dump(json_data, f, indent=2, ensure_ascii=False)
    print(f"\nJSON  → {jpath}")

    # ── LaTeX ────────────────────────────────────────────────
    lines = [
        r"\begin{table}[ht]",
        r"\centering",
        r"\small",
        r"\caption{Bollobás--Riordan polynomials $R(G_{p,q};\,x,y,z)$"
        r" for Heegaard graphs of lens spaces $L(p,q)$.}",
        r"\begin{tabular}{ccl}",
        r"\toprule",
        r"$p$ & $[q]_{\mathcal O}$ & $R(G_{p,q};\,x,y,z)$ \\",
        r"\midrule",
    ]
    for (p, q), (poly, orb, t) in sorted(results.items()):
        orb_str = r"\{" + ",".join(str(v) for v in sorted(orb)) + r"\}"
        poly_latex = latex(poly)
        lines.append(f"${p}$ & ${orb_str}$ & $\\displaystyle {poly_latex}$ \\\\")
    lines += [r"\bottomrule", r"\end{tabular}", r"\end{table}"]

    tpath = os.path.join(outdir, f"BR_lens_spaces_{ts}.tex")
    with open(tpath, 'w') as f:
        f.write('\n'.join(lines))
    print(f"LaTeX → {tpath}")


# ─────────────────────────────────────────────────────────────
# 7.  PROGRAMA PRINCIPAL
# ─────────────────────────────────────────────────────────────

if __name__ == "__main__":

    # ── Configuración ─────────────────────────────────────────
    # Primos p a calcular. Para p=13 espera ~60s, p=17 puede tardar horas.
    P_LIST   = [5, 7, 11, 13]
    VERIFICAR = True   # cotejar con el polinomio de Tutte de Sage (lento para p>11)
    OUTDIR   = os.path.dirname(os.path.abspath(__file__))

    print("=" * 65)
    print("  Polinomios de Bollobás-Riordan — Espacios Lente L(p,q)")
    print("=" * 65)

    results    = {}   # {(p, q): (poly, orbita, tiempo)}
    total_time = 0.0
    _project_root = os.path.dirname(OUTDIR)
    _web_json     = os.path.join(_project_root, "quarto", "data", "BR_polynomials.json")

    for p in P_LIST:
        print(f"\n{'─'*65}")
        print(f"  p = {p}  |  clases de homeomorfismo: {representantes(p)}")
        print(f"{'─'*65}")

        for q in representantes(p):
            orb = orbita(q, p)
            nombres = " ≅ ".join(f"L({p},{v})" for v in sorted(orb))
            print(f"\n  Clase: {nombres}")

            poly, t = BR_lens(p, q, verbose=True)
            results[(p, q)] = (poly, orb, t)
            total_time += t

            print(f"\n  R(G_{{{p},{q}}}; x,y,z) =")
            print(f"  {poly}\n")

            if VERIFICAR and p <= 11:
                verificar(p, q, poly, verbose=True)

            # Guardar incrementalmente tras cada polinomio
            guardar_web_json(results, _web_json)

    # ── Resumen ───────────────────────────────────────────────
    print(f"\n{'='*65}")
    print(f"  {len(results)} polinomios calculados  |  tiempo total: {total_time:.1f}s")
    print(f"{'='*65}\n")

    # ── Tabla comparativa ─────────────────────────────────────
    print(f"{'p':>3} {'q':>3} | {'Órbita':>18} | {'términos':>8} | {'grado z':>7} | {'s_max':>6} | tiempo")
    print("─" * 68)
    for (p, q), (poly, orb, t) in sorted(results.items()):
        try:
            pv      = poly.parent()
            z_var   = pv.gens()[2]
            grado_z = poly.degree(z_var)
            mons    = poly.monomials()
            n_terms = len(mons)
            s_max_slice = -1
            for mon in mons:
                exp = mon.exponents()[0]   # (ex, ey, ez)
                if exp[1] == 2 and exp[2] == 2:
                    s_max_slice = max(s_max_slice, exp[0])
        except AttributeError:
            # Polinomio con exponentes negativos en z — bug de conteo de caras
            grado_z, n_terms, s_max_slice = "?", "?", "?"
            print(f"  ADVERTENCIA: R(G_{{{p},{q}}}) tiene exponentes z negativos — "
                  f"revisa el conteo de caras.")

        orb_str = "{" + ",".join(str(v) for v in sorted(orb)) + "}"
        print(f"{p:>3} {q:>3} | {orb_str:>18} | {n_terms:>8} | {grado_z:>7} | {s_max_slice:>6} | {t:.1f}s")

    # ── Verificación cruzada entre órbitas ────────────────────
    print(f"\n{'─'*65}")
    print("  Verificación: pares homeomorfos tienen el mismo polinomio")
    print(f"{'─'*65}")
    for p in P_LIST:
        reps = representantes(p)
        for i, q1 in enumerate(reps):
            for q2 in reps[i+1:]:
                if q2 in orbita(q1, p):      # son homeomorfos
                    poly1 = results[(p, q1)][0]
                    poly2 = results.get((p, q2), (None,))[0]
                    if poly2 is not None:
                        ok = "✓" if poly1 == poly2 else "✗"
                        print(f"  R(L({p},{q1})) == R(L({p},{q2})): {ok}")
                elif results.get((p, q2)):   # no homeomorfos
                    poly1 = results[(p, q1)][0]
                    poly2 = results[(p, q2)][0]
                    ok = "✓ distintos" if poly1 != poly2 else "✗ IGUALES (error)"
                    print(f"  R(L({p},{q1})) != R(L({p},{q2})): {ok}")

    # ── Guardar ───────────────────────────────────────────────
    guardar_resultados(results, OUTDIR)
    # El web JSON ya se fue guardando incrementalmente tras cada polinomio.

    print("\nFin.")
