function [state, options,optchanged] = funcaoOutput(options,state,flag)
% Função para tratar as saidas do algoritmo genético
%   [STATE, OPTIONS, OPTCHANGED] = GAOUTPUTFCNTEMPLATE(OPTIONS,STATE,FLAG)
%   where OPTIONS is an options structure used by GA. 
%
%   STATE: A structure containing the following information about the state 
%   of the optimization:
%             Population: Population in the current generation
%                  Score: Scores of the current population
%             Generation: Current generation number
%              StartTime: Time when GA started 
%               StopFlag: String containing the reason for stopping
%              Selection: Indices of individuals selected for elite,
%                         crossover and mutation
%            Expectation: Expectation for selection of individuals
%                   Best: Vector containing the best score in each generation
%        LastImprovement: Generation at which the last improvement in
%                         fitness value occurred
%    LastImprovementTime: Time at which last improvement occurred
%
%   FLAG: Current state in which OutputFcn is called. Possible values are:
%         init: initialization state 
%         iter: iteration state
%    interrupt: intermediate state
%         done: final state
% 		
%   STATE: Structure containing information about the state of the
%          optimization.
%
%   OPTCHANGED: Boolean indicating if the options have changed.
%

optchanged = false;


%Opções da variavel state
%Population — Population in the current generation
%Score — Scores of the current population
%Generation — Current generation number
%StartTime — Time when genetic algorithm started
%StopFlag — String containing the reason for stopping
% Selection — Indices of individuals selected for elite, crossover and mutation
% Expectation — Expectation for selection of individuals
% Best — Vector containing the best score in each generation
% LastImprovement — Generation at which the last improvement in fitness value occurred
% LastImprovementTime — Time at which last improvement occurred
% NonlinIneq — Nonlinear inequality constraints, displayed only when a nonlinear constraint function is specified
% NonlinEq — Nonlinear equality constraints, displayed only when a nonlinear constraint function is specified

switch flag
    % Plot initialization
    case 'init'
         disp('Starting the algorithm');       
       
    case 'iter'
        disp('Imprimindo o best fitness da geração atual');
        disp(state.Best(state.Generation));
        
        %buscando o individuo de menor fitness
        best = state.Best(state.Generation);
        posicao = find(state.Score==best);        
        disp('Imprimindo a linha que gerou o best fitness');
        disp(state.Population(posicao,:));
        
    case 'done'
        disp('Imprimindo os best fitness de cada geração');
        disp(state.Best);
        
end

