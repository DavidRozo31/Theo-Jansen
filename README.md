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

Diseño y construcción de un **mecanismo articulado de 7 barras con 3 puntos fijos** inspirado en los mecanismos de Theo Jansen, que se desplaza mediante un movimiento caminante fluido y estable. El proyecto incluye análisis completo de cinemática mediante ecuaciones dinámicas, cinética y validación experimental.

### Características del Mecanismo

Este mecanismo utiliza una configuración innovadora de **7 eslabones** con **3 puntos de anclaje fijos**:
- **Punto O (0, 0)**: Anclaje de la manivela motriz
- **Punto C (-4.3, -1.2)**: Anclaje secundario del circuito inferior
- **Punto D (-2, 1.3)**: Anclaje del circuito superior (triángulo de la pata)

Esta configuración permite una trayectoria de paso optimizada con mayor estabilidad y control del movimiento.

### Objetivos

- ✅ Diseñar un mecanismo caminante funcional de 7 barras con 3 puntos fijos
- ✅ Realizar análisis cinemático con ecuaciones dinámicas (circuitos vectoriales)
- ✅ Calcular velocidades mediante derivación analítica de restricciones
- ✅ Realizar análisis cinético (fuerzas, torques en articulaciones)
- ✅ Implementar simulador interactivo con análisis en tiempo real
- ✅ Fabricar prototipo competitivo con materiales limitados
- ✅ Validar resultados teóricos mediante pruebas experimentales
- ✅ Competir en desafío de caminata lineal (1.5m)

## 🏗️ Estructura del Repositorio

```
Theo-Jansen/
├── .github/
│   └── copilot-instructions.md       # Instrucciones para agentes IA
├── informe-tecnico/
│   └── informe_theo_jansen.tex       # Informe LaTeX (2524 líneas)
├── solidos/                          # Archivos CAD SolidWorks
│   ├── piezas/                       # 12 componentes individuales (.SLDPRT)
│   ├── ensambles/                    # Ensambles y subensambles (.asm)
│   └── planos/                       # Dibujos técnicos (.drw)
├── codigo/                           # Scripts de simulación
│   ├── verificar_mecanismo.py        # ✅ Simulador Python interactivo
│   ├── cinematica/                   # Análisis cinemático MATLAB
│   ├── cinetica/                     # Análisis cinético MATLAB
│   ├── requirements.txt              # Dependencias Python
│   └── README_SIMULADOR.md           # Documentación del simulador
├── miscelaneos/
│   ├── registro-experimental.xlsx    # Datos experimentales (pendiente)
│   ├── presentacion.pptx             # Presentación del proyecto (pendiente)
│   └── videos/                       # Demostración del prototipo
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

### Parámetros del Mecanismo (7 Barras, 3 Puntos Fijos)

#### Puntos de Anclaje Fijos
```
O = (0.0, 0.0)      # Anclaje principal (manivela)
C = (-4.3, -1.2)    # Anclaje secundario inferior
D = (-2.0, 1.3)     # Anclaje superior (triángulo pata)
```

#### Longitudes de Eslabones (cm)
```
L_OA = 1.0          # Manivela motriz
L_AB = 3.0          # Biela principal
L_BF = 4.34         # Extensión hacia punto F
L_BC = 2.28         # Eslabón inferior hacia C
L_DE = 3.8          # Eslabón desde D hacia E
L_EF = 3.7          # Lado del triángulo (E-F)
L_FG = 5.65         # Lado del triángulo (F-G)
L_EG = 9.1          # Base del triángulo (E-G)
```

#### Circuitos Vectoriales

**Circuito 1 (O-A-B-C)**: Manivela y biela
```
r_OA + r_AB + r_BC = r_OC
```

**Circuito 2 (D-E-F)**: Eslabones flotantes
```
r_DE + r_EF = r_DF
```

**Circuito 3 (E-F-G)**: Triángulo de la pata
```
r_EF + r_FG + r_GE = 0
```

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
- **Simulación**: 
  - Python 3.13+ con Matplotlib (simulador interactivo)
  - MATLAB (análisis cinemático y cinético)
- **Documentación**: LaTeX (informe técnico IEEE)
- **Análisis de datos**: Excel (registro experimental)
- **Presentación**: PowerPoint

## 💻 Simulador Interactivo Python

El proyecto incluye un **simulador interactivo** implementado en Python con las siguientes características:

### Características Principales
- ✅ **Análisis cinemático en tiempo real** con ecuaciones dinámicas
- ✅ **Cálculo de velocidades analíticas** mediante derivación de restricciones vectoriales
- ✅ **Interfaz oscura profesional** (Dark Mode UI/UX)
- ✅ **Controles interactivos**:
  - Slider para ángulo de manivela (0-360°)
  - TextBox para velocidad angular (0.01-5.0 rad/s)
  - Botones: Play/Pausa/Reset/Actualizar ω
- ✅ **Visualización completa**:
  - Trayectoria del punto de apoyo G
  - Eslabones con código de colores
  - Triángulo EFG con relleno semitransparente
  - Detección de contacto con suelo
- ✅ **Animación fluida** a 30 FPS
- ✅ **Información en tiempo real**:
  - Velocidad angular ω (rad/s)
  - Velocidad lineal v_G (cm/s)
  - Advertencia de contacto con suelo

### Instalación y Ejecución

```bash
# Activar entorno virtual
.venv\Scripts\activate

# Instalar dependencias
pip install -r codigo/requirements.txt

# Ejecutar simulador
cd codigo
python verificar_mecanismo.py
```

### Dependencias
- Python 3.13+
- NumPy 1.24+
- Matplotlib 3.8+
- SciPy 1.16+

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

### ✅ Completado
- [x] Estructura de carpetas creada
- [x] Documentación inicial (README.md)
- [x] Definición de geometría del mecanismo (7 barras, 3 puntos fijos)
- [x] Simulador Python interactivo (`verificar_mecanismo.py`)
- [x] Análisis cinemático con ecuaciones dinámicas
- [x] Cálculo de velocidades analíticas (circuitos vectoriales)
- [x] Interfaz gráfica con Dark Mode
- [x] Sistema de animación y visualización
- [x] Detección de contacto con suelo
- [x] Informe LaTeX iniciado (2524 líneas)
- [x] Diseño CAD parcial en SolidWorks (12 piezas)

### 🔄 En Progreso
- [x] Análisis cinemático completo en MATLAB
- [x] Análisis cinético en MATLAB
- [ ] Diseño CAD completo (ensambles y planos)
- [ ] Informe técnico (secciones pendientes)

### 📋 Pendiente
- [ ] Fabricación del prototipo físico
- [ ] Pruebas experimentales
- [ ] Registro experimental (Excel)
- [ ] Presentación PowerPoint (8 diapositivas)
- [ ] Videos demostrativos
- [ ] Competencia final

## 📝 Convenciones de Código

### Nomenclatura MATLAB
```matlab
% Longitudes de eslabones (cm)
L_OA, L_AB, L_BF, L_BC    % Circuito inferior
L_DE, L_EF, L_FG, L_EG    % Circuito superior (triángulo)

% Ángulos de articulaciones (rad)
theta_OA, theta_AB, theta_BC    % Circuito O-A-B-C
theta_DE, theta_EF, theta_FG    % Circuito D-E-F-G

% Velocidades angulares (rad/s)
omega_OA, omega_AB, omega_BC    % Velocidades angulares del circuito inferior
omega_DE, omega_EF, omega_FG    % Velocidades angulares del circuito superior

% Aceleraciones angulares (rad/s²)
alpha_OA, alpha_AB, alpha_BC
alpha_DE, alpha_EF, alpha_FG

% Puntos fijos
O = [0.0, 0.0]          % Origen (anclaje manivela)
C = [-4.3, -1.2]        % Anclaje secundario inferior
D = [-2.0, 1.3]         % Anclaje superior
```

### Nomenclatura Python
```python
# Puntos del mecanismo
O, A, B, C, D, E, F, G = ...  # Coordenadas (x, y)

# Velocidades lineales
v_A, v_B, v_E, v_F, v_G = ...  # Vectores [vx, vy]

# Velocidades angulares de eslabones
omega_AB, omega_BC, omega_DE, omega_EF, omega_FG = ...
```

## 📦 Entrega Final

Carpeta comprimida: `Rodriguez_Rodriguez_Garcia.zip`

Contenido:
- `informe-tecnico/` → PDF del informe
- `solidos/` → Archivos SolidWorks (.prt, .asm, .drw)
- `codigo/` → Scripts MATLAB comentados
- `miscelaneos/` → Excel, PowerPoint, videos, fotos

## 🔬 Metodología de Análisis

### Análisis Cinemático (Ecuaciones Dinámicas)

El simulador implementa el **método de circuitos vectoriales cerrados** derivando analíticamente las ecuaciones de restricción:

1. **Posiciones**: Resolver sistema no lineal usando `scipy.optimize.fsolve`
   ```python
   # Ecuaciones de restricción para cada circuito
   r_OA + r_AB + r_BC - r_OC = 0
   r_DE + r_EF - r_DF = 0
   r_EF + r_FG + r_GE = 0
   ```

2. **Velocidades**: Derivar ecuaciones de restricción y resolver sistema lineal (Jacobiano)
   ```python
   # Matriz jacobiana del circuito i
   J_i = [[-L * sin(θ), ...],
          [ L * cos(θ), ...]]
   
   # Resolver: J × ω = -v_conocida
   ω = solve(J, -v)
   ```

3. **Aceleraciones**: Derivar ecuaciones de velocidad (segunda derivada)

### Análisis Cinético (Newton-Euler)

Implementado en MATLAB (`main_cinetica.m`) con las siguientes características:

- **Modelo de masa**: Masa total del mecanismo (300 g) distribuida uniformemente
- **Fuerzas consideradas**: Fuerza inercial + peso (g = 981 cm/s²)
- **Torque motor**: Calculado como F_total × r_OA
- **Especificaciones motor**: DC caja reductora amarilla (200 rpm), 2A máximo
- **Baterías**: 2x 3.7V 2200mAh recargables (7.4V en serie)

#### Resultados Cinéticos (8 patas con desfase 45°)

| Parámetro | Valor Máximo | Valor Mínimo | Unidad |
|-----------|--------------|--------------|--------|
| Fuerza en articulaciones | 121.60 | 0.00 | N |
| Torque requerido en motor | 12160.00 | 0.00 | N·cm |
| Potencia máxima motor | 14.80 | - | W |
| Energía total baterías | 16.34 | - | Wh |
| Autonomía estimada | 132.00 | - | minutos |

**Notas importantes**:
- Valores teóricos basados en masa total concentrada
- Torque máximo ocurre en posiciones de máxima fuerza
- Autonomía calculada asumiendo consumo constante a 2A
- Validación experimental requerida para ajuste de valores reales

## 📚 Referencias

- Jansen, T. (2007). *The Great Pretender*. 010 Publishers.
- Norton, R.L. (2011). *Diseño de Maquinaria*. McGraw-Hill.
- Uicker, J.J. (2003). *Theory of Machines and Mechanisms*. Oxford.
- Método de circuitos vectoriales para análisis cinemático
- Ecuaciones de Newton-Euler para sistemas multicuerpo
- SciPy Documentation: `scipy.optimize.fsolve` para sistemas no lineales

## 📧 Contacto

Para consultas sobre el proyecto, contactar a cualquiera de los integrantes del equipo mediante los correos institucionales proporcionados.

---

**Universidad Militar Nueva Granada**  
*Facultad de Ingeniería - Programa de Ingeniería Mecatrónica*  
*Curso: Dinámica Aplicada - Sexto Semestre*  
*Año: 2025*
