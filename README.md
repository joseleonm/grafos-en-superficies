# Ribbon Graph Visualizer

Sistema completo de visualización para **ribbon graphs** (grafos de cinta) en SageMath, mostrando el proceso de engrosamiento desde el grafo base hasta la superficie ribbon completa.

## 📁 Estructura del Proyecto

```
Grafos en Superficies/
├── README.md                    # Este archivo
├── RESUMEN_PROYECTO.md          # Resumen ejecutivo
│
├── scripts/                     # Scripts de SageMath
│   ├── README.md                # Guía de scripts
│   ├── ribbongraph_visualizer.sage    # Módulo principal
│   ├── demo_completo.sage             # Demo con 4 ejemplos
│   ├── quick_test.sage                # Prueba rápida
│   ├── ejemplo_personalizado.sage     # Plantilla editable
│   ├── render_quarto.sh               # Renderizar sitio Quarto
│   └── preview_quarto.sh              # Preview del sitio
│
├── notebooks/                   # Jupyter notebooks
│   └── (tus notebooks aquí)
│
├── quarto/                      # Documentación Quarto ⭐ NUEVO
│   ├── README.md                # Guía de Quarto
│   ├── _quarto.yml              # Configuración
│   ├── styles.css               # Estilos personalizados
│   ├── index.qmd                # Página principal
│   ├── tutoriales/              # Tutoriales interactivos
│   │   ├── 01-introduccion.qmd
│   │   ├── 02-visualizacion.qmd
│   │   └── 03-invariantes.qmd
│   └── notas/                   # Notas de teoría
│       ├── teoria.qmd
│       └── ejemplos.qmd
│
└── outputs/                     # Resultados generados
    ├── imagenes/                # Visualizaciones PNG (20+)
    ├── datos/                   # Datos exportados
    └── quarto-site/             # Sitio web generado ⭐
```

## ✨ Características Principales

- ✅ **Visualización del proceso de engrosamiento** en **5 pasos**
- ✅ **Paso 5 nuevo**: Muestra componentes de frontera usando `boundary()`
- ✅ Cálculo automático de invariantes topológicos (género, fronteras, χ)
- ✅ Muestra dardos (half-edges), cintas y estructura ribbon completa
- ✅ Múltiples ejemplos: toro, triángulo, self-loops, theta graph
- ✅ Estructura de proyecto organizada (scripts/outputs/notebooks)
- ✅ Entrada flexible: strings o elementos de SymmetricGroup

## 🚀 Inicio Rápido

### 1. Verificar instalación de SageMath

```bash
sage --version
```

### 2. Ejecutar la demostración

```bash
cd "/Users/joseluis/Documents/Grafos en Superficies/scripts"
sage demo_completo.sage
```

Esto generará **20 imágenes** (4 ejemplos × 5 pasos) en `outputs/imagenes/`:

**Ejemplo 1: Toro (g=1, b=1)**
- `ejemplo1_paso1_grafo_base.png` → Grafo abstracto
- `ejemplo1_paso2_con_semiaristas.png` → División en dardos
- `ejemplo1_paso3_vertices_engrosados.png` → Vértices como discos
- `ejemplo1_paso4_ribbon_completo.png` → Ribbon con cintas
- `ejemplo1_paso5_fronteras.png` → Componentes de frontera ⭐

**Ejemplo 2: Self-loops (g=0, b=3)**
- `ejemplo2_paso1_grafo_base.png` → Grafo abstracto
- `ejemplo2_paso2_con_semiaristas.png` → División en dardos
- `ejemplo2_paso3_vertices_engrosados.png` → Vértices como discos
- `ejemplo2_paso4_ribbon_completo.png` → Ribbon con cintas
- `ejemplo2_paso5_fronteras.png` → Componentes de frontera ⭐

**Ejemplo 3: Triángulo K3 (g=0, b=2)**
- `ejemplo3_paso1_grafo_base.png` → Grafo abstracto
- `ejemplo3_paso2_con_semiaristas.png` → División en dardos
- `ejemplo3_paso3_vertices_engrosados.png` → Vértices como discos
- `ejemplo3_paso4_ribbon_completo.png` → Ribbon con cintas
- `ejemplo3_paso5_fronteras.png` → Componentes de frontera ⭐

**Ejemplo 4: Theta Graph (g=1, b=1)**
- `ejemplo4_paso1_grafo_base.png` → Grafo abstracto
- `ejemplo4_paso2_con_semiaristas.png` → División en dardos
- `ejemplo4_paso3_vertices_engrosados.png` → Vértices como discos
- `ejemplo4_paso4_ribbon_completo.png` → Ribbon con cintas
- `ejemplo4_paso5_fronteras.png` → Componentes de frontera ⭐

## 📖 Proceso de Engrosamiento (5 Pasos)

### Paso 1: Grafo Base
- Muestra el grafo abstracto con vértices (puntos) y aristas (líneas)
- NO tiene estructura ribbon todavía
- Es el punto de partida

### Paso 2: División en Dardos
- Cada arista se divide en 2 **dardos** (half-edges)
- Los dardos se marcan con puntos de colores
- Se muestra el punto medio donde se dividen
- Los números de dardos siguen el dominio de σ y ρ

### Paso 3: Engrosamiento de Vértices
- Los vértices se convierten en **DISCOS** (círculos amarillos)
- Los dardos salen radialmente del disco
- El **orden cíclico** alrededor del disco está dado por σ
- Empieza a verse la estructura ribbon

### Paso 4: Ribbon Completo
- Las aristas se convierten en **CINTAS** (ribbons azules)
- Las cintas conectan pares de dardos según ρ
- ¡Esta es la **superficie ribbon** completa!
- Se ve claramente el "engrosamiento" del grafo

### Paso 5: Componentes de Frontera ⭐ **NUEVO**
- Muestra las **componentes de frontera** usando `boundary()`
- Las fronteras se dibujan como curvas gruesas sobre el ribbon
- El número de componentes coincide con 'b' en los invariantes
- Permite visualizar el "borde" de la superficie ribbon

## 💻 Uso en Modo Interactivo

```bash
sage
```

```python
# Cargar el módulo
load('scripts/ribbongraph_visualizer.sage')

# Crear un ribbon graph
viz = RibbonGraphVisualizer('(1,2,3)(4,5,6)', '(1,4)(2,5)(3,6)')

# Mostrar invariantes
viz.mostrar_invariantes()

# Generar secuencia completa de engrosamiento
archivos = viz.generar_secuencia_completa(
    output_dir='outputs/imagenes',
    prefix='mi_ejemplo_'
)

# O generar pasos individuales
viz.paso_1_grafo_base(save_to='outputs/imagenes/paso1.png')
viz.paso_2_mostrar_dardos(save_to='outputs/imagenes/paso2.png')
viz.paso_3_engrosar_vertices(save_to='outputs/imagenes/paso3.png')
viz.paso_4_ribbon_completo(save_to='outputs/imagenes/paso4.png')
viz.paso_5_fronteras(save_to='outputs/imagenes/paso5.png')  # NUEVO
```

### Scripts Disponibles

1. **`demo_completo.sage`** - Demostración completa con 4 ejemplos
2. **`quick_test.sage`** - Prueba rápida de un ejemplo
3. **`ejemplo_personalizado.sage`** - Plantilla para crear tus propios ribbon graphs
```

## 📚 Documentación Quarto ⭐ **NUEVO**

El proyecto incluye documentación interactiva usando **Quarto**:

### Contenido

- **Tutoriales** - 3 tutoriales paso a paso con código ejecutable
- **Notas** - Teoría y ejemplos clásicos
- **Sitio Web** - Navegación fácil con búsqueda

### Usar Quarto

#### 1. Instalar

```bash
# macOS
brew install quarto

# Instalar dependencia para caché de ejecución en SageMath
sage -pip install jupyter-cache

# Linux/Windows
# Descarga desde: https://quarto.org/docs/get-started/
```

#### 2. Renderizar el sitio

```bash
cd scripts
./render_quarto.sh
```

O manualmente:
```bash
cd quarto
quarto render
```

El sitio se genera en: `outputs/quarto-site/`

#### 3. Preview con auto-reload

```bash
cd scripts
./preview_quarto.sh
```

O manualmente:
```bash
cd quarto
quarto preview
```

### Crear tus Propias Notas

1. Crea un archivo `.qmd` en `quarto/notas/` o `quarto/tutoriales/`
2. Agrega frontmatter YAML:

```yaml
---
title: "Mi Tutorial"
author: "Tu Nombre"
date: today
---
```

3. Escribe en Markdown con código ejecutable
4. Renderiza con `quarto render`

Ver [quarto/README.md](quarto/README.md) para más detalles.
```

## 📚 Teoría de Ribbon Graphs

Un **ribbon graph** se define mediante dos permutaciones:

### Permutaciones

- **σ (sigma)**: Permutación de vértices
  - Cada ciclo representa un vértice
  - Los elementos del ciclo son los dardos adyacentes en orden cíclico
  - Ejemplo: `(1,2,3)(4,5,6)` → 2 vértices, cada uno con 3 dardos

- **ρ (rho)**: Permutación de aristas
  - Cada 2-ciclo empareja dos dardos que forman una arista
  - Ejemplo: `(1,4)(2,5)(3,6)` → 3 aristas

- **μ (mu) = σ·ρ**: Producto da los ciclos de caras
  - El número de ciclos es el número de caras

### Invariantes Topológicos

Para una superficie con frontera:

**χ = 2 - 2g - b**

donde:
- **g** = género (número de "agujeros")
- **b** = número de componentes de frontera
- **χ** = característica de Euler

También se cumple la fórmula clásica:

**χ_grafo = V - E + F**

### Ejemplo: Toro (g=1)

```python
σ = '(1,2,3)(4,5,6)'  # 2 vértices de grado 3
ρ = '(1,4)(2,5)(3,6)' # 3 aristas
```

Invariantes:
- Género: 1 (toro)
- Vértices: 2
- Aristas: 3
- Caras: 1
- Componentes de frontera: 1
- χ = 2 - 2(1) - 1 = -1

## 🔧 API de la Clase `RibbonGraphVisualizer`

### Constructor

```python
RibbonGraphVisualizer(sigma, rho, n=None)
```

**Parámetros:**
- `sigma`: Permutación de vértices (string o SymmetricGroup element)
- `rho`: Permutación de aristas (string o SymmetricGroup element)
- `n`: Tamaño del grupo simétrico (opcional, se deduce automáticamente)

**Ejemplos:**
```python
# Con strings
viz = RibbonGraphVisualizer('(1,2,3)(4,5,6)', '(1,4)(2,5)(3,6)')

# Con grupo simétrico
S = SymmetricGroup(6)
viz = RibbonGraphVisualizer(S('(1,2,3)(4,5,6)'), S('(1,4)(2,5)(3,6)'))
```

### Métodos Principales

#### `invariantes()`
Retorna diccionario con invariantes topológicos.

#### `mostrar_invariantes()`
Imprime invariantes de forma legible.

#### `generar_secuencia_completa(output_dir, prefix)`
Genera las 4 imágenes del proceso de engrosamiento.

**Parámetros:**
- `output_dir`: Directorio de salida (default: '../outputs/imagenes')
- `prefix`: Prefijo para nombres de archivo (default: '')

**Retorna:** Lista de nombres de archivos generados

#### Métodos de Pasos Individuales

```python
paso_1_grafo_base(save_to=None)                              # Paso 1: Grafo base
paso_2_mostrar_dardos(radio_vertice=0.35, save_to=None)      # Paso 2: Con dardos
paso_3_engrosar_vertices(radio_vertice=0.45, save_to=None)   # Paso 3: Vértices engrosados
paso_4_ribbon_completo(radio_vertice=0.45, ancho_cinta=0.18, save_to=None)  # Paso 4: Ribbon completo
paso_5_fronteras(radio_vertice=0.45, ancho_cinta=0.18, save_to=None)        # Paso 5: Fronteras ⭐
```

### Funciones Auxiliares

```python
crear_ribbon_simple()      # Toro (2 vértices, 3 aristas)
crear_ribbon_triangulo()   # Triángulo (3 vértices, 3 aristas)
crear_ribbon_selfloop()    # Vértice con self-loops
```

## 📝 Ejemplos de Código

### Ejemplo 1: Generar visualización completa

```python
load('scripts/ribbongraph_visualizer.sage')

# Crear ribbon graph
viz = crear_ribbon_simple()

# Mostrar información
viz.mostrar_invariantes()

# Generar secuencia de 4 pasos
archivos = viz.generar_secuencia_completa(
    output_dir='outputs/imagenes',
    prefix='mi_toro_'
)

print("Archivos generados:", archivos)
```

### Ejemplo 2: Paso a paso manual

```python
load('scripts/ribbongraph_visualizer.sage')

# Ribbon graph personalizado
viz = RibbonGraphVisualizer('(1,2)(3,4)(5,6)', '(1,3)(2,5)(4,6)')

# Generar cada paso
viz.paso_1_grafo_base().show()
viz.paso_2_mostrar_dardos().show()
viz.paso_3_engrosar_vertices(radio=0.4).show()
viz.paso_4_ribbon_completo(ancho_cinta=0.25).show()
```

### Ejemplo 3: Analizar invariantes

```python
load('scripts/ribbongraph_visualizer.sage')

viz = RibbonGraphVisualizer('(1,2,3,4)', '(1,2)(3,4)')
inv = viz.invariantes()

print(f"Género: {inv['genus']}")
print(f"Vértices: {inv['vertices']}")
print(f"Aristas: {inv['aristas']}")
print(f"Caras: {inv['caras']}")
```

## 🎨 Interpretación Visual

### Colores y Símbolos

- **Círculos amarillos**: Vértices engrosados (discos)
- **Puntos rojos**: Dardos (half-edges)
- **Números rojos**: Etiquetas de dardos
- **Polígonos azules**: Cintas (ribbons) que conectan dardos
- **Líneas negras**: Aristas del grafo base

### Cómo Leer el Paso 4 (Ribbon Completo)

1. Cada **disco amarillo** es un vértice engrosado
2. Los **puntos rojos** alrededor del disco son los dardos
3. El **orden cíclico** de los dardos sigue σ
4. Las **cintas azules** conectan pares de dardos según ρ
5. La superficie ribbon se forma al pegar estas cintas

## 🔍 Verificación Matemática

Para verificar que el ribbon graph es correcto:

1. **Contar dardos**: Debe haber 2E dardos (E = número de aristas)
2. **Verificar σ**: Los ciclos de σ suman todos los dardos
3. **Verificar ρ**: Solo tiene 2-ciclos (cada arista = 2 dardos)
4. **Fórmula de Euler**: χ = V - E + F = 2 - 2g - b

## 📚 Referencias

- [SageMath Documentation - Ribbon Graphs](https://doc.sagemath.org/html/en/reference/geometry/sage/geometry/ribbon_graph.html)
- Gross, J. L., & Tucker, T. W. (1987). *Topological Graph Theory*. Wiley.
- Lando, S. K., & Zvonkin, A. K. (2004). *Graphs on Surfaces and Their Applications*. Springer.

## 🤝 Contribuciones

Este proyecto es educativo. Siéntete libre de:
- Crear nuevos ejemplos
- Agregar más visualizaciones
- Mejorar la documentación
- Reportar bugs

## 📜 Licencia

Uso libre para fines educativos y de investigación.

---

**Autor**: José Luis
**Fecha**: Enero 2026
**Herramienta**: SageMath 10.7 + Claude Code
