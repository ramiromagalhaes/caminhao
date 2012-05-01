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
erro = 0.05;

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
padding = ceil(delta*(cos(30) + cos(6)));

%==========================================================================
%Lendo a descricao do sistema de inferencia fuzzy do caminhao.
%==========================================================================

fis = readfis('caminhao');

%==========================================================================
%Feitas todas as definicoes iniciais, vamos ao que interessa.
%==========================================================================

%momento de inicio da simulacao
tempo_inicial = clock();
fprintf('Iniciando simulação em %s \n', datestr(tempo_inicial));

%preparando o gerador de números aleatórios
rng('shuffle');
rand_settings = rng();
fprintf('Semente do gerador de números aleatórios %d.\n', rand_settings.Seed);

%iniciando arquivo de saida
file_name = get_output_file_name(tempo_inicial, rand_settings.Seed);
fd = fopen(file_name,'w');
fprintf(fd,'%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\t%6s\n',...
           'xi','yi','phii','delta','xf','yf','phif','sucesso','passos','err_x','err_y','err_phi','EE','ET');

%iniciando contador de progresso
progress_bar = waitbar(0, 'Simulando...');

%laco principal
for iteracao = 1:max_iteracoes
    x = rnd_position(xi + padding, xf - padding); %não colocaremos o caminhão colado na parede
    y = rnd_position(yi + padding, 50); %não colocaremos o caminhão colado na parede. O '50' vem das restrições do problema original
    phi = rnd_position(phii, phif);
    resultado = estaciona(x, y, phi, delta, xmeta, ymeta, phimeta, erro, [xi, xf, yi, yf], fis);

    %escreve resultados no arquivo
    fprintf(fd,'%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n',...
            x, y, phi, delta, resultado(1),resultado(2),resultado(3),resultado(4),resultado(5),...
                              resultado(6),resultado(7),resultado(8),resultado(9),resultado(10));

    %atualiza contador de progresso.
    waitbar(iteracao/max_iteracoes, progress_bar);
end

fclose(fd);
close(progress_bar);

tempo_final = clock();
duracao = tempo_final - tempo_inicial;
fprintf('Simulação concluida em %s.\n', datestr(tempo_final));

%Linux only. Para facilitar a leitura do arquivo pelo BROffice. Isso
%substitui pontos por vírgulas no arquivo de saída.
system(['sed -i ''s/\./\,/g'' ' file_name]);
