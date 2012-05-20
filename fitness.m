function f = fitness( gene )

    %==========================================================================
    %Universos de discurso
    %==========================================================================

    %Universo de discurso do estacionamento descrito no formato
    %[x_inicial, x_final, y_inicial, y_final]
    estacionamento = [0, 100, 0, 100];

    %Universo de discurso do angulo do caminhao (phi)
    % o limite foi definido como [-105, 285] para cobrir eventuais valores fora
    % do limite mas os angulos variam de [-90,270]
    universo_phi = [-90 270];

    %Universo de discurso do angulo do volante do caminhao (teta)
    tetai = -30;
    tetaf =  30;

    %==========================================================================
    %Constantes importantes
    %==========================================================================

    %Sobre o caminhao
    comp_cam = 18; %comprimento do caminhao
    larg_cam =  8;  %largura do caminhao

    %Sobre a garagem
    xmeta   =  50; %posiçao X de estacionamento ideal
    ymeta   = 100; %posicao Y de estacionamento ideal
    phimeta =  90; %angulo de estacionamento ideal

    %Erro maximo admissivel nas metas
    erro = 0.04;

    %Quantidade de passos que o caminhao anda por iteracao. E a velocidade.
    delta = 5;

    %==========================================================================
    %Variaveis de interesse.
    %==========================================================================

    %Passos executados ate chegar na garagem
    passos = 0;

    %quantidade de experimentos que faremos
    max_iteracoes = 100;

    %distancia contada a partir das paredes do estacionamento nas quais o
    %caminhao pode ser colocado aleatoriamente.
    padding = ceil(delta*(cosd(30) + cosd(60)));

    fis = readfis('caminhao.fis');
    fis = create_caminhao_fis(fis, gene);

    avaliacao = avalia_resultados ( ...
        simula_estacionamento(delta, xmeta, ymeta, phimeta, erro, max_iteracoes, estacionamento, padding, universo_phi, fis) ...
    );

    %nesse caso o fitness é o percentual de vezes que o caminhão estacionou
    f = 1 - avaliacao(1, 8);
end

