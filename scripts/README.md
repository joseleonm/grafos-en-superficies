# Scripts de Ribbon Graphs

Esta carpeta contiene todos los scripts de SageMath para trabajar con ribbon graphs.

## 📁 Archivos Principales

### `ribbongraph_visualizer.sage` ⭐
**Módulo principal** con la clase `RibbonGraphVisualizer`.

Contiene:
- Clase principal `RibbonGraphVisualizer`
- 5 métodos de visualización paso a paso
- Cálculo de invariantes topológicos
- Funciones auxiliares para ejemplos comunes

**No ejecutes este archivo directamente**, cárgalo con `load()` desde otros scripts.

---

## 🚀 Scripts Ejecutables

### `demo_completo.sage`
**Demostración completa** con 4 ejemplos diferentes.

```bash
sage demo_completo.sage
```

**Genera:**
- 20 imágenes (4 ejemplos × 5 pasos)
- Muestra invariantes de cada ejemplo
- Explica el proceso paso a paso

**Ejemplos incluidos:**
1. Toro (g=1, b=1)
2. Self-loops (g=0, b=3)
3. Triángulo K3 (g=0, b=2)
4. Theta Graph (g=1, b=1)

---

### `quick_test.sage`
**Prueba rápida** de un ribbon graph simple.

```bash
sage quick_test.sage
```

**Genera:**
- 5 imágenes de un toro simple
- Muestra invariantes
- Perfecto para verificar que todo funciona

---

### `ejemplo_personalizado.sage`
**Plantilla** para crear tus propios ribbon graphs.

```bash
sage ejemplo_personalizado.sage
```

**Características:**
- Define tus propias permutaciones σ y ρ
- Genera las 5 visualizaciones automáticamente
- Incluye ejemplos comentados listos para probar
- Explica los invariantes obtenidos

**Cómo usar:**
1. Abre `ejemplo_personalizado.sage` en un editor
2. Cambia las líneas que definen `sigma` y `rho`
3. Ejecuta: `sage ejemplo_personalizado.sage`

---

## 📖 Uso Básico

### Desde la Terminal

```bash
# Ir a la carpeta de scripts
cd "/Users/joseluis/Documents/Grafos en Superficies/scripts"

# Ejecutar cualquier script
sage demo_completo.sage
sage quick_test.sage
sage ejemplo_personalizado.sage
```

### Modo Interactivo

```bash
# Iniciar SageMath
sage

# Cargar el módulo principal
load('ribbongraph_visualizer.sage')

# Crear ribbon graph
viz = RibbonGraphVisualizer('(1,2,3)(4,5,6)', '(1,4)(2,5)(3,6)')

# Mostrar invariantes
viz.invariantes()

# Generar visualizaciones
viz.generar_secuencia_completa(output_dir='../outputs/imagenes', prefix='test_')
```

---

## 🎨 Los 5 Pasos de Visualización

Todos los scripts generan 5 imágenes mostrando el proceso de engrosamiento:

1. **Paso 1**: Grafo base (abstracto, sin ribbon)
2. **Paso 2**: División en semiaristas (dardos en el borde)
3. **Paso 3**: Engrosamiento de vértices (discos amarillos)
4. **Paso 4**: Ribbon completo (cintas azules)
5. **Paso 5**: Componentes de frontera (curvas gruesas) ⭐ **NUEVO**

---

## 📂 Salida de Archivos

Todas las imágenes se guardan en:
```
../outputs/imagenes/
```

Formato de nombres:
- `ejemplo1_paso1_grafo_base.png`
- `ejemplo1_paso2_con_semiaristas.png`
- `ejemplo1_paso3_vertices_engrosados.png`
- `ejemplo1_paso4_ribbon_completo.png`
- `ejemplo1_paso5_fronteras.png`

---

## 🔧 Funciones Auxiliares

El módulo principal incluye funciones para ejemplos comunes:

```python
crear_ribbon_simple()      # Toro (g=1, b=1)
crear_ribbon_selfloop()    # Self-loops (g=0, b=3)
```

---

## 📚 Más Información

- **README principal**: `../README.md`
- **Documentación extendida**: `../README_ribbongraphs.md`
- **Imágenes generadas**: `../outputs/imagenes/`

---

## 🐛 Solución de Problemas

### Error: "No such file or directory"
```bash
# Asegúrate de estar en la carpeta correcta
cd "/Users/joseluis/Documents/Grafos en Superficies/scripts"
```

### Error: "cannot import..."
```bash
# Verifica que SageMath esté instalado
sage --version
```

### Las imágenes no se generan
```bash
# Verifica que la carpeta de salida exista
mkdir -p ../outputs/imagenes
```

---

**Última actualización**: Enero 2026
