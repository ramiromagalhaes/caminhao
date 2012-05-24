function [state,options,optchanged] = funcaoOutput(options,state,flag)
    % Funcaoo para tratar as saidas do algoritmo genetico
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

    optchanged = false;

    fprintf('Melhor individuo da geração %d:\n', state.Generation);
    [score, index] = min(state.Score);
    disp( state.Population(index, :) );

    switch flag
        % Plot initialization
        case 'init'
             %isso ocorre após a avaliação da primeira população

        case 'iter'
            %isso ocorre a cada iteração

        case 'done'
            %isso ocorre ao fim da otimização
    end

end
