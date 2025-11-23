% Script resumen cinético: muestra datos clave por consola
clear; clc;

% Parámetros principales
masa_total = 300; % g
L_OA = 1.0; L_AB = 3.0; L_BF = 4.34; L_BC = 2.28;
L_DE = 3.8; L_EF = 3.7; L_FG = 5.65; L_EG = 9.1;
O = [0, 0]; C = [-4.3, -1.2]; D = [-2, 1.3];
n_patas = 8; desfase = 45;
theta_OA = linspace(0, 360, 361); % grados
omega_OA = 1.0; alpha_OA = 0.0;
g = 981; % cm/s^2

fuerzas = zeros(length(theta_OA), n_patas);
torques = zeros(length(theta_OA), n_patas);

for i = 1:n_patas
    theta_offset = (i-1)*desfase;
    for k = 1:length(theta_OA)
        theta_actual = deg2rad(theta_OA(k) + theta_offset);
        puntos = calcular_posiciones(theta_actual, O, C, D, L_OA, L_AB, L_BF, L_BC, L_DE, L_EF, L_FG, L_EG);
        [~, ~, ~, ~, ~, ~, omega_EG] = calcular_velocidades(theta_actual, omega_OA, puntos, struct('L_OA',L_OA,'L_AB',L_AB,'L_BF',L_BF,'L_BC',L_BC,'L_DE',L_DE,'L_EF',L_EF,'L_FG',L_FG,'L_EG',L_EG));
        [a_G, ~, ~, ~, ~, ~, ~] = calcular_aceleraciones(theta_actual, omega_OA, alpha_OA, puntos, struct('L_OA',L_OA,'L_AB',L_AB,'L_BF',L_BF,'L_BC',L_BC,'L_DE',L_DE,'L_EF',L_EF,'L_FG',L_FG,'L_EG',L_EG));
        [F_total, T_motor] = calcular_fuerzas_torques(puntos, a_G, masa_total, g);
        fuerzas(k,i) = F_total;
        torques(k,i) = T_motor;
    end
end

% Conversión de unidades
fuerzas_N = fuerzas * 1e-3 * 1e-2;
torques_Ncm = torques * 1e-3;

Fmax = max(fuerzas_N(:)); Fmin = min(fuerzas_N(:));
Tmax = max(torques_Ncm(:)); Tmin = min(torques_Ncm(:));

V_bateria = 3.7 * 2; % V
I_motor = 2.0;        % A
P_motor = V_bateria * I_motor; % W
capacidad_mAh = 2200; capacidad_total_mAh = capacidad_mAh * 2;
capacidad_total_Ah = capacidad_total_mAh / 1000;
energia_total_Wh = V_bateria * capacidad_total_Ah;
tiempo_autonomia_h = energia_total_Wh / P_motor;

fprintf('--- Resumen cinético Theo Jansen ---\n');
fprintf('Fuerza máxima en articulaciones: %.2f N\n', Fmax);
fprintf('Fuerza mínima en articulaciones: %.2f N\n', Fmin);
fprintf('Torque máximo requerido en motor: %.2f N·cm\n', Tmax);
fprintf('Torque mínimo requerido en motor: %.2f N·cm\n', Tmin);
fprintf('Potencia máxima motor: %.2f W\n', P_motor);
fprintf('Energía total baterías: %.2f Wh\n', energia_total_Wh);
fprintf('Autonomía estimada: %.2f minutos\n', tiempo_autonomia_h*60);

% ================= SUBFUNCIONES INTERNAS =================
function puntos = calcular_posiciones(theta_OA, O, C, D, L_OA, L_AB, L_BF, L_BC, L_DE, L_EF, L_FG, L_EG)
    % ...igual que en main_cinematica.m...
end
function [v_G, omega_AB, omega_BC, omega_DE, omega_EF, omega_FG, omega_EG] = calcular_velocidades(theta_OA, omega_OA, puntos, params)
    % ...igual que en main_cinematica.m...
end
function [a_G, alpha_AB, alpha_BC, alpha_DE, alpha_EF, alpha_FG, alpha_EG] = calcular_aceleraciones(theta_OA, omega_OA, alpha_OA, puntos, params)
    % ...igual que en main_cinematica.m...
end
function [F_total, T_motor] = calcular_fuerzas_torques(puntos, a_G, masa_total, g)
    F_inercial = masa_total * norm(a_G);
    F_peso = masa_total * g;
    F_total = F_inercial + F_peso;
    r_OA = puntos.A - puntos.O;
    T_motor = F_total * norm(r_OA);
end
