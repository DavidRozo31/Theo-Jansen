% Script principal de análisis cinemático para mecanismo Theo Jansen (8 patas)
% Universidad Militar Nueva Granada - Dinámica Aplicada
% Fecha: 2025-11-22

clear; clc;

% Parámetros geométricos del mecanismo (unidades: cm)
L_OA = 1.0;
L_AB = 3.0;
L_BF = 4.34;
L_BC = 2.28;
L_DE = 3.8;
L_EF = 3.7;
L_FG = 5.65;
L_EG = 9.1;

% Puntos fijos
O = [0, 0];
C = [-4.3, -1.2];
D = [-2, 1.3];

n_patas = 8;
desfase = 45; % grados

% Ángulo de entrada (manivela)
theta_OA = linspace(0, 360, 361); % grados

% Prealocar trayectorias
trayectorias_G = zeros(length(theta_OA), 2, n_patas);
velocidades_G = zeros(length(theta_OA), 2, n_patas);
aceleraciones_G = zeros(length(theta_OA), 2, n_patas);

omega_OA = 1.0; % rad/s (ejemplo)
alpha_OA = 0.0; % rad/s^2 (ejemplo)

for i = 1:n_patas
    theta_offset = (i-1)*desfase;
    for k = 1:length(theta_OA)
        theta_actual = deg2rad(theta_OA(k) + theta_offset);
        puntos = calcular_posiciones(theta_actual, O, C, D, L_OA, L_AB, L_BF, L_BC, L_DE, L_EF, L_FG, L_EG);
        trayectorias_G(k,:,i) = puntos.G;
        [v_G, ~, ~, ~, ~, ~] = calcular_velocidades(theta_actual, omega_OA, puntos, struct('L_OA',L_OA,'L_AB',L_AB,'L_BF',L_BF,'L_BC',L_BC,'L_DE',L_DE,'L_EF',L_EF,'L_FG',L_FG,'L_EG',L_EG));
        velocidades_G(k,:,i) = v_G;
        [a_G, ~, ~, ~, ~, ~] = calcular_aceleraciones(theta_actual, omega_OA, alpha_OA, puntos, struct('L_OA',L_OA,'L_AB',L_AB,'L_BF',L_BF,'L_BC',L_BC,'L_DE',L_DE,'L_EF',L_EF,'L_FG',L_FG,'L_EG',L_EG));
        aceleraciones_G(k,:,i) = a_G;
    end
end

% Graficar trayectorias de las 8 patas
colores = ['r','b','g','m','c','y','k','r--','b--','g--'];
fig1 = figure('Position', [100, 100, 1200, 800]);
hold on;
for i = 1:n_patas
    color_idx = mod(i-1, length(colores)) + 1;
    plot(trayectorias_G(:,1,i), trayectorias_G(:,2,i), colores(color_idx), 'LineWidth', 2);
end
xlabel('X [cm]', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Y [cm]', 'FontSize', 12, 'FontWeight', 'bold');
title('Trayectorias de las 8 patas (desfase 45°)', 'FontSize', 14, 'FontWeight', 'bold');
grid on; grid minor;
legend(arrayfun(@(x) sprintf('Pata %d',x), 1:n_patas, 'UniformOutput', false), 'Location', 'best');
axis equal;
hold off;
saveas(fig1, 'trayectorias_patas.png');
print(fig1, 'trayectorias_patas.png', '-dpng', '-r300');

% Graficar velocidad lineal de G (módulo)
fig2 = figure('Position', [100, 100, 1200, 800]);
hold on;
for i = 1:n_patas
    v_mod = sqrt(sum(velocidades_G(:,:,i).^2,2));
    color_idx = mod(i-1, length(colores)) + 1;
    plot(theta_OA, v_mod, colores(color_idx), 'LineWidth', 2);
end
xlabel('\theta_{OA} [°]', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('|v_G| [cm/s]', 'FontSize', 12, 'FontWeight', 'bold');
title('Velocidad lineal del punto G (8 patas)', 'FontSize', 14, 'FontWeight', 'bold');
grid on; grid minor;
legend(arrayfun(@(x) sprintf('Pata %d',x), 1:n_patas, 'UniformOutput', false), 'Location', 'best');
hold off;
saveas(fig2, 'velocidad_patas.png');
print(fig2, 'velocidad_patas.png', '-dpng', '-r300');

% Graficar aceleración lineal de G (módulo)
fig3 = figure('Position', [100, 100, 1200, 800]);
hold on;
for i = 1:n_patas
    a_mod = sqrt(sum(aceleraciones_G(:,:,i).^2,2));
    color_idx = mod(i-1, length(colores)) + 1;
    plot(theta_OA, a_mod, colores(color_idx), 'LineWidth', 2);
end
xlabel('\theta_{OA} [°]', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('|a_G| [cm/s^2]', 'FontSize', 12, 'FontWeight', 'bold');
title('Aceleración lineal del punto G (8 patas)', 'FontSize', 14, 'FontWeight', 'bold');
grid on; grid minor;
legend(arrayfun(@(x) sprintf('Pata %d',x), 1:n_patas, 'UniformOutput', false), 'Location', 'best');
hold off;
saveas(fig3, 'aceleracion_patas.png');
print(fig3, 'aceleracion_patas.png', '-dpng', '-r300');

% === RESUMEN PARA INFORME ===
xG = trayectorias_G(:,1,:); yG = trayectorias_G(:,2,:);
xGmax = max(xG(:)); xGmin = min(xG(:));
yGmax = max(yG(:)); yGmin = min(yG(:));
v_mod = sqrt(sum(velocidades_G.^2,2));
vmax = max(v_mod(:)); vmin = min(v_mod(:));
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
