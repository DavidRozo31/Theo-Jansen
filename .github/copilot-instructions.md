# Instrucciones para Agentes IA - Proyecto Mecanismo Theo Jansen

## Contexto del Proyecto

Proyecto académico de **Dinámica Aplicada** (Sexto Semestre - Mecatrónica, Universidad Militar) para diseñar, fabricar y analizar un **mecanismo caminante tipo Theo Jansen de 8 barras** que competirá en una pista de 1.5m.

## Arquitectura del Proyecto

```
Theo-Jansen/
├── informe-tecnico/          # Documento PDF final (11 secciones)
├── solidos/                  # Archivos SolidWorks (.prt, .asm, .drw)
│   ├── piezas/              # Componentes individuales
│   ├── ensambles/           # Ensambles y subensambles
│   └── planos/              # Dibujos técnicos
├── codigo/                   # Scripts MATLAB para simulación
│   ├── cinematica/          # Análisis de posición, velocidad, aceleración
│   └── cinetica/            # Análisis de fuerzas y torques
├── miscelaneos/
│   ├── registro-experimental.xlsx  # Datos de pruebas
│   ├── presentacion.pptx    # PowerPoint 8 diapositivas
│   └── videos/              # Demostración del prototipo
└── .github/
    └── copilot-instructions.md
```

## Restricciones Técnicas Críticas

- **Dimensiones máximas**: 40cm × 30cm × 20cm
- **Masa máxima**: 1.5 kg
- **Materiales permitidos**: MDF, acrílico, PLA (impresión 3D), aluminio liviano
- **Actuador**: 1 motor DC (6-12V, máx 2A) o propulsión manual
- **Sin ruedas**: Solo patas articuladas (mecanismo de 8 barras)
- **Estabilidad**: No perder contacto con suelo >25% del ciclo de paso

## Metodología del Proyecto (6 Fases)

### Fase 1: Definición del Problema
- Diseñar mecanismo que camine en línea recta sin volcamiento
- Movimiento fluido sin saltos excesivos

### Fase 2: Investigación
- Estudiar geometría del mecanismo Theo Jansen clásico (8 barras)
- Investigar relaciones de longitudes de eslabones para trayectoria estable
- **Referencia clave**: Proporciones de Jansen o variaciones optimizadas

### Fase 3: Diseño Conceptual (SolidWorks + MATLAB)
- **CAD**: Modelo 3D completo en SolidWorks
- **Simulación MATLAB**: 
  - Cinemática: calcular posición, velocidad, aceleración de cada punto
  - Cinética: fuerzas en articulaciones, torques requeridos
- Documentar: diagramas de cuerpo libre, ecuaciones de movimiento

### Fase 4: Fabricación
- Seleccionar materiales según disponibilidad
- Diseñar sistema de transmisión (engranajes/poleas si es motorizado)
- Considerar tolerancias de fabricación

### Fase 5: Pruebas Experimentales
Medir y comparar con simulaciones:
- Velocidad promedio (cm/s)
- Estabilidad (número de apoyos simultáneos)
- Consumo energético / torque del motor
- Registrar en `registro-experimental.xlsx`

### Fase 6: Competencia
Evaluar según criterios (ver abajo)

## Convenciones de Código MATLAB

### Estructura de Scripts
- `main_cinematica.m`: Script principal de análisis cinemático
- `main_cinetica.m`: Script principal de análisis cinético
- `calcular_posiciones.m`: Función para resolver posiciones de eslabones
- `calcular_velocidades.m`: Derivadas de posiciones
- `calcular_aceleraciones.m`: Segundas derivadas
- `graficar_trayectorias.m`: Visualización de resultados

### Nomenclatura
- Variables de longitudes: `L1, L2, ..., L8` para eslabones
- Ángulos: `theta1, theta2, ...` (en radianes)
- Velocidades angulares: `omega1, omega2, ...`
- Aceleraciones angulares: `alpha1, alpha2, ...`
- Posiciones cartesianas: `x, y` con subíndices de punto

### Comentarios Requeridos
```matlab
% Parámetros geométricos del mecanismo Theo Jansen
% Unidades: cm para longitudes, rad para ángulos
```

## Estructura del Informe Técnico

1. **Portada**: Nombres, código, fecha
2. **Introducción**: Contexto del mecanismo Theo Jansen
3. **Objetivos**: General y específicos
4. **Marco Teórico**: Principios de mecanismos articulados
5. **Modelado Cinemático**: Ecuaciones de posición, velocidad, aceleración
6. **Modelado Cinético**: Diagramas de cuerpo libre, ecuaciones de Newton-Euler
7. **Diseño CAD**: Justificación de geometría y materiales
8. **Simulaciones**: Gráficas de MATLAB con análisis
9. **Fabricación**: Proceso constructivo, desafíos, soluciones
10. **Pruebas Experimentales**: Datos medidos vs teóricos, análisis de error
11. **Conclusiones**: Aprendizajes y cumplimiento de objetivos
12. **Anexos**: Código MATLAB completo, planos, cálculos manuales

## Criterios de Evaluación (Competencia)

| Criterio | Peso | Descripción |
|----------|------|-------------|
| Movimiento estable | 25% | Fluidez sin saltos o vibraciones |
| Velocidad lineal | 20% | Desplazamiento eficiente en 1.5m |
| Diseño técnico | 20% | Calidad estructural y ensamblaje |
| Análisis dinámico | 20% | Concordancia teoría-práctica |
| Creatividad | 15% | Innovación en diseño |

## Comandos y Workflows Clave

### Simulación en MATLAB
```matlab
% Ejecutar análisis completo
run('main_cinematica.m')  % Genera gráficas de trayectorias
run('main_cinetica.m')    % Calcula fuerzas en articulaciones
```

### Exportación de Archivos
- **SolidWorks**: Guardar cada pieza como `.prt`, ensamble como `.asm`
- **Planos**: Exportar vistas principales como `.drw` o PDF
- **MATLAB**: Exportar gráficas como `.fig` y `.png` para informe

## Entrega Final

Crear carpeta comprimida: `Apellido1_Apellido2_Apellido3.zip` con:
- `informe-tecnico/` → PDF con mismo nombre de apellidos
- `solidos/` → Todos los archivos SolidWorks
- `codigo/` → Scripts MATLAB comentados
- `miscelaneos/` → Excel, PowerPoint, videos, fotos

## Notas Importantes para el Agente

- **Priorizar análisis teórico**: Las simulaciones en MATLAB son fundamentales para el 20% de evaluación en "Análisis dinámico"
- **Diseño modular en CAD**: Facilitar ensamblaje y modificaciones
- **Documentación exhaustiva**: Cada decisión de diseño debe justificarse en el informe
- **Unidades coherentes**: Usar cm para longitudes, segundos para tiempo, grados o radianes según contexto
- **Validación experimental**: Siempre comparar resultados teóricos vs mediciones reales

## Referencias Útiles

- Mecanismo original: Proporciones de Theo Jansen (a=38, b=41.5, c=39.3, d=40.1, e=55.8, f=39.4, g=36.7, h=65.7 en mm)
- Cinemática de mecanismos articulados: Método de circuitos vectoriales
- Cinética: Ecuaciones de Newton-Euler para sistemas multicuerpo
