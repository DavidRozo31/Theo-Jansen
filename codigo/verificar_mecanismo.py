"""
Script para verificar la configuración del mecanismo Theo Jansen modificado
Resuelve la cinemática y grafica el mecanismo para confirmar geometría
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon, Circle
from matplotlib.widgets import Slider, Button, TextBox
from matplotlib.animation import FuncAnimation
from scipy.optimize import fsolve

class MecanismoVerificacion:
    def __init__(self):
        # Puntos fijos
        self.O = np.array([0.0, 0.0])
        self.C = np.array([-4.3, -1.2])
        self.D = np.array([-2.0, 1.3])
        
        # Longitudes de eslabones (en cm)
        self.L_OA = 1.0
        self.L_AB = 3.0
        self.L_BF = 4.34  # ABF total = 7.34, entonces BF = 7.34 - 3.0 = 4.34
        self.L_BC = 2.28
        self.L_DE = 3.8
        self.L_EF = 3.7
        self.L_FG = 5.65
        self.L_EG = 9.1
        
        # Variables para mantener continuidad (evitar colapsos)
        self.E_prev = None
        self.G_prev = None
        self.B_prev = None
        
        # Variables para calcular velocidad
        self.G_prev_pos = None
        self.theta_prev = None
        self.tiempo_prev = None
        
    def calcular_posiciones(self, theta_OA):
        """
        Resuelve las posiciones de todos los puntos dado el ángulo de la manivela
        theta_OA: ángulo de la manivela OA en radianes
        """
        # Punto A (conectado a manivela)
        A = self.O + self.L_OA * np.array([np.sin(theta_OA), np.cos(theta_OA)])
        
        # Resolver para B usando circuitos vectoriales
        # Circuito: O -> A -> B -> C -> O
        def ecuaciones_B(vars):
            xB, yB = vars
            B = np.array([xB, yB])
            
            # Restricción 1: |AB| = L_AB
            eq1 = np.linalg.norm(B - A) - self.L_AB
            
            # Restricción 2: |BC| = L_BC
            eq2 = np.linalg.norm(self.C - B) - self.L_BC
            
            return [eq1, eq2]
        
        # Estimación inicial para B (usar posición previa si existe)
        if self.B_prev is not None:
            B_guess = self.B_prev
        else:
            B_guess = A + self.L_AB * np.array([-0.7, 0.3])
        
        sol_B = fsolve(ecuaciones_B, B_guess)
        B = np.array(sol_B)
        self.B_prev = B
        
        # Punto F está en línea recta AFB
        # F = A + (L_AB + L_BF) * dirección_AB
        dir_AB = (B - A) / np.linalg.norm(B - A)
        F = A + (self.L_AB + self.L_BF) * dir_AB
        
        # Resolver para E usando circuito: D -> E -> F
        # E debe estar DEBAJO de F (F es el vértice superior del triángulo)
        def ecuaciones_E(vars):
            xE, yE = vars
            E = np.array([xE, yE])
            
            # Restricción 1: |DE| = L_DE
            eq1 = np.linalg.norm(E - self.D) - self.L_DE
            
            # Restricción 2: |EF| = L_EF
            eq2 = np.linalg.norm(F - E) - self.L_EF
            
            return [eq1, eq2]
        
        # Estimación inicial para E (usar posición previa para continuidad)
        if self.E_prev is not None:
            E_guess = self.E_prev
        else:
            E_guess = F + np.array([-2, 4])  # E abajo y a la izquierda de F
        
        sol_E = fsolve(ecuaciones_E, E_guess)
        E = np.array(sol_E)
        
        # Verificar que E cumpla con la restricción DE y mantenga orientación
        dist_DE = np.linalg.norm(E - self.D)
        if abs(dist_DE - self.L_DE) > 0.1:
            # Probar otra configuración
            E_guess = F + np.array([1, 5])
            sol_E = fsolve(ecuaciones_E, E_guess)
            E = np.array(sol_E)
        
        self.E_prev = E
        
        # Resolver para G usando triángulo EFG
        # G debe estar ABAJO, al mismo nivel o más abajo que E
        def ecuaciones_G(vars):
            xG, yG = vars
            G = np.array([xG, yG])
            
            # Restricción 1: |FG| = L_FG
            eq1 = np.linalg.norm(G - F) - self.L_FG
            
            # Restricción 2: |EG| = L_EG
            eq2 = np.linalg.norm(G - E) - self.L_EG
            
            return [eq1, eq2]
        
        # Estimación inicial para G (usar posición previa para continuidad)
        if self.G_prev is not None:
            G_guess = self.G_prev
        else:
            G_guess = E + np.array([6, 3])  # ABAJO y a la derecha de E
        
        sol_G = fsolve(ecuaciones_G, G_guess)
        G = np.array(sol_G)
        self.G_prev = G
        
        return {
            'O': self.O,
            'A': A,
            'B': B,
            'C': self.C,
            'D': self.D,
            'E': E,
            'F': F,
            'G': G
        }
    
    def calcular_velocidad_G(self, theta_OA, omega):
        """
        Calcula la velocidad lineal del punto G usando ecuaciones dinámicas
        Deriva las ecuaciones de restricción vectoriales para obtener velocidades
        theta_OA: ángulo actual de la manivela en radianes
        omega: velocidad angular de la manivela en rad/s (ω₂)
        """
        try:
            # Obtener posiciones actuales
            puntos = self.calcular_posiciones(theta_OA)
            A = puntos['A']
            B = puntos['B']
            E = puntos['E']
            F = puntos['F']
            G = puntos['G']
            
            # Velocidad del punto A (extremo de la manivela)
            # v_A = ω₂ × r_OA = ω₂ * L_OA * [-sin(θ₂), cos(θ₂)]
            v_A = omega * self.L_OA * np.array([-np.sin(theta_OA), np.cos(theta_OA)])
            
            # Calcular ángulos de los eslabones
            # Ángulo del eslabón AB
            vec_AB = B - A
            theta_AB = np.arctan2(vec_AB[1], vec_AB[0])
            
            # Ángulo del eslabón BC
            vec_BC = self.C - B
            theta_BC = np.arctan2(vec_BC[1], vec_BC[0])
            
            # Ecuación de restricción del circuito O-A-B-C:
            # Derivando: v_A + ω_AB × r_AB + ω_BC × r_BC = 0
            # Componentes perpendiculares para resolver ω_AB y ω_BC
            
            # Matriz jacobiana del circuito O-A-B-C
            J1 = np.array([
                [-self.L_AB * np.sin(theta_AB), -self.L_BC * np.sin(theta_BC)],
                [self.L_AB * np.cos(theta_AB), self.L_BC * np.cos(theta_BC)]
            ])
            
            b1 = -v_A
            
            try:
                velocidades_angulares_1 = np.linalg.solve(J1, b1)
                omega_AB = velocidades_angulares_1[0]
                omega_BC = velocidades_angulares_1[1]
            except:
                return 0.0, np.array([0.0, 0.0])
            
            # Velocidad de B
            v_B = v_A + omega_AB * self.L_AB * np.array([-np.sin(theta_AB), np.cos(theta_AB)])
            
            # Velocidad de F (está en línea con A y B)
            # F = A + (L_AB + L_BF) * dirección_AB
            v_F = v_A + omega_AB * (self.L_AB + self.L_BF) * np.array([-np.sin(theta_AB), np.cos(theta_AB)])
            
            # Calcular ángulos del triángulo DEF-G
            vec_DE = E - self.D
            theta_DE = np.arctan2(vec_DE[1], vec_DE[0])
            
            vec_EF = F - E
            theta_EF = np.arctan2(vec_EF[1], vec_EF[0])
            
            vec_FG = G - F
            theta_FG = np.arctan2(vec_FG[1], vec_FG[0])
            
            vec_EG = G - E
            theta_EG = np.arctan2(vec_EG[1], vec_EG[0])
            
            # Circuito D-E-F con velocidad conocida de F
            # v_F = v_D + ω_DE × r_DE + ω_EF × r_EF
            # v_D = 0 (punto fijo)
            
            J2 = np.array([
                [-self.L_DE * np.sin(theta_DE), -self.L_EF * np.sin(theta_EF)],
                [self.L_DE * np.cos(theta_DE), self.L_EF * np.cos(theta_EF)]
            ])
            
            b2 = v_F
            
            try:
                velocidades_angulares_2 = np.linalg.solve(J2, b2)
                omega_DE = velocidades_angulares_2[0]
                omega_EF = velocidades_angulares_2[1]
            except:
                return 0.0, np.array([0.0, 0.0])
            
            # Velocidad de E
            v_E = omega_DE * self.L_DE * np.array([-np.sin(theta_DE), np.cos(theta_DE)])
            
            # Circuito cerrado E-F-G-E para encontrar ω_FG y ω_EG
            # v_F + ω_FG × r_FG = v_E + ω_EG × r_EG
            
            J3 = np.array([
                [-self.L_FG * np.sin(theta_FG), self.L_EG * np.sin(theta_EG)],
                [self.L_FG * np.cos(theta_FG), -self.L_EG * np.cos(theta_EG)]
            ])
            
            b3 = v_E - v_F
            
            try:
                velocidades_angulares_3 = np.linalg.solve(J3, b3)
                omega_FG = velocidades_angulares_3[0]
                omega_EG = velocidades_angulares_3[1]
            except:
                # Método alternativo: usar solo v_G = v_F + ω_FG × r_FG
                omega_FG = 0
            
            # Velocidad del punto G
            v_G = v_F + omega_FG * self.L_FG * np.array([-np.sin(theta_FG), np.cos(theta_FG)])
            
            # Magnitud de la velocidad
            velocidad_magnitud = np.linalg.norm(v_G)
            
            return velocidad_magnitud, v_G
            
        except Exception as e:
            return 0.0, np.array([0.0, 0.0])
    
    def graficar_interactivo(self):
        """Grafica el mecanismo con un slider interactivo para cambiar el ángulo"""
        # Configurar estilo oscuro
        plt.style.use('dark_background')
        
        fig = plt.figure(figsize=(18, 12))
        fig.patch.set_facecolor('#1e1e1e')
        
        # Crear grid para layout - aumentar rowspan para que la gráfica sea más grande
        ax = plt.subplot2grid((10, 1), (0, 0), rowspan=9)
        ax.set_facecolor('#2d2d2d')
        
        plt.subplots_adjust(bottom=0.12, left=0.06, right=0.96, top=0.97)
        
        # Variables para animación
        self.animando = False
        self.angulo_actual = 0
        self.velocidad_angular = 0.1  # rad/s
        self.anim = None
        
        # Slider de ángulo
        ax_slider = fig.add_axes((0.15, 0.08, 0.7, 0.02))
        ax_slider.set_facecolor('#3d3d3d')
        slider = Slider(ax_slider, 'Ángulo (°)', 0, 360, valinit=0, valstep=1,
                       color='#00aaff', track_color='#3d3d3d')
        
        # TextBox para velocidad angular
        ax_textbox = fig.add_axes((0.12, 0.04, 0.10, 0.03))
        ax_textbox.set_facecolor('#3d3d3d')
        textbox_vel = TextBox(ax_textbox, 'ω (rad/s):', initial='0.100', 
                             color='#3d3d3d', hovercolor='#4d4d4d', 
                             label_pad=0.01)
        # Estilizar el texto del label
        textbox_vel.label.set_color('#00ff88')
        textbox_vel.label.set_fontweight('bold')
        textbox_vel.label.set_fontsize(10)
        
        # Variable para guardar el valor temporal del textbox
        self.velocidad_temp = 0.1
        
        # Botones de control con mejor diseño
        btn_width = 0.08
        btn_height = 0.035
        btn_y = 0.03
        
        ax_update_vel = fig.add_axes((0.24, btn_y, 0.12, btn_height))
        ax_play = fig.add_axes((0.38, btn_y, btn_width, btn_height))
        ax_pause = fig.add_axes((0.48, btn_y, btn_width, btn_height))
        ax_reset = fig.add_axes((0.58, btn_y, btn_width, btn_height))
        
        # Estilizar botones
        btn_update_vel = Button(ax_update_vel, '✓ Actualizar ω', color='#00aa88', hovercolor='#00dd99')
        btn_play = Button(ax_play, '▶ Play', color='#00aa44', hovercolor='#00dd66')
        btn_pause = Button(ax_pause, '⏸ Pausa', color='#ff8800', hovercolor='#ffaa33')
        btn_reset = Button(ax_reset, '↺ Reset', color='#0088dd', hovercolor='#00aaff')
        
        # Calcular trayectoria completa del pie
        angulos_trayectoria = np.linspace(0, 2*np.pi, 360)
        trayectoria_pie = []
        for ang in angulos_trayectoria:
            try:
                pts = self.calcular_posiciones(ang)
                trayectoria_pie.append(pts['G'])
            except:
                pass
        trayectoria_pie = np.array(trayectoria_pie)
        
        def actualizar(theta_grados):
            ax.clear()
            ax.set_facecolor('#2d2d2d')
            ax.set_aspect('equal')
            ax.grid(True, alpha=0.2, color='#555555', linestyle='--', linewidth=0.5)
            ax.axhline(y=0, color='#888888', linewidth=0.8, alpha=0.5)
            ax.axvline(x=0, color='#888888', linewidth=0.8, alpha=0.5)
            
            theta_OA = np.deg2rad(theta_grados)
            
            try:
                puntos = self.calcular_posiciones(theta_OA)
            except:
                ax.text(0.5, 0.5, f'❌ Error al resolver para {theta_grados}°', 
                       transform=ax.transAxes, ha='center', va='center', fontsize=14, color='#ff4444')
                fig.canvas.draw_idle()
                return
            
            # Calcular velocidad del punto G
            vel_magnitud, vel_vector = self.calcular_velocidad_G(theta_OA, self.velocidad_angular)
            
            self._dibujar_mecanismo(ax, puntos, theta_grados, trayectoria_pie)
            
            # Información adicional en la esquina superior derecha
            G = puntos['G']
            en_contacto = abs(G[1]) < 0.5  # Considera contacto si está cerca del suelo (y ≈ 0)
            
            vel_info = f"ω = {self.velocidad_angular:.3f} rad/s\n"
            vel_info += f"v_G = {vel_magnitud:.3f} cm/s"
            if en_contacto:
                vel_info += " ⚠ CONTACTO"
            
            ax.text(0.98, 0.02, vel_info, transform=ax.transAxes,
                   fontsize=11, ha='right', va='bottom',
                   bbox=dict(boxstyle='round,pad=0.5', facecolor='#3d3d3d', 
                            edgecolor='#00ff88' if not en_contacto else '#ffaa00', 
                            linewidth=2, alpha=0.9),
                   color='#00ff88' if not en_contacto else '#ffaa00', 
                   fontweight='bold')
            
            fig.canvas.draw_idle()
        
        def animar(frame):
            if self.animando:
                # Convertir velocidad angular (rad/s) a grados, asumiendo ~30 fps
                delta_grados = np.rad2deg(self.velocidad_angular) * (1/30)
                self.angulo_actual = (self.angulo_actual + delta_grados) % 360
                slider.set_val(self.angulo_actual)
                return []
            return []
        
        def guardar_velocidad_temp(text):
            # Solo guarda el valor temporalmente cuando se escribe
            try:
                val = float(text)
                if 0.01 <= val <= 5.0:
                    self.velocidad_temp = val
                else:
                    print(f"⚠️ Velocidad fuera de rango (0.01-5.0 rad/s): {val}")
            except ValueError:
                print(f"⚠️ Valor inválido para velocidad: {text}")
        
        def actualizar_velocidad(event):
            # Aplica la velocidad temporal cuando se presiona el botón
            self.velocidad_angular = self.velocidad_temp
            print(f"✓ Velocidad actualizada a: {self.velocidad_angular:.3f} rad/s")
        
        def play(event):
            self.animando = True
            if self.anim is None:
                self.anim = FuncAnimation(fig, animar, interval=30, blit=True)
        
        def pause(event):
            self.animando = False
        
        def reset(event):
            self.animando = False
            self.angulo_actual = 0
            slider.set_val(0)
        
        # Conectar eventos
        slider.on_changed(actualizar)
        textbox_vel.on_submit(guardar_velocidad_temp)
        textbox_vel.on_text_change(guardar_velocidad_temp)
        btn_update_vel.on_clicked(actualizar_velocidad)
        btn_play.on_clicked(play)
        btn_pause.on_clicked(pause)
        btn_reset.on_clicked(reset)
        
        # Dibujar configuración inicial
        actualizar(0)
        
        # Título principal con mejor estilo
        fig.suptitle('🤖 Mecanismo Theo Jansen Modificado - Simulador Interactivo',
                    fontsize=16, fontweight='bold', color='#00aaff', y=0.98)
        
        plt.show()
    
    def _dibujar_mecanismo(self, ax, puntos, theta_grados, trayectoria_pie=None):
        """Método auxiliar para dibujar el mecanismo"""
        O, A, B, C, D, E, F, G = [puntos[k] for k in ['O', 'A', 'B', 'C', 'D', 'E', 'F', 'G']]
        
        # Paleta de colores moderna
        color_trayectoria = '#00ffff'
        color_fijos = '#ffff00'
        color_manivela = '#ff4444'
        color_eslabones = ['#4488ff', '#44ff88', '#ff88ff', '#ffaa44', '#88ffff', '#ff88aa']
        
        # Dibujar trayectoria del pie con efecto brillante
        if trayectoria_pie is not None and len(trayectoria_pie) > 0:
            ax.plot(trayectoria_pie[:, 0], trayectoria_pie[:, 1], 
                   color=color_trayectoria, linewidth=2, alpha=0.3, linestyle='--',
                   label='Trayectoria completa', zorder=1)
            # Añadir puntos en la trayectoria para efecto
            ax.scatter(trayectoria_pie[::30, 0], trayectoria_pie[::30, 1], 
                      color=color_trayectoria, s=10, alpha=0.5, zorder=1)
        
        # Dibujar armazón (puntos fijos) con efecto de anclaje
        ax.plot([self.O[0], self.C[0]], [self.O[1], self.C[1]], 
                color='#555555', linewidth=2, linestyle=':', alpha=0.5, zorder=2)
        ax.plot([self.O[0], self.D[0]], [self.O[1], self.D[1]], 
                color='#555555', linewidth=2, linestyle=':', alpha=0.5, zorder=2)
        
        ax.scatter([self.O[0], self.C[0], self.D[0]], 
                  [self.O[1], self.C[1], self.D[1]], 
                  color=color_fijos, s=200, marker='s', 
                  edgecolors='white', linewidths=2, zorder=5,
                  label='Puntos fijos')
        
        # OA - Manivela (con grosor variable)
        ax.plot([O[0], A[0]], [O[1], A[1]], color=color_manivela, 
                linewidth=6, label=f'OA = {self.L_OA} cm (manivela)', 
                solid_capstyle='round', zorder=4)
        
        # Eslabones con colores distintivos
        eslabones = [
            ([A[0], F[0]], [A[1], F[1]], f'AFB = 7.34 cm', 0),
            ([B[0], C[0]], [B[1], C[1]], f'BC = {self.L_BC} cm', 1),
            ([D[0], E[0]], [D[1], E[1]], f'DE = {self.L_DE} cm', 2),
            ([E[0], F[0]], [E[1], F[1]], f'EF = {self.L_EF} cm', 3),
            ([F[0], G[0]], [F[1], G[1]], f'FG = {self.L_FG} cm', 4),
            ([E[0], G[0]], [E[1], G[1]], f'EG = {self.L_EG} cm', 5),
        ]
        
        for x, y, label, idx in eslabones:
            ax.plot(x, y, color=color_eslabones[idx], linewidth=4, 
                   label=label, solid_capstyle='round', zorder=3)
        
        # Triángulo EFG con gradiente visual
        triangle = Polygon([E, F, G], alpha=0.15, color='#00ffff', 
                          edgecolor='#00ffff', linewidth=2, zorder=2)
        ax.add_patch(triangle)
        
        # Marcar puntos móviles con estilo
        puntos_moviles = {'A': A, 'B': B, 'E': E, 'F': F}
        for nombre, punto in puntos_moviles.items():
            ax.scatter(punto[0], punto[1], color='white', s=100, 
                      edgecolors='black', linewidths=2, zorder=6)
            ax.text(punto[0]+0.3, punto[1]+0.3, nombre, fontsize=11, 
                   fontweight='bold', color='white', zorder=7,
                   bbox=dict(boxstyle='circle', facecolor='#3d3d3d', 
                            edgecolor='white', alpha=0.7, pad=0.3))
        
        # Etiquetar puntos fijos con mejor contraste
        for nombre, punto, offset in [('O', O, (-0.5, -0.5)), 
                                       ('C', C, (-0.5, -0.5)), 
                                       ('D', D, (0.3, 0.3))]:
            ax.text(punto[0]+offset[0], punto[1]+offset[1], nombre, 
                   fontsize=12, fontweight='bold', color=color_fijos, zorder=7,
                   bbox=dict(boxstyle='round', facecolor='#1e1e1e', 
                            edgecolor=color_fijos, alpha=0.8, pad=0.4))
        
        # Marcar el pie con efecto especial
        ax.scatter(G[0], G[1], color='#ffff00', s=400, marker='*', 
                  edgecolors='#ff8800', linewidths=3, zorder=8,
                  label='G (PIE)')
        # Añadir círculo alrededor del pie
        circle = Circle((G[0], G[1]), 0.3, color='#ffff00', 
                       fill=False, linewidth=2, linestyle='--', 
                       alpha=0.5, zorder=7)
        ax.add_patch(circle)
        
        # Panel de información con mejor diseño
        info_text = f"θ = {theta_grados:6.1f}°\n"
        info_text += f"Pie: ({G[0]:5.2f}, {G[1]:5.2f}) cm\n"
        altura_pie = G[1]
        info_text += f"h = {altura_pie:5.2f} cm"
        
        ax.text(0.02, 0.98, info_text, transform=ax.transAxes, 
                fontsize=11, verticalalignment='top', family='monospace',
                bbox=dict(boxstyle='round,pad=0.8', facecolor='#3d3d3d', 
                         edgecolor='#00aaff', linewidth=2, alpha=0.9),
                color='#ffffff')
        
        # Configuración de ejes con mejor estilo
        ax.set_xlabel('X (cm)', fontsize=13, fontweight='bold', color='#aaaaaa')
        ax.set_ylabel('Y (cm)', fontsize=13, fontweight='bold', color='#aaaaaa')
        ax.set_title('Configuración 7 Barras | 3 Puntos Fijos', 
                    fontsize=12, color='#888888', pad=10)
        
        # Leyenda con mejor diseño - ubicación centro derecha para no tapar nada
        legend = ax.legend(loc='center right', fontsize=9, framealpha=0.9,
                          facecolor='#2d2d2d', edgecolor='#555555', 
                          labelcolor='#cccccc', bbox_to_anchor=(0.99, 0.5))
        legend.get_frame().set_linewidth(1.5)
        
        # Calcular límites automáticos basados en todos los puntos del mecanismo
        if trayectoria_pie is not None and len(trayectoria_pie) > 0:
            # Considerar trayectoria del pie
            x_min, x_max = trayectoria_pie[:, 0].min(), trayectoria_pie[:, 0].max()
            y_min, y_max = trayectoria_pie[:, 1].min(), trayectoria_pie[:, 1].max()
            
            # Considerar todos los puntos del mecanismo actual
            todos_puntos = np.array([O, A, B, C, D, E, F, G])
            x_min = min(x_min, todos_puntos[:, 0].min())
            x_max = max(x_max, todos_puntos[:, 0].max())
            y_min = min(y_min, todos_puntos[:, 1].min())
            y_max = max(y_max, todos_puntos[:, 1].max())
            
            # Añadir margen del 20% para mejor visualización
            x_margin = (x_max - x_min) * 0.20
            y_margin = (y_max - y_min) * 0.20
            
            x_min -= x_margin
            x_max += x_margin
            y_min -= y_margin
            y_max += y_margin
            
            ax.set_xlim(x_min, x_max)
            ax.set_ylim(y_min, y_max)
        else:
            # Límites por defecto si no hay trayectoria
            ax.set_xlim(-12, 8)
            ax.set_ylim(-5, 12)
        
        ax.tick_params(colors='#888888', labelsize=10)
    
    def verificar_colinealidad(self, P1, P2, P3, tolerancia=0.1):
        """Verifica si tres puntos son colineales"""
        # Área del triángulo formado por los 3 puntos
        area = 0.5 * abs((P2[0] - P1[0]) * (P3[1] - P1[1]) - (P3[0] - P1[0]) * (P2[1] - P1[1]))
        return "SÍ" if area < tolerancia else f"NO (área={area:.3f})"

if __name__ == "__main__":
    print("\n" + "="*70)
    print("🤖  SIMULADOR THEO JANSEN - UI MEJORADO CON MODO OSCURO  🤖")
    print("="*70)
    print("\n📋 CONTROLES DISPONIBLES:")
    print("  ▶ Play          : Iniciar animación automática")
    print("  ⏸ Pausa         : Detener animación")
    print("  ↺ Reset         : Volver a ángulo 0°")
    print("  ✓ Actualizar ω  : Aplicar velocidad angular ingresada")
    print("  Slider θ        : Control manual del ángulo (0-360°)")
    print("  TextBox ω       : Ingresar velocidad angular (0.01-5.0 rad/s)")
    print("\n📊 CARACTERÍSTICAS:")
    print("  • Trayectoria completa del pie (cyan)")
    print("  • Información en tiempo real de posición y altura")
    print("  • Visualización de 7 barras y 3 puntos fijos")
    print("  • Tema oscuro profesional")
    print("="*70 + "\n")
    
    mecanismo = MecanismoVerificacion()
    mecanismo.graficar_interactivo()
