function [x,fval,exitflag,output,population,score] = caminhoneiros()
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = gaoptimset;
%% Modify options setting
%options = gaoptimset(options,'CrossoverFraction', CrossoverFraction_Data);
options = gaoptimset(options,'FitnessScalingFcn', @fitscalingprop);
%options = gaoptimset(options,'SelectionFcn', @selectionroulette);
%options = gaoptimset(options,'CrossoverFcn', @crossoverarithmetic);
options = gaoptimset(options,'Display', 'iter');
options = gaoptimset(options,'UseParallel', 'always');
options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotrange });

lb = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]; %limites inferiores para cada variável que busco
ub = [7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7]; %limites superiores para cada variável que busco

[x,fval,exitflag,output,population,score] = ...
ga(@fitness,18,[],[],[],[],lb,ub,[],[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18],options);
disp(x)
disp(fval)
