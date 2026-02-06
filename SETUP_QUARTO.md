# 📚 Setup de Quarto - Guía Completa

## ✅ ¿Qué se Configuró?

Se ha configurado un sistema completo de documentación usando **Quarto** para el proyecto Ribbon Graphs.

### 📁 Estructura Creada

```
quarto/
├── _quarto.yml                 # Configuración del sitio
├── styles.css                  # Estilos personalizados para web
├── styles-slides.scss          # Estilos para presentaciones
├── README.md                   # Guía de Quarto
├── index.qmd                   # Página principal
├── tutoriales/                 # Tutoriales interactivos
│   ├── 01-introduccion.qmd     # Introducción a ribbon graphs
│   ├── 02-visualizacion.qmd    # Proceso de engrosamiento
│   └── 03-invariantes.qmd      # Invariantes topológicos
├── notas/                      # Notas de teoría
│   ├── teoria.qmd              # Fundamentos matemáticos
│   └── ejemplos.qmd            # Colección de ejemplos
└── presentaciones/             # Presentaciones Reveal.js
    └── sistemas-rotacion.qmd   # Sistemas de rotación y ribbon graphs
```

### 🎯 Características

- **Sitio web interactivo** con navegación y búsqueda
- **3 tutoriales** con código ejecutable
- **2 páginas de notas** con teoría y ejemplos
- **1 presentación Reveal.js** sobre sistemas de rotación
- **Estilos personalizados** con colores del proyecto
- **Scripts de automatización** para renderizar y preview

---

## 🚀 Inicio Rápido

### 1. Instalar Quarto

**macOS:**
```bash
brew install quarto
```

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get install gdebi-core
wget https://quarto.org/download/latest/quarto-linux-amd64.deb
sudo gdebi quarto-linux-amd64.deb
```

**Windows:**
Descarga el instalador desde [quarto.org](https://quarto.org/docs/get-started/)

### 2. Verificar Instalación

```bash
quarto --version
# Debe mostrar: 1.4+ o superior
```

### 3. Renderizar el Sitio

**Opción A: Script automático**
```bash
cd "/Users/joseluis/Documents/Grafos en Superficies/scripts"
./render_quarto.sh
```

**Opción B: Manualmente**
```bash
cd "/Users/joseluis/Documents/Grafos en Superficies/quarto"
quarto render
```

El sitio se genera en: `../outputs/quarto-site/`

### 4. Ver el Sitio

**Opción A: Preview con auto-reload**
```bash
cd scripts
./preview_quarto.sh
```

Esto abre el navegador y recarga automáticamente cuando guardas cambios.

**Opción B: Abrir archivo HTML**
```bash
open ../outputs/quarto-site/index.html
```

---

## 📝 Crear Contenido

### Nuevo Tutorial

1. **Crear archivo**
```bash
cd quarto/tutoriales
touch 04-mi-tutorial.qmd
```

2. **Agregar frontmatter**

Abre `04-mi-tutorial.qmd` y agrega:

```yaml
---
title: "Tutorial 4: Mi Tutorial"
author: "José Luis"
date: today
format:
  html:
    code-fold: true
    toc: true
execute:
  eval: false
---

# Mi Tutorial

Contenido aquí...
```

3. **Agregar al índice**

Edita `_quarto.yml` y agrega en `sidebar`:

```yaml
sidebar:
  contents:
    - section: "Tutoriales"
      contents:
        - tutoriales/01-introduccion.qmd
        - tutoriales/02-visualizacion.qmd
        - tutoriales/03-invariantes.qmd
        - tutoriales/04-mi-tutorial.qmd  # NUEVO
```

4. **Renderizar**
```bash
quarto render
```

### Nueva Nota

Similar al tutorial, pero en `quarto/notas/`:

```bash
cd quarto/notas
touch mi-nota.qmd
```

### Nueva Presentación (Reveal.js)

Las presentaciones usan el formato **Reveal.js** para slides interactivos.

1. **Crear archivo de presentación**
```bash
cd quarto/presentaciones
touch mi-presentacion.qmd
```

2. **Frontmatter para presentaciones**

```yaml
---
title: "Mi Presentación"
author: "Tu Nombre"
format:
  revealjs:
    theme: [default, ../styles-slides.scss]
    slide-number: true
    transition: slide
    incremental: false
---

## Primera Diapositiva

Contenido aquí...

## Segunda Diapositiva

Más contenido...
```

3. **Ver la presentación**

```bash
# Opción 1: Preview en tiempo real
cd quarto
quarto preview presentaciones/mi-presentacion.qmd

# Opción 2: Renderizar todo el sitio
quarto render
```

4. **Características de Reveal.js**

- **Navegación**: Flechas del teclado o clic
- **Vista general**: Presiona `Esc` o `O`
- **Modo presentador**: Presiona `S` (muestra notas y timer)
- **Pantalla completa**: Presiona `F`
- **Zoom**: Alt+clic en cualquier elemento
- **Pausar**: Presiona `.` (punto)

5. **Sintaxis especial para slides**

```markdown
## Slide Normal

Contenido visible desde el inicio.

. . .

Contenido que aparece después (fragment).

::: {.incremental}
- Punto 1 (aparece primero)
- Punto 2 (aparece después)
- Punto 3 (aparece al final)
:::

::: {.fragment}
Este bloque completo aparece junto.
:::

## Slide con Columnas {.smaller}

::: {.columns}
::: {.column width="50%"}
Columna izquierda
:::

::: {.column width="50%"}
Columna derecha
:::
:::

## Slide con Fondo {background-color="#1e88e5"}

Este slide tiene fondo azul.
```

---

## 🎨 Sintaxis de Quarto

### Código SageMath/Python

````markdown
```{python}
#| eval: false
#| code-fold: false
#| echo: true

# Cargar visualizador
load('../scripts/ribbongraph_visualizer.sage')

# Crear ribbon graph
viz = RibbonGraphVisualizer('(1,2,3)(4,5,6)', '(1,4)(2,5)(3,6)')

# Mostrar invariantes
print(viz.invariantes())
```
````

**Opciones:**
- `eval: false` - No ejecutar (solo mostrar código)
- `eval: true` - Ejecutar el código
- `code-fold: true` - Código plegable
- `echo: false` - No mostrar código, solo resultado

### Callouts (Alertas)

```markdown
::: {.callout-note}
## Nota
Este es un callout de tipo nota.
:::

::: {.callout-tip}
## Tip
Este es un tip útil.
:::

::: {.callout-important}
## Importante
Información importante.
:::

::: {.callout-warning}
## Advertencia
Cuidado con esto.
:::
```

### Tabs

```markdown
::: {.panel-tabset}

### Tab 1
Contenido del primer tab

### Tab 2
Contenido del segundo tab

### Tab 3
Contenido del tercer tab

:::
```

### Imágenes Lado a Lado

```markdown
::: {layout-ncol=2}
![Imagen 1](../../outputs/imagenes/ejemplo1_paso1_grafo_base.png)

![Imagen 2](../../outputs/imagenes/ejemplo1_paso4_ribbon_completo.png)
:::
```

### Matemáticas

**Inline:** `$\chi = 2 - 2g - b$`

**Display:**
```markdown
$$
\chi = V - E + F = 2 - 2g - b
$$
```

### Acordeones

```markdown
<details>
<summary>Ver solución</summary>

Contenido oculto que se revela al hacer clic.

</details>
```

### Enlaces

```markdown
[Texto del enlace](ruta/al/archivo.qmd)
[Tutorial 1](tutoriales/01-introduccion.qmd)
```

---

## ⚙️ Configuración

### Archivo `_quarto.yml`

Configuración principal del sitio:

```yaml
project:
  type: website
  output-dir: ../outputs/quarto-site

website:
  title: "Ribbon Graphs - Notas y Tutoriales"
  navbar:
    # Configuración de navegación...

format:
  html:
    theme: flatly          # Tema claro
    toc: true              # Tabla de contenidos
    number-sections: true  # Numerar secciones
    code-fold: false       # No plegar código por defecto

execute:
  freeze: auto            # Cache automático
  cache: true             # Habilitar cache
  warning: false          # No mostrar warnings
```

### Archivo `styles.css`

Estilos personalizados para el sitio. Edita este archivo para cambiar:

- **Colores:** Variables CSS en `:root`
- **Tipografía:** Fuentes y tamaños
- **Espaciado:** Márgenes y padding
- **Efectos:** Hover, animaciones

---

## 🔧 Comandos Útiles

### Renderizar

```bash
quarto render                    # Renderizar todo el sitio
quarto render index.qmd          # Renderizar solo index
quarto render tutoriales/        # Renderizar solo tutoriales
```

### Preview

```bash
quarto preview                   # Preview con auto-reload
quarto preview --port 8080       # Especificar puerto
quarto preview --no-browser      # Sin abrir navegador
```

### Limpiar

```bash
quarto clean                     # Limpiar archivos temporales
```

### Verificar

```bash
quarto check                     # Verificar instalación
quarto check jupyter             # Verificar Jupyter kernel
```

---

## 📊 Contenido Creado

### Tutoriales (3)

1. **Tutorial 1: Introducción** (`tutoriales/01-introduccion.qmd`)
   - ¿Qué es un ribbon graph?
   - Permutaciones σ y ρ
   - Primer ejemplo con código

2. **Tutorial 2: Visualización** (`tutoriales/02-visualizacion.qmd`)
   - Los 5 pasos del engrosamiento
   - Interpretación de visualizaciones
   - Ejemplos con imágenes

3. **Tutorial 3: Invariantes** (`tutoriales/03-invariantes.qmd`)
   - Género, fronteras, característica de Euler
   - Fórmulas y verificación
   - Ejercicios prácticos

### Notas (2)

1. **Teoría** (`notas/teoria.qmd`)
   - Definición formal
   - Construcción geométrica
   - Teoremas fundamentales

2. **Ejemplos** (`notas/ejemplos.qmd`)
   - Toro, self-loops, triángulo, theta
   - Bouquet, cuadrado, dumbell
   - Tabla comparativa

---

## 🎨 Personalización

### Cambiar Colores

Edita `styles.css`:

```css
:root {
  --ribbon-primary: #31BAE9;     /* Azul principal */
  --ribbon-secondary: #FF6B6B;   /* Rojo secundario */
  --ribbon-accent: #FFD93D;      /* Amarillo acento */
  --ribbon-dark: #2C3E50;        /* Gris oscuro */
}
```

### Cambiar Tema

Edita `_quarto.yml`:

```yaml
format:
  html:
    theme:
      light: flatly    # Tema claro: cosmo, flatly, minty
      dark: darkly     # Tema oscuro: darkly, slate, superhero
```

Temas disponibles: [Bootswatch](https://bootswatch.com/)

### Agregar Logo

Edita `_quarto.yml`:

```yaml
website:
  navbar:
    logo: ruta/al/logo.png
```

---

## 🐛 Solución de Problemas

### Error: "quarto: command not found"

**Solución:** Instala Quarto (ver sección de instalación).

### El código no se ejecuta

**Verifica:**
1. `eval: true` en el bloque de código
2. Engine correcto (python, julia, etc.)
3. Dependencias instaladas

**Solución:** Usa `eval: false` para solo mostrar código.

### Imágenes no se muestran

**Problema:** Rutas relativas incorrectas.

**Solución:** Usa rutas relativas desde el archivo `.qmd`:

```markdown
![](../../outputs/imagenes/ejemplo1.png)
```

### Preview no recarga automáticamente

**Problema:** Puerto ocupado o error de servidor.

**Solución:**
```bash
# Verificar puerto
lsof -i :4200

# Usar otro puerto
quarto preview --port 8080
```

### Error al renderizar

**Problema:** Sintaxis incorrecta en `.qmd`.

**Solución:**
```bash
quarto render archivo.qmd  # Ver error específico
quarto check               # Verificar configuración
```

---

## 📖 Recursos

- **[Documentación Quarto](https://quarto.org/docs/guide/)** - Guía completa
- **[Markdown Guide](https://quarto.org/docs/authoring/markdown-basics.html)** - Sintaxis Markdown
- **[Gallery](https://quarto.org/docs/gallery/)** - Ejemplos e inspiración
- **[Extensions](https://quarto.org/docs/extensions/)** - Extensiones disponibles

### Tutoriales Oficiales

- [Get Started](https://quarto.org/docs/get-started/)
- [Authoring](https://quarto.org/docs/authoring/)
- [Publishing](https://quarto.org/docs/publishing/)

---

## 🎉 Resumen

✅ **Setup completo de Quarto**
✅ **5 archivos .qmd** con contenido
✅ **Estilos personalizados**
✅ **Scripts de automatización**
✅ **Documentación completa**

### Próximos Pasos

1. **Instala Quarto** si aún no lo has hecho
2. **Renderiza el sitio:** `./scripts/render_quarto.sh`
3. **Ve el resultado:** `./scripts/preview_quarto.sh`
4. **Crea tu propio contenido**
5. **Personaliza estilos** en `styles.css`

---

**¿Dudas?** Revisa:
- [quarto/README.md](quarto/README.md) - Guía específica de Quarto
- [README.md](README.md) - Documentación del proyecto
- [RESUMEN_PROYECTO.md](RESUMEN_PROYECTO.md) - Resumen ejecutivo
