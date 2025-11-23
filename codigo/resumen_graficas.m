% Script de resumen gráfico completo para mecanismo Theo Jansen
% Universidad Militar Nueva Granada - Dinámica Aplicada
% Fecha: 2025-11-22

clear; clc;

% Ejecutar análisis cinemático
fprintf('Ejecutando análisis cinemático...\n');
run('main_cinematica.m');

% Ejecutar análisis cinético
fprintf('Ejecutando análisis cinético...\n');
run('main_cinetica.m');

% Crear resumen de todas las gráficas generadas
fprintf('\n=== GRÁFICAS GENERADAS ===\n');
fprintf('1. trayectorias_patas.png - Trayectorias de las 8 patas\n');
fprintf('2. velocidad_patas.png - Velocidad lineal del punto G\n');
fprintf('3. aceleracion_patas.png - Aceleración lineal del punto G\n');
fprintf('4. fuerzas_articulaciones.png - Fuerza total en articulaciones\n');
fprintf('5. torque_motor.png - Torque requerido en el motor\n');
fprintf('6. potencia_instantanea.png - Potencia instantánea requerida\n');

fprintf('\n=== ARCHIVOS LISTOS PARA INFORME ===\n');
fprintf('Todas las gráficas se han guardado en formato PNG de alta resolución (300 DPI)\n');
fprintf('Los archivos están listos para ser incluidos en el informe técnico LaTeX\n');