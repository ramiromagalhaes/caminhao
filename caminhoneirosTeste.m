function [x,fval,exitflag,output,population,score] = caminhoneirosTeste()
    % Otimização através de AG das regras de controle do caminhão.

    % =====================================================================
    % Configuração para o algoritmo genético. Para mais detalhes, consulte
    % 'help gaoptimset'.
    % =====================================================================

    % Opções padrão para o algoritmo genético
    options = gaoptimset;

    % =====================================================================
    % As opções a seguir são ignoradas pois ao menos uma das variáveis a
    % otimizar é inteira.
    % =====================================================================

    % Mutação: elementos do vetor são selecionados aleatoriamente e a eles
    % são atribuídos valores aleatórios que respeitem a restrição do
    % problema. Taxa de mutação padrão: 1%.
    % options = gaoptimset(options,'MutationFcn', @mutationuniform);

    % Crossover: Scattered. Cria aleatoriamente um vetor como máscara e
    % combina os genes de acordo com a máscara.
    % options = gaoptimset(options,'CrossoverFcn', @crossoverscattered);

    % Selection Function: roulette. Método de seleção da roleta.
    % options = gaoptimset(options,'SelectionFcn', @selectionroulette);

    % =====================================================================
    % As funções abaixo não são ignoradas.
    % =====================================================================

    % Fitness Scaling Function: Proportinal. Torna a expectativa de seleção
    % de um indivíduo proporcional ao seu fitness.
    options = gaoptimset(options,'FitnessScalingFcn', @fitscalingprop);

    % Elitismo: 2 melhores permanecem.
    options = gaoptimset(options,'EliteCount',2);
    
    % Reprodução: 80% da população (16) será gerada a partir de crossover.

    % Migração: 20% (4) dos melhores indivíduos de n-ésima geração são
    % copiados para a (n+1)-ésima geração. Isso ocorre de 20 em 20
    % gerações.

    % Parâmetros das restrições: ???

    % Hybrid function: nenhuma, ou seja, nada a otimizar depois dessa
    % otimização.

    % Critério de parada: todas padronizadas.

    % Gráficos a plotar ao longo da simulação. @gaplotbestf plota um
    % gráfico com o melhor fitness e o fitness médio por geração.
    % @gaplotrange faz o mesmo, mas apresenta também o pior fitness.
    options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotrange });
  
    % definindo uma popula��o de 20 indiv�duos, pois a execu��o com 100
    % estava muito longa
    options = gaoptimset(options,'PopulationSize',20);
     
    %definindo o m�ximo de gera��es
    options = gaoptimset(options,'Generations',50);
    
            
    % Função chamada a cada iteração com informações sobre o andamento da
    % otimização.
    options = gaoptimset(options,'OutputFcn',{@funcaoOutput});

    % Exibe informações no console do MATLAB, no caso, a cada iteração.
    options = gaoptimset(options,'Display', 'iter');

    % Quem pode, usa processamento paralelo...
    options = gaoptimset(options,'UseParallel', 'always');

    % =====================================================================
    % Parâmetros adicionais
    % =====================================================================

    % Quantide de incógnitas do problema.
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
    % vari�vel final_pop salva a ultima popula��o para reutiliza��o numa pr�xima simula��o
        
    % testa o fra��o de crossover
       record=[];
       for n=0:.05:1
        options = gaoptimset(options,'CrossoverFraction', n);
        [x, fval, reason, output, final_pop] =  ...
         ga(@fitness,qtd_incognitas,[],[],[],[],lb,ub,[],integers,options);
        record = [record; fval];
       end
       
       clf;
       plot(0:.05:1, record,'*-')
       xlabel('Fra��o de Crossover');
       ylabel('Fitness')
 
        
     
   
end






