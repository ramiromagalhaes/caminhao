function [x,fval,exitflag,output,population,score] = caminhoneiros()
    % Otimização através de AG das regras de controle do caminhão.

    % =====================================================================
    % Configuração para o algoritmo genético.
    % =====================================================================

    % Opções padrão para o algoritmo genético
    options = gaoptimset;


    % O que essas fazem?
    %options = gaoptimset(options,'CrossoverFraction', CrossoverFraction_Data);
    %options = gaoptimset(options,'SelectionFcn', @selectionroulette);
    %options = gaoptimset(options,'CrossoverFcn', @crossoverarithmetic);

    % Quem pode, usa processamento paralelo...
    options = gaoptimset(options,'UseParallel', 'always');

    % O que essa faz?
    options = gaoptimset(options,'FitnessScalingFcn', @fitscalingprop);

    % O que essa faz?
    options = gaoptimset(options,'Display', 'iter');

    % Gráficos a plotar ao longo da simulação. @gaplotbestf plota um
    % gráfico com o melhor fitness e o fitness médio por geração.
    % @gaplotrange faz o mesmo, mas apresenta também o pior fitness.
    options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotrange });

    % =====================================================================
    % Parâmetros adicionais
    % =====================================================================

    % quantide de incógnitas do problema.
    qtd_incognitas = 18;

    % Limites para cada variável que busco. Como há 7 formas de virar o
    % volante, representadas pelos números 1 a 7, eu estabeleço estes
    % números como limites inferiores e superiores do meu espaço de busca
    % da resposta ótima.
    lb = ones(1, qtd_incognitas); % Limites inferiores
    ub = 7 * lb; % Limites superiores

    % Quais são as variáveis que busco cujos valores são inteiros? No caso,
    % são todas.
    integers = 1:qtd_incognitas;

    % =====================================================================
    % Execução do algoritmo genético
    % =====================================================================

    % A função 'fitness' referenciada na chamada abaixo deve receber um
    % vetor de doubles de qtd_incognitas posições. É essa função que será
    % usada para calcular o fitness de cada indivíduo da população, em cada
    % iteração.
    [x,fval,exitflag,output,population,score] = ...
        ga(@fitness,qtd_incognitas,[],[],[],[],lb,ub,[],integers,options);

    disp(x)
    disp(fval)
end

