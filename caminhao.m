%Problema de estacionar um caminhao
%Livro: Neural Networks and Fuzzy Systems - A Dynamical Systems Approach 
%       to Machine Intelligence cap 9
%       Bart Kosko
%       Ed. Prentice Hall
%==========================================================================

clc;

%==========================================================================
%Universos de discurso
%==========================================================================

%Universo de discurso da dimens�o Y
%Esta variavel nao entra no sistema nebuloso, porque e assumido que
%o patio de manobra tem espaco suficiente para recuos.
yi = 0;
yf = 100;

%Universo de discurso da dimens�o X
xi = 0;
xf = 100;

%Universo de discurso do �ngulo do caminh�o (phi)
% o limite foi definido como [-105, 285] para cobrir eventuais valores fora
% do limite mas os �ngulos variam de [-90,270]
phii = -90;
phif = 270;

%Universo de discurso do �ngulo do volante do caminh�o (teta)
tetai = -30;
tetaf = 30;

%=============================================================================
%Constantes importantes
%=============================================================================

%Sobre o caminh�o
comp_cam = 18; %comprimento do caminhao
larg_cam = 8;  %largura do caminhao

%Sobre a garagem
xmeta = 50; %posi��o X de estacionamento ideal
ymeta = 100; %posi��o Y de estacionamento ideal
phimeta = 90; %�ngulo de estacionamento ideal

%Erro m�ximo admissivel nas metas
erro = 0.05;

%Quantidade de passos que o caminhao anda por itera��o. Equivale � velocidade.
delta = 1;

%=============================================================================
%Vari�veis de interesse
%=============================================================================

%Passos executados at� chegar na garagem
passos = 0;


%=============================================================================
%Lendo a descricao do sistema de inferencia fuzzy do caminhao
%=============================================================================

fis = readfis('caminhao');

%Feitas todas as defini��es iniciais, podemos come�ar a realmente tratar do
%problema.

%inicializando arquivo de sa�da
file_name = get_output_file_name();
fd = fopen(file_name,'w');
fprintf(fd,'%6s %6s %6s %6s %6s %6s %6s %6s %6s %6s\n','x','y','phi',...
 'delta','xf','yf','phif','passos','Erro estacionamento','Erro dist�ncia');

%quantidade de experimentos que faremos
max_iteracoes = 10000;
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

