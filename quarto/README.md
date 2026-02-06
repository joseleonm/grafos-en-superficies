# 📚 Documentación Quarto - Ribbon Graphs

Este directorio contiene la documentación interactiva del proyecto usando **Quarto**.

## 🎯 ¿Qué es Quarto?

[Quarto](https://quarto.org/) es un sistema de publicación científica y técnica que permite crear:
- Sitios web con código ejecutable
- Documentos PDF
- Presentaciones
- Notebooks interactivos

## 📁 Estructura

```
quarto/
├── _quarto.yml              # Configuración del sitio
├── styles.css               # Estilos personalizados
├── index.qmd                # Página principal
├── tutoriales/              # Tutoriales paso a paso
│   ├── 01-introduccion.qmd
│   ├── 02-visualizacion.qmd
│   └── 03-invariantes.qmd
└── notas/                   # Notas de teoría
    ├── teoria.qmd
    └── ejemplos.qmd
```

## 🚀 Inicio Rápido

### 1. Instalar Quarto

**macOS:**
```bash
brew install quarto
```

**Linux:**
```bash
# Descarga desde https://quarto.org/docs/get-started/
sudo dpkg -i quarto-*.deb  # Ubuntu/Debian
```

**Windows:**
Descarga el instalador desde [quarto.org](https://quarto.org/docs/get-started/)

### 2. Renderizar el Sitio

```bash
# Desde la raíz del proyecto
./scripts/render_quarto.sh
```

O manualmente:
```bash
cd quarto
quarto render
```

El sitio se genera en: `../outputs/quarto-site/`

### 3. Preview en Vivo

```bash
# Desde la raíz del proyecto
./scripts/preview_quarto.sh
```

O manualmente:
```bash
cd quarto
quarto preview
```

Esto abrirá el sitio en tu navegador con **auto-reload** (recarga automática al guardar cambios).

## ✏️ Crear Nuevo Contenido

### Nuevo Tutorial

1. Crea un archivo `.qmd` en `tutoriales/`:

```bash
touch tutoriales/04-mi-tutorial.qmd
```

2. Agrega el frontmatter:

```yaml
---
title: "Tutorial 4: Mi Tutorial"
author: "Tu Nombre"
date: today
format:
  html:
    code-fold: true
    toc: true
---
```

3. Escribe tu contenido en Markdown

4. Agrégalo a `_quarto.yml`:

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

### Nueva Nota

Similar, pero en la carpeta `notas/`.

## 📝 Sintaxis de Quarto Markdown

### Bloques de Código

#### Python/Sage

````markdown
```{python}
#| eval: false
#| code-fold: false

load('../scripts/ribbongraph_visualizer.sage')
viz = RibbonGraphVisualizer('(1,2,3)', '(1,2)')
viz.invariantes()
```
````

#### Opciones de ejecución

- `eval: false` - No ejecutar el código
- `code-fold: true` - Código plegable
- `echo: false` - No mostrar el código, solo resultado

### Callouts (Alertas)

```markdown
::: {.callout-note}
## Título del Callout
Contenido del callout
:::
```

Tipos disponibles:
- `.callout-note` - Notas (azul)
- `.callout-tip` - Tips (verde)
- `.callout-important` - Importante (rojo)
- `.callout-warning` - Advertencia (amarillo)

### Tabs

````markdown
::: {.panel-tabset}

### Tab 1
Contenido 1

### Tab 2
Contenido 2

:::
````

### Layouts de Imágenes

#### Dos columnas

```markdown
::: {layout-ncol=2}
![Imagen 1](ruta/imagen1.png)

![Imagen 2](ruta/imagen2.png)
:::
```

#### Grid personalizado

```markdown
::: {layout="[[40,-20,40], [100]]"}
![Imagen 1](img1.png)

![Imagen 2](img2.png)

![Imagen 3](img3.png)
:::
```

### Matemáticas

Inline: `$\chi = 2 - 2g - b$`

Display:
```markdown
$$
\chi = V - E + F
$$
```

### Acordeones (Details)

```markdown
<details>
<summary>Ver solución</summary>

Contenido oculto aquí.

</details>
```

## 🎨 Personalización

### Estilos CSS

Edita `styles.css` para cambiar:
- Colores
- Tipografía
- Espaciados
- Estilos de tablas

### Configuración del Sitio

Edita `_quarto.yml` para cambiar:
- Título del sitio
- Navegación
- Tema (light/dark)
- Formato de salida

## 🔧 Configuración Avanzada

### Ejecutar Código SageMath

Quarto por defecto ejecuta Python. Para SageMath:

1. Asegúrate de tener SageMath en el PATH
2. Usa el engine de Python pero carga scripts de Sage:

```{python}
import sys
sys.path.append('../scripts')
# Ahora puedes importar el visualizador
```

### Caché de Ejecución

Para acelerar el renderizado, habilita cache en `_quarto.yml`:

```yaml
execute:
  freeze: auto
  cache: true
```

### Publicar en GitHub Pages

1. Renderiza el sitio:
```bash
quarto render
```

2. El contenido en `outputs/quarto-site/` está listo para publicar

3. Copia a una rama `gh-pages` o usa GitHub Actions

## 📖 Recursos

- [Documentación Quarto](https://quarto.org/docs/guide/)
- [Quarto Gallery](https://quarto.org/docs/gallery/)
- [Markdown Guide](https://quarto.org/docs/authoring/markdown-basics.html)

## 🐛 Solución de Problemas

### Error: "quarto: command not found"

Instala Quarto (ver sección de instalación arriba).

### El código no se ejecuta

Verifica:
1. `eval: true` en el bloque de código
2. El engine está configurado correctamente
3. Las dependencias están instaladas

### Imágenes no se muestran

Usa rutas relativas desde el archivo `.qmd`:
```markdown
![](../../outputs/imagenes/ejemplo1.png)
```

### Preview no recarga automáticamente

Verifica que el puerto no esté ocupado:
```bash
lsof -i :4200  # Puerto por defecto
```

## 🤝 Contribuir

Para agregar contenido:

1. Crea tu archivo `.qmd`
2. Agrégalo a `_quarto.yml`
3. Renderiza y verifica
4. Commit y push

---

**¿Preguntas?** Revisa la [documentación principal](../README.md) del proyecto.
