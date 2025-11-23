% Script resumen cinemático: muestra datos clave por consola
clear; clc;

% Parámetros principales
L_OA = 1.0; L_AB = 3.0; L_BF = 4.34; L_BC = 2.28;
L_DE = 3.8; L_EF = 3.7; L_FG = 5.65; L_EG = 9.1;
O = [0, 0]; C = [-4.3, -1.2]; D = [-2, 1.3];
n_patas = 8; desfase = 45;
theta_OA = linspace(0, 360, 361); % grados
omega_OA = 1.0; alpha_OA = 0.0;

trayectorias_G = zeros(length(theta_OA), 2, n_patas);
velocidades_G = zeros(length(theta_OA), 2, n_patas);
aceleraciones_G = zeros(length(theta_OA), 2, n_patas);

for i = 1:n_patas
    theta_offset = (i-1)*desfase;
    for k = 1:length(theta_OA)
        theta_actual = deg2rad(theta_OA(k) + theta_offset);
        puntos = calcular_posiciones(theta_actual, O, C, D, L_OA, L_AB, L_BF, L_BC, L_DE, L_EF, L_FG, L_EG);
        trayectorias_G(k,:,i) = puntos.G;
        [v_G, ~, ~, ~, ~, ~, ~] = calcular_velocidades(theta_actual, omega_OA, puntos, struct('L_OA',L_OA,'L_AB',L_AB,'L_BF',L_BF,'L_BC',L_BC,'L_DE',L_DE,'L_EF',L_EF,'L_FG',L_FG,'L_EG',L_EG));
        velocidades_G(k,:,i) = v_G;
        [a_G, ~, ~, ~, ~, ~, ~] = calcular_aceleraciones(theta_actual, omega_OA, alpha_OA, puntos, struct('L_OA',L_OA,'L_AB',L_AB,'L_BF',L_BF,'L_BC',L_BC,'L_DE',L_DE,'L_EF',L_EF,'L_FG',L_FG,'L_EG',L_EG));
        aceleraciones_G(k,:,i) = a_G;
    end
end

% Recorrido máximo y mínimo del punto G
xG = trayectorias_G(:,1,:); yG = trayectorias_G(:,2,:);
xGmax = max(xG(:)); xGmin = min(xG(:));
yGmax = max(yG(:)); yGmin = min(yG(:));

% Velocidad máxima y mínima del punto G
v_mod = sqrt(sum(velocidades_G.^2,2));
vmax = max(v_mod(:)); vmin = min(v_mod(:));

% Aceleración máxima y mínima del punto G
a_mod = sqrt(sum(aceleraciones_G.^2,2));
amax = max(a_mod(:)); amin = min(a_mod(:));

fprintf('--- Resumen cinemático Theo Jansen ---\n');
fprintf('Recorrido X de G: %.2f cm a %.2f cm\n', xGmin, xGmax);
fprintf('Recorrido Y de G: %.2f cm a %.2f cm\n', yGmin, yGmax);
fprintf('Velocidad máxima de G: %.2f cm/s\n', vmax);
fprintf('Velocidad mínima de G: %.2f cm/s\n', vmin);
fprintf('Aceleración máxima de G: %.2f cm/s^2\n', amax);
fprintf('Aceleración mínima de G: %.2f cm/s^2\n', amin);

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
