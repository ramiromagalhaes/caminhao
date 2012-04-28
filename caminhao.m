%Problema de estacionar um caminhao
%Livro: Neural Networks and Fuzzy Systems - A Dynamical Systems Approach 
%       to Machine Intelligence cap 9
%       Bart Kosko
%       Ed. Prentice Hall
%==========================================================================

clc; %sim, nós gostamos de telas limpas...

%==========================================================================
%Universos de discurso
%==========================================================================

%Universo de discurso da dimensao Y
%Esta variavel nao entra no sistema nebuloso, porque e assumido que
%o patio de manobra tem espaco suficiente para recuos.
yi = 0;
yf = 100;

%Universo de discurso da dimensao X
xi =   0;
xf = 100;

%Universo de discurso do angulo do caminhao (phi)
% o limite foi definido como [-105, 285] para cobrir eventuais valores fora
% do limite mas os angulos variam de [-90,270]
phii = -90;
phif = 270;

%Universo de discurso do angulo do volante do caminhao (teta)
tetai = -30;
tetaf =  30;

%=============================================================================
%Constantes importantes
%=============================================================================

%Sobre o caminhao
comp_cam = 18; %comprimento do caminhao
larg_cam =  8;  %largura do caminhao

%Sobre a garagem
xmeta   =  50; %posiçao X de estacionamento ideal
ymeta   = 100; %posicao Y de estacionamento ideal
phimeta =  90; %angulo de estacionamento ideal

%Erro maximo admissivel nas metas
erro = 0.05;

%Quantidade de passos que o caminhao anda por iteracao. Equivale a velocidade.
delta = 1;

%=============================================================================
%Variaveis de interesse.
%=============================================================================

%Passos executados ate chegar na garagem
passos = 0;

%quantidade de experimentos que faremos
max_iteracoes = 10000;


%=============================================================================
%Lendo a descricao do sistema de inferencia fuzzy do caminhao.
%=============================================================================

fis = readfis('caminhao');

%=============================================================================
%Feitas todas as definicoes iniciais, vamos ao que interessa.
%=============================================================================

%momento de inicio da simulacao
tempo_inicial = clock();
fprintf('\nIniciando simulação em %s \n', datestr(tempo_inicial));

%iniciando arquivo de saida
fd = fopen(get_output_file_name(tempo_inicial),'w');
fprintf(fd,'%6s %6s %6s %6s %6s %6s %6s %6s %6s %6s\n','x','y','phi',...
 'delta','xf','yf','phif','passos','Erro estacionamento','Erro distancia');

%iniciando contador de progresso
progress_bar = waitbar(0, 'Simulando...');

%laco principal
for iteracao = 1:max_iteracoes
    x = rnd_position(xi, xf);
    y = rnd_position(yi, yf);
    phi = rnd_position(phii, phif);
    resultado = estaciona(x, y, phi, delta, xmeta, ymeta, phimeta, erro, [xi, xf, yi, yf], fis);

    %escreve resultados no arquivo    
    fprintf(fd,'%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',...
    x, y, phi, delta,resultado(1), resultado(2), resultado(3), resultado(4),resultado(5),resultado(6));    

	%atualiza contador de progresso.
    waitbar(iteracao/max_iteracoes, progress_bar);
end

fclose(fd);
close(progress_bar);

tempo_final = clock();
duracao = tempo_final - tempo_inicial;
fprintf('Simulação concluida em %s.\n', datestr(tempo_final));

