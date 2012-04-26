%Problema de estacionar um caminhao
%Livro: Neural Networks and Fuzzy Systems - A Dynamical Systems Approach 
%       to Machine Intelligence cap 9
%       Bart Kosko
%       Ed. Prentice Hall
%
%
%==========================================================================
%
%
clc;
%
%=============================================================================
%Universos de discurso
%=============================================================================

%Universo de discurso da dimensão Y
%Esta variavel nao entra no sistema nebuloso, porque e assumido que
%o patio de manobra tem espaco suficiente para recuos.
yi = 0;
yf = 100;

%Universo de discurso da dimensão X
xi = 0;
xf = 100;

%Universo de discurso do ângulo do caminhão (phi)
% o limite foi definido como [-105, 285] para cobrir eventuais valores fora
% do limite mas os ângulos variam de [-90,270]
phii = -90;
phif = 270;

%Universo de discurso do ângulo do volante do caminhão (teta)
tetai = -30;
tetaf = 30;

%=============================================================================
%Constantes importantes
%=============================================================================

%Sobre o caminhão
comp_cam = 18; %comprimento do caminhao
larg_cam = 8;  %largura do caminhao

%Sobre a garagem
xmeta = 50; %posição X de estacionamento ideal
ymeta = 100; %posição Y de estacionamento ideal
phimeta = 90; %ângulo de estacionamento ideal

%Erro máximo admissivel nas metas
erro = 0.05;

%Quantidade de passos que o caminhao anda por iteração. Equivale à velocidade.
delta = 1;

%=============================================================================
%Variáveis de interesse
%=============================================================================

%Passos executados até chegar na garagem
passos = 0;


%=============================================================================
%Lendo a descricao do sistema de inferencia fuzzy do caminhao
%=============================================================================

fis = readfis('caminhao');

%Feitas todas as definições iniciais, podemos começar a realmente tratar do
%problema.

%inicializando arquivo de saída
fd = fopen('resultado.csv','w');
fprintf(fd,'%6s %6s %6s %6s %6s %6s %6s %6s %6s %6s\n','x','y','phi',...
 'delta','xf','yf','phif','passos','Erro estacionamento','Erro distância');

%quantidade de experimentos que faremos
max_iteracoes = 100000;
iteracoes = 0;
while(iteracoes < max_iteracoes)
    x = rnd_position(xi, xf);
    y = rnd_position(yi, yf);
    phi = rnd_position(phii, phif);
    resultado = estaciona(x, y, phi, delta, xmeta, ymeta, phimeta, erro, [xi, xf, yi, yf], fis);

    %escreve resultados no arquivo    
    fprintf(fd,'%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',...
    x, y, phi, delta,resultado(1), resultado(2), resultado(3), resultado(4),resultado(5),resultado(6));    
        
    iteracoes = iteracoes + 1;
end

fclose(fd);

