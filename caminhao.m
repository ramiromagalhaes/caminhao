%Este é o script principal que produz resultados para o problema mencionado
%abaixo.
%
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
max_iteracoes = 10000;

%distancia contada a partir das paredes do estacionamento nas quais o
%caminhao pode ser colocado aleatoriamente.
padding = ceil(delta*(cosd(30) + cosd(60)));

%==========================================================================
%Lendo a descricao do sistema de inferencia fuzzy do caminhao.
%==========================================================================

fis = readfis('caminhao.fis');

%==========================================================================
%Algumas preparações e iniciações para a simulação
%==========================================================================

%preparando o gerador de números aleatórios
rng('shuffle');
rand_settings = rng();
fprintf('Semente do gerador de números aleatórios %d.\n', rand_settings.Seed);

%momento de inicio da simulacao
tempo_inicial = clock();
fprintf('Iniciando simulação em %s \n', datestr(tempo_inicial));

%iniciando arquivo de saida
file_name = get_output_file_name(tempo_inicial, rand_settings.Seed);
fd = fopen(file_name,'w');
fprintf(fd,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',...
           'xi','yi','phii','delta','xf','yf','phif','sucesso','passos','err_x','err_y','err_phi','EE','ET');

%==========================================================================
%Feitas todas as definicoes iniciais, vamos ao que interessa.
%==========================================================================

simula_estacionamento(delta, xmeta, ymeta, phimeta, erro, max_iteracoes, estacionamento, padding, universo_phi, fis, fd);

%==========================================================================
%Liberando recursos alocados e finalizando o resultado
%==========================================================================

fclose(fd);

tempo_final = clock();
fprintf('Simulação concluida em %s.\n', datestr(tempo_final));

%Linux only. Para facilitar a leitura do arquivo pelo BROffice. Isso
%substitui pontos por vírgulas no arquivo de saída.
system(['sed -i ''s/\./\,/g'' ' file_name]);
