# 🎤 Presentaciones Reveal.js

Este directorio contiene presentaciones interactivas creadas con Quarto y Reveal.js.

## 📋 Presentaciones Disponibles

### [Sistemas de Rotación y Ribbon Graphs](sistemas-rotacion.qmd)

Presentación fundamental sobre la teoría de ribbon graphs:

- **Contenido:**
  - Sistemas de rotación y semiaristas (darts)
  - Proceso de engrosamiento: de $(\sigma,\rho)$ a superficies
  - Teorema de Heffter-Edmonds
  - Mapas combinatorios y el modelo permutacional
  - Permutación de caras $\varphi$ y algoritmo de face tracing
  - Cálculo de género y características de Euler
  - Conexión con SageMath

- **Diapositivas:** 14 slides
- **Nivel:** Introductorio a intermedio
- **Duración estimada:** 30-45 minutos

## 🚀 Cómo Ver las Presentaciones

### Opción 1: Preview Interactivo

```bash
# Desde el directorio raíz del proyecto
./scripts/preview_slides.sh
```

O manualmente:

```bash
cd quarto
quarto preview presentaciones/sistemas-rotacion.qmd
```

### Opción 2: Renderizar Todo el Sitio

```bash
cd quarto
quarto render
```

Luego abre `../outputs/quarto-site/presentaciones/sistemas-rotacion.html` en tu navegador.

## ⌨️ Controles de Navegación

### Básicos
- **Flechas ← →** : Navegar entre slides
- **Flechas ↑ ↓** : Navegar en slides verticales
- **Espacio** : Siguiente slide
- **Home** : Primera slide
- **End** : Última slide

### Avanzados
- **Esc** o **O** : Vista general (overview)
- **S** : Modo presentador (muestra notas y timer)
- **F** : Pantalla completa
- **B** o **.** : Pausar (pantalla negra)
- **V** : Cambiar a modo de impresión
- **Alt + Click** : Zoom en un elemento
- **?** : Mostrar ayuda

## 🎨 Personalización

Las presentaciones usan estilos personalizados definidos en [`../styles-slides.scss`](../styles-slides.scss).

### Colores del Proyecto
- **Primary:** `#1e88e5` (azul)
- **Secondary:** `#ff6f00` (naranja)
- **Success:** `#10b981` (verde)
- **Accent gradients** para fondos especiales

### Modificar Estilos

Edita `styles-slides.scss` para cambiar:
- Colores de fondo
- Tipografía
- Tamaño de fuentes
- Animaciones
- Callouts y bloques especiales

## 📝 Crear Nueva Presentación

1. **Crear archivo**
   ```bash
   touch quarto/presentaciones/mi-charla.qmd
   ```

2. **Agregar contenido**
   ```yaml
   ---
   title: "Mi Charla"
   author: "Tu Nombre"
   format:
     revealjs:
       theme: [default, ../styles-slides.scss]
       slide-number: true
       transition: slide
   ---

   ## Primera Slide

   Contenido aquí...

   ## Segunda Slide

   Más contenido...
   ```

3. **Preview**
   ```bash
   quarto preview presentaciones/mi-charla.qmd
   ```

## 🔧 Características Especiales

### Fragmentos Incrementales

```markdown
## Slide con Apariciones

::: {.incremental}
- Punto 1
- Punto 2
- Punto 3
:::

. . .

Este texto aparece después de los puntos.
```

### Columnas

```markdown
## Slide con Columnas

::: {.columns}
::: {.column width="50%"}
Contenido izquierda
:::

::: {.column width="50%"}
Contenido derecha
:::
:::
```

### Fondos Personalizados

```markdown
## Slide con Fondo Azul {background-color="#1e88e5"}

Texto en slide con fondo personalizado.
```

### Callouts en Slides

```markdown
## Slide con Callout

::: {.callout-important}
## Teorema Importante
Este es un teorema muy relevante.
:::
```

### Tamaño de Texto

```markdown
## Slide Compacto {.smaller}

Este slide tiene texto más pequeño para más contenido.
```

## 📊 Modo Presentador

El modo presentador (tecla `S`) muestra:
- Slide actual
- Siguiente slide (preview)
- Notas del presentador
- Timer

Para agregar notas:

```markdown
## Mi Slide

Contenido visible...

::: {.notes}
Estas son mis notas privadas para recordar qué decir.
:::
```

## 🖨️ Exportar a PDF

Para exportar una presentación a PDF:

```bash
quarto render presentaciones/sistemas-rotacion.qmd --to pdf
```

O desde el navegador:
1. Abre la presentación
2. Agrega `?print-pdf` al final de la URL
3. Usa Ctrl+P o Cmd+P para imprimir
4. Guarda como PDF

## 📚 Referencias

- [Quarto Presentations](https://quarto.org/docs/presentations/)
- [Reveal.js Documentation](https://revealjs.com/)
- [Reveal.js Keyboard Shortcuts](https://revealjs.com/keyboard/)

## 🎯 Tips para Presentaciones Efectivas

1. **Una idea por slide** - No sobrecargues
2. **Usa fragmentos** - Revela información progresivamente
3. **Imágenes grandes** - Mejor que mucho texto
4. **Código corto** - Fragmentos pequeños y relevantes
5. **Practica** - Usa el modo presentador para ensayar
6. **Controla el tiempo** - El timer del modo presentador ayuda
