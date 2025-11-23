% Script principal de análisis cinético para mecanismo Theo Jansen (8 patas)
% Universidad Militar Nueva Granada - Dinámica Aplicada
% Fecha: 2025-11-22

clear; clc;

% Parámetros geométricos y de masa (ajustados)
L_OA = 1.0; L_AB = 3.0; L_BF = 4.34; L_BC = 2.28;
L_DE = 3.8; L_EF = 3.7; L_FG = 5.65; L_EG = 9.1;

masa_total = 300; % g (0.3 kg)
% Se distribuye entre los eslabones, aquí se usa como masa total para el análisis global
% Motor DC caja reductora amarilla 200 rpm
% Baterías: 2x 3.7V 2200mAh recargables

O = [0, 0]; C = [-4.3, -1.2]; D = [-2, 1.3];
n_patas = 8; desfase = 45;
theta_OA = linspace(0, 360, 361); % grados
omega_OA = 1.0; alpha_OA = 0.0;
g = 981; % cm/s^2

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
        [F_total, T_motor] = calcular_fuerzas_torques(puntos, a_G, masa_total, g);
        fuerzas(k,i) = F_total;
        torques(k,i) = T_motor;
    end
end

% Conversión de unidades
fuerzas_N = fuerzas * 1e-3 * 1e-2; % g·cm/s^2 a N (1 g = 1e-3 kg, 1 cm = 1e-2 m)
torques_Ncm = torques * 1e-3;      % g·cm^2/s^2 a N·cm (1 g·cm^2/s^2 = 1e-3 N·cm)

% Graficar fuerza total en N
colores = ['r','b','g','m','c','y','k','r--','b--','g--'];
fig1 = figure('Position', [100, 100, 1200, 800]);
hold on;
for i = 1:n_patas
    color_idx = mod(i-1, length(colores)) + 1;
    plot(theta_OA, fuerzas_N(:,i), colores(color_idx), 'LineWidth', 2);
end
xlabel('\theta_{OA} [°]', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fuerza total [N]', 'FontSize', 12, 'FontWeight', 'bold');
title('Fuerza total en articulaciones (8 patas)', 'FontSize', 14, 'FontWeight', 'bold');
grid on; grid minor;
legend(arrayfun(@(x) sprintf('Pata %d',x), 1:n_patas, 'UniformOutput', false), 'Location', 'best');
hold off;
saveas(fig1, 'fuerzas_articulaciones.png');
print(fig1, 'fuerzas_articulaciones.png', '-dpng', '-r300');

% Graficar torque requerido en el motor en N·cm
fig2 = figure('Position', [100, 100, 1200, 800]);
hold on;
for i = 1:n_patas
    color_idx = mod(i-1, length(colores)) + 1;
    plot(theta_OA, torques_Ncm(:,i), colores(color_idx), 'LineWidth', 2);
end
xlabel('\theta_{OA} [°]', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Torque motor [N·cm]', 'FontSize', 12, 'FontWeight', 'bold');
title('Torque requerido en el motor (8 patas)', 'FontSize', 14, 'FontWeight', 'bold');
grid on; grid minor;
legend(arrayfun(@(x) sprintf('Pata %d',x), 1:n_patas, 'UniformOutput', false), 'Location', 'best');
hold off;
saveas(fig2, 'torque_motor.png');
print(fig2, 'torque_motor.png', '-dpng', '-r300');

% Graficar potencia instantánea requerida
potencia_inst = torques_Ncm .* repmat(omega_OA * 180/pi * 2*pi/60, 1, n_patas); % W (considerando omega en rad/s)
fig3 = figure('Position', [100, 100, 1200, 800]);
hold on;
for i = 1:n_patas
    color_idx = mod(i-1, length(colores)) + 1;
    plot(theta_OA, potencia_inst(:,i), colores(color_idx), 'LineWidth', 2);
end
xlabel('\theta_{OA} [°]', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Potencia [W]', 'FontSize', 12, 'FontWeight', 'bold');
title('Potencia instantánea requerida (8 patas)', 'FontSize', 14, 'FontWeight', 'bold');
grid on; grid minor;
legend(arrayfun(@(x) sprintf('Pata %d',x), 1:n_patas, 'UniformOutput', false), 'Location', 'best');
hold off;
saveas(fig3, 'potencia_instantanea.png');
print(fig3, 'potencia_instantanea.png', '-dpng', '-r300');

% Estimación de consumo eléctrico del motor
V_bateria = 3.7 * 2; % V (dos baterías en serie)
I_motor = 2.0;       % A (máximo típico motor DC caja reductora amarilla)
P_motor = V_bateria * I_motor; % W
capacidad_mAh = 2200; % mAh por batería
capacidad_total_mAh = capacidad_mAh * 2; % mAh (si están en paralelo)
capacidad_total_Ah = capacidad_total_mAh / 1000; % Ah
energia_total_Wh = V_bateria * capacidad_total_Ah; % Wh

tiempo_autonomia_h = energia_total_Wh / P_motor; % horas

disp(['Potencia máxima motor: ', num2str(P_motor), ' W'])
disp(['Energía total baterías: ', num2str(energia_total_Wh), ' Wh'])
disp(['Autonomía estimada: ', num2str(tiempo_autonomia_h*60), ' minutos'])

% === RESUMEN PARA INFORME ===
fuerzas_N = fuerzas * 1e-3 * 1e-2; % g·cm/s^2 a N
Fmax = max(fuerzas_N(:)); Fmin = min(fuerzas_N(:));
torques_Ncm = torques * 1e-3;      % g·cm^2/s^2 a N·cm
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
    O = puntos.O; A = puntos.A; B = puntos.B; C = puntos.C;
    D = puntos.D; E = puntos.E; F = puntos.F; G = puntos.G;
    L_OA = params.L_OA; L_AB = params.L_AB; L_BF = params.L_BF; L_BC = params.L_BC;
    L_DE = params.L_DE; L_EF = params.L_EF; L_FG = params.L_FG; L_EG = params.L_EG;
    v_A = omega_OA * L_OA * [-sin(theta_OA), cos(theta_OA)];
    vec_AB = B - A; theta_AB = atan2(vec_AB(2), vec_AB(1));
    vec_BC = C - B; theta_BC = atan2(vec_BC(2), vec_BC(1));
    J1 = [ -L_AB*sin(theta_AB), -L_BC*sin(theta_BC);
            L_AB*cos(theta_AB),  L_BC*cos(theta_BC) ];
    b1 = -v_A';
    omegas1 = J1 \ b1;
    omega_AB = omegas1(1); omega_BC = omegas1(2);
    v_F = v_A + omega_AB * (L_AB + L_BF) * [-sin(theta_AB), cos(theta_AB)];
    vec_DE = E - D; theta_DE = atan2(vec_DE(2), vec_DE(1));
    vec_EF = F - E; theta_EF = atan2(vec_EF(2), vec_EF(1));
    J2 = [ -L_DE*sin(theta_DE), -L_EF*sin(theta_EF);
            L_DE*cos(theta_DE),  L_EF*cos(theta_EF) ];
    b2 = v_F';
    omegas2 = J2 \ b2;
    omega_DE = omegas2(1); omega_EF = omegas2(2);
    v_E = omega_DE * L_DE * [-sin(theta_DE), cos(theta_DE)];
    vec_FG = G - F; theta_FG = atan2(vec_FG(2), vec_FG(1));
    vec_EG = G - E; theta_EG = atan2(vec_EG(2), vec_EG(1));
    J3 = [ -L_FG*sin(theta_FG),  L_EG*sin(theta_EG);
            L_FG*cos(theta_FG), -L_EG*cos(theta_EG) ];
    b3 = v_E' - v_F';
    omegas3 = J3 \ b3;
    omega_FG = omegas3(1);
    omega_EG = omegas3(2);
    v_G = v_F + omega_FG * L_FG * [-sin(theta_FG), cos(theta_FG)] + omega_EG * L_EG * [-sin(theta_EG), cos(theta_EG)];
end

function [a_G, alpha_AB, alpha_BC, alpha_DE, alpha_EF, alpha_FG, alpha_EG] = calcular_aceleraciones(theta_OA, omega_OA, alpha_OA, puntos, params)
    O = puntos.O; A = puntos.A; B = puntos.B; C = puntos.C;
    D = puntos.D; E = puntos.E; F = puntos.F; G = puntos.G;
    L_OA = params.L_OA; L_AB = params.L_AB; L_BF = params.L_BF; L_BC = params.L_BC;
    L_DE = params.L_DE; L_EF = params.L_EF; L_FG = params.L_FG; L_EG = params.L_EG;
    v_A = omega_OA * L_OA * [-sin(theta_OA), cos(theta_OA)];
    a_A = alpha_OA * L_OA * [-sin(theta_OA), cos(theta_OA)] - omega_OA^2 * L_OA * [cos(theta_OA), sin(theta_OA)];
    vec_AB = B - A; theta_AB = atan2(vec_AB(2), vec_AB(1));
    vec_BC = C - B; theta_BC = atan2(vec_BC(2), vec_BC(1));
    [~, omega_AB, omega_BC, omega_DE, omega_EF, omega_FG, omega_EG] = calcular_velocidades(theta_OA, omega_OA, puntos, params);
    J1 = [ -L_AB*sin(theta_AB), -L_BC*sin(theta_BC);
            L_AB*cos(theta_AB),  L_BC*cos(theta_BC) ];
    b1 = -a_A' - omega_AB^2 * L_AB * [cos(theta_AB); sin(theta_AB)] - omega_BC^2 * L_BC * [cos(theta_BC); sin(theta_BC)];
    alphas1 = J1 \ b1;
    alpha_AB = alphas1(1); alpha_BC = alphas1(2);
    a_F = a_A + alpha_AB * (L_AB + L_BF) * [-sin(theta_AB), cos(theta_AB)] - omega_AB^2 * (L_AB + L_BF) * [cos(theta_AB), sin(theta_AB)];
    vec_DE = E - D; theta_DE = atan2(vec_DE(2), vec_DE(1));
    vec_EF = F - E; theta_EF = atan2(vec_EF(2), vec_EF(1));
    J2 = [ -L_DE*sin(theta_DE), -L_EF*sin(theta_EF);
            L_DE*cos(theta_DE),  L_EF*cos(theta_EF) ];
    b2 = a_F' - omega_DE^2 * L_DE * [cos(theta_DE); sin(theta_DE)] - omega_EF^2 * L_EF * [cos(theta_EF); sin(theta_EF)];
    alphas2 = J2 \ b2;
    alpha_DE = alphas2(1); alpha_EF = alphas2(2);
    a_E = alpha_DE * L_DE * [-sin(theta_DE), cos(theta_DE)] - omega_DE^2 * L_DE * [cos(theta_DE), sin(theta_DE)];
    vec_FG = G - F; theta_FG = atan2(vec_FG(2), vec_FG(1));
    vec_EG = G - E; theta_EG = atan2(vec_EG(2), vec_EG(1));
    J3 = [ -L_FG*sin(theta_FG),  L_EG*sin(theta_EG);
            L_FG*cos(theta_FG), -L_EG*cos(theta_EG) ];
    b3 = a_E' - a_F' - omega_FG^2 * L_FG * [cos(theta_FG); sin(theta_FG)] - omega_EG^2 * L_EG * [cos(theta_EG); sin(theta_EG)];
    alphas3 = J3 \ b3;
    alpha_FG = alphas3(1);
    alpha_EG = alphas3(2);
    a_G = a_F + alpha_FG * L_FG * [-sin(theta_FG), cos(theta_FG)] - omega_FG^2 * L_FG * [cos(theta_FG), sin(theta_FG)] + alpha_EG * L_EG * [-sin(theta_EG), cos(theta_EG)] - omega_EG^2 * L_EG * [cos(theta_EG), sin(theta_EG)];
end

function [F_total, T_motor] = calcular_fuerzas_torques(puntos, a_G, masa_total, g)
    % Fuerza inercial y peso total
    F_inercial = masa_total * norm(a_G); % g·cm/s^2
    F_peso = masa_total * g; % g·cm/s^2
    F_total = F_inercial + F_peso;
    r_OA = puntos.A - puntos.O;
    T_motor = F_total * norm(r_OA); % g·cm^2/s^2
end
