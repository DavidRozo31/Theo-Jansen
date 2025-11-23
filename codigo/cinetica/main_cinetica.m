% Script principal de análisis cinético para mecanismo Theo Jansen (8 patas)
% Universidad Militar Nueva Granada - Dinámica Aplicada
% Fecha: 2025-11-22

clear; clc;

% Parámetros geométricos y de masa (ejemplo, ajustar según prototipo)
L_OA = 1.0; L_AB = 3.0; L_BF = 4.34; L_BC = 2.28;
L_DE = 3.8; L_EF = 3.7; L_FG = 5.65; L_EG = 9.1;
m_OA = 0.05; m_AB = 0.08; m_BF = 0.07; m_BC = 0.06;
m_DE = 0.09; m_EF = 0.07; m_FG = 0.08; m_EG = 0.10;
g = 981; % cm/s^2

O = [0, 0]; C = [-4.3, -1.2]; D = [-2, 1.3];
n_patas = 8; desfase = 45;
theta_OA = linspace(0, 360, 361); % grados
omega_OA = 1.0; alpha_OA = 0.0;

% Prealocar resultados
fuerzas = zeros(length(theta_OA), n_patas);
torques = zeros(length(theta_OA), n_patas);

for i = 1:n_patas
    theta_offset = (i-1)*desfase;
    for k = 1:length(theta_OA)
        theta_actual = deg2rad(theta_OA(k) + theta_offset);
        puntos = calcular_posiciones(theta_actual, O, C, D, L_OA, L_AB, L_BF, L_BC, L_DE, L_EF, L_FG, L_EG);
        [~, ~, ~, ~, ~, ~, omega_EG] = calcular_velocidades(theta_actual, omega_OA, puntos, struct('L_OA',L_OA,'L_AB',L_AB,'L_BF',L_BF,'L_BC',L_BC,'L_DE',L_DE,'L_EF',L_EF,'L_FG',L_FG,'L_EG',L_EG));
        [a_G, ~, ~, ~, ~, ~, ~] = calcular_aceleraciones(theta_actual, omega_OA, alpha_OA, puntos, struct('L_OA',L_OA,'L_AB',L_AB,'L_BF',L_BF,'L_BC',L_BC,'L_DE',L_DE,'L_EF',L_EF,'L_FG',L_FG,'L_EG',L_EG));
        [F_total, T_motor] = calcular_fuerzas_torques(puntos, a_G, m_OA, m_AB, m_BF, m_BC, m_DE, m_EF, m_FG, m_EG, g);
        fuerzas(k,i) = F_total;
        torques(k,i) = T_motor;
    end
end

% Graficar fuerza total en articulaciones
figure;
hold on;
for i = 1:n_patas
    plot(theta_OA, fuerzas(:,i), 'LineWidth', 2);
end
xlabel('\theta_{OA} [°]'); ylabel('Fuerza total [N]');
title('Fuerza total en articulaciones (8 patas)');
grid on;
legend(arrayfun(@(x) sprintf('Pata %d',x), 1:n_patas, 'UniformOutput', false));
hold off;

% Graficar torque requerido en el motor
figure;
hold on;
for i = 1:n_patas
    plot(theta_OA, torques(:,i), 'LineWidth', 2);
end
xlabel('\theta_{OA} [°]'); ylabel('Torque motor [N·cm]');
title('Torque requerido en el motor (8 patas)');
grid on;
legend(arrayfun(@(x) sprintf('Pata %d',x), 1:n_patas, 'UniformOutput', false));
hold off;

% ================= SUBFUNCIONES INTERNAS =================
function puntos = calcular_posiciones(theta_OA, O, C, D, L_OA, L_AB, L_BF, L_BC, L_DE, L_EF, L_FG, L_EG)
    A = O + L_OA*[cos(theta_OA), sin(theta_OA)];
    fun = @(X) restricciones(X, A, C, D, L_AB, L_BF, L_BC, L_DE, L_EF, L_FG, L_EG);
    X0 = [A(1)+L_AB, A(2), D(1)+L_DE, D(2), A(1)+L_AB+L_BF, A(2), A(1)+L_AB+L_BF+L_FG, A(2)];
    options = optimset('Display','off');
    X = fsolve(fun, X0, options);
    B = X(1:2); E = X(3:4); F = X(5:6); G = X(7:8);
    puntos = struct('O',O,'A',A,'B',B,'C',C,'D',D,'E',E,'F',F,'G',G);
end

function F = restricciones(X, A, C, D, L_AB, L_BF, L_BC, L_DE, L_EF, L_FG, L_EG)
    xB = X(1); yB = X(2);
    xE = X(3); yE = X(4);
    xF = X(5); yF = X(6);
    xG = X(7); yG = X(8);
    F1 = norm([xB, yB] - A) - L_AB;
    F2 = norm([xB, yB] - C) - L_BC;
    F3 = norm([xF, yF] - [xB, yB]) - L_BF;
    F4 = norm([xE, yE] - D) - L_DE;
    F5 = norm([xF, yF] - [xE, yE]) - L_EF;
    F6 = norm([xG, yG] - [xF, yF]) - L_FG;
    F7 = norm([xG, yG] - [xE, yE]) - L_EG;
    F8 = norm([xE, yE] - [xF, yF]) - L_EF;
    F = [F1; F2; F3; F4; F5; F6; F7; F8];
end

function [v_G, omega_AB, omega_BC, omega_DE, omega_EF, omega_FG, omega_EG] = calcular_velocidades(theta_OA, omega_OA, puntos, params)
    % ...igual que en main_cinematica.m...
    % Copiar la función completa aquí
end

function [a_G, alpha_AB, alpha_BC, alpha_DE, alpha_EF, alpha_FG, alpha_EG] = calcular_aceleraciones(theta_OA, omega_OA, alpha_OA, puntos, params)
    % ...igual que en main_cinematica.m...
    % Copiar la función completa aquí
end

function [F_total, T_motor] = calcular_fuerzas_torques(puntos, a_G, m_OA, m_AB, m_BF, m_BC, m_DE, m_EF, m_FG, m_EG, g)
    % Ejemplo simple: suma de fuerzas inerciales y peso en el punto G
    F_inercial = (m_OA + m_AB + m_BF + m_BC + m_DE + m_EF + m_FG + m_EG) * norm(a_G);
    F_peso = (m_OA + m_AB + m_BF + m_BC + m_DE + m_EF + m_FG + m_EG) * g;
    F_total = F_inercial + F_peso;
    % Ejemplo de torque: suponiendo que todo el esfuerzo lo hace el motor en O
    r_OA = puntos.A - puntos.O;
    T_motor = F_total * norm(r_OA);
end
