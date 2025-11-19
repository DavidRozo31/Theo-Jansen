# Mecanismo Caminante Tipo Theo Jansen

[![Universidad Militar Nueva Granada](https://img.shields.io/badge/UMNG-Mecatr%C3%B3nica-green)](https://www.umng.edu.co/)
[![Curso](https://img.shields.io/badge/Curso-Din%C3%A1mica%20Aplicada-blue)](https://github.com/DanielAraqueStudios/Theo-Jansen)
[![Semestre](https://img.shields.io/badge/Semestre-VI-orange)](https://github.com/DanielAraqueStudios/Theo-Jansen)

Proyecto académico de **Dinámica Aplicada** para el diseño, fabricación y análisis de un mecanismo caminante inspirado en los mecanismos de Theo Jansen.

## 👥 Equipo de Desarrollo

| Nombre | Correo | Rol |
|--------|--------|-----|
| **Sebastián Andrés Rodríguez Carrillo** | est.sebastian.arod2@unimilitar.edu.co | Desarrollador |
| **David Andrés Rodríguez Rozo** | est.david.arodrigu1@unimilitar.edu.co | Desarrollador |
| **Daniel García Araque** | est.daniel.garciaa@unimilitar.edu.co | Desarrollador |

**Universidad Militar Nueva Granada**  
Facultad de Ingeniería - Ingeniería Mecatrónica  
Sexto Semestre - 2025

## 📋 Descripción del Proyecto

Diseño y construcción de un **mecanismo articulado de 8 barras tipo Theo Jansen** que se desplaza mediante un movimiento caminante fluido y estable. El proyecto incluye análisis completo de cinemática, cinética y validación experimental.

### Objetivos

- ✅ Diseñar un mecanismo caminante funcional inspirado en Theo Jansen
- ✅ Realizar análisis cinemático (posición, velocidad, aceleración)
- ✅ Realizar análisis cinético (fuerzas, torques en articulaciones)
- ✅ Fabricar prototipo competitivo con materiales limitados
- ✅ Validar resultados teóricos mediante pruebas experimentales
- ✅ Competir en desafío de caminata lineal (1.5m)

## 🏗️ Estructura del Repositorio

```
Theo-Jansen/
├── .github/
│   └── copilot-instructions.md    # Instrucciones para agentes IA
├── informe-tecnico/                # Documento PDF del informe final
├── solidos/                        # Archivos CAD SolidWorks
│   ├── piezas/                    # Componentes individuales (.prt)
│   ├── ensambles/                 # Ensambles y subensambles (.asm)
│   └── planos/                    # Dibujos técnicos (.drw)
├── codigo/                         # Scripts de simulación MATLAB
│   ├── cinematica/                # Análisis de movimiento
│   └── cinetica/                  # Análisis de fuerzas
├── miscelaneos/
│   ├── registro-experimental.xlsx # Datos experimentales
│   ├── presentacion.pptx          # Presentación del proyecto
│   └── videos/                    # Demostración del prototipo
└── README.md
```

## 🔧 Especificaciones Técnicas

### Restricciones de Diseño

| Parámetro | Límite |
|-----------|--------|
| **Dimensiones máximas** | 40cm × 30cm × 20cm |
| **Masa máxima** | 1.5 kg |
| **Actuador** | 1 motor DC (6-12V, máx 2A) o manual |
| **Materiales permitidos** | MDF, acrílico, PLA, aluminio liviano |
| **Tipo de locomoción** | Solo patas articuladas (sin ruedas) |
| **Estabilidad mínima** | Contacto con suelo ≥75% del ciclo |

### Parámetros del Mecanismo Theo Jansen Clásico

Proporciones originales (en mm):
- a = 38.0
- b = 41.5
- c = 39.3
- d = 40.1
- e = 55.8
- f = 39.4
- g = 36.7
- h = 65.7

## 🚀 Metodología

### Fase 1: Definición del Problema
Establecer requisitos y condiciones de éxito del mecanismo caminante.

### Fase 2: Investigación
Analizar geometría del mecanismo de 8 barras y relaciones de eslabones.

### Fase 3: Diseño Conceptual
- Modelado CAD en **SolidWorks**
- Simulación cinemática y cinética en **MATLAB**

### Fase 4: Fabricación
Construcción del prototipo con materiales seleccionados.

### Fase 5: Pruebas Experimentales
Medición de:
- Velocidad promedio (cm/s)
- Estabilidad del paso
- Consumo energético

### Fase 6: Competencia
Evaluación según criterios establecidos.

## 📊 Criterios de Evaluación

| Criterio | Peso | Descripción |
|----------|------|-------------|
| **Movimiento estable** | 25% | Fluidez sin saltos o vibraciones |
| **Velocidad lineal** | 20% | Desplazamiento eficiente |
| **Diseño técnico** | 20% | Calidad estructural y ensamblaje |
| **Análisis dinámico** | 20% | Concordancia teoría-práctica |
| **Creatividad** | 15% | Innovación y estética |

## 🛠️ Herramientas Utilizadas

- **CAD**: SolidWorks (modelado 3D y planos)
- **Simulación**: MATLAB (análisis cinemático y cinético)
- **Documentación**: LaTeX/Word (informe técnico)
- **Análisis de datos**: Excel (registro experimental)
- **Presentación**: PowerPoint

## 📖 Documentación

### Informe Técnico (11 Secciones)
1. Portada
2. Introducción
3. Objetivos
4. Marco Teórico
5. Modelado Cinemático
6. Modelado Cinético
7. Diseño CAD
8. Resultados de Simulación
9. Fabricación y Ensamble
10. Pruebas Experimentales
11. Conclusiones y Anexos

### Presentación (8 Diapositivas)
1. Título y prototipo
2. Principio de funcionamiento
3. Análisis cinemático
4. Análisis cinético
5. Diseño CAD y materiales
6. Resultados y pruebas
7. Video demostrativo
8. Conclusiones

## 🎯 Estado del Proyecto

- [x] Estructura de carpetas creada
- [x] Documentación inicial
- [ ] Análisis cinemático en MATLAB
- [ ] Análisis cinético en MATLAB
- [ ] Diseño CAD en SolidWorks
- [ ] Fabricación del prototipo
- [ ] Pruebas experimentales
- [ ] Informe técnico final
- [ ] Presentación
- [ ] Competencia

## 📝 Convenciones de Código MATLAB

```matlab
% Nomenclatura estándar del proyecto
L1, L2, ..., L8           % Longitudes de eslabones (cm)
theta1, theta2, ...       % Ángulos de articulaciones (rad)
omega1, omega2, ...       % Velocidades angulares (rad/s)
alpha1, alpha2, ...       % Aceleraciones angulares (rad/s²)
```

## 📦 Entrega Final

Carpeta comprimida: `Rodriguez_Rodriguez_Garcia.zip`

Contenido:
- `informe-tecnico/` → PDF del informe
- `solidos/` → Archivos SolidWorks (.prt, .asm, .drw)
- `codigo/` → Scripts MATLAB comentados
- `miscelaneos/` → Excel, PowerPoint, videos, fotos

## 📚 Referencias

- Jansen, T. (2007). *The Great Pretender*. 010 Publishers.
- Norton, R.L. (2011). *Diseño de Maquinaria*. McGraw-Hill.
- Método de circuitos vectoriales para análisis cinemático
- Ecuaciones de Newton-Euler para sistemas multicuerpo

## 📧 Contacto

Para consultas sobre el proyecto, contactar a cualquiera de los integrantes del equipo mediante los correos institucionales proporcionados.

---

**Universidad Militar Nueva Granada**  
*Facultad de Ingeniería - Programa de Ingeniería Mecatrónica*  
*Curso: Dinámica Aplicada - Sexto Semestre*  
*Año: 2025*
