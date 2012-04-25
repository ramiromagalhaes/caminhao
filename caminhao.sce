//Problema de estacionar um caminhao
//Livro: Neural Networks and Fuzzy Systems - A Dynamical Systems Approach
//       to Machine Intelligence cap 9
//       Bart Kosko
//       Ed. Prentice Hall



// Exibir aviso para a exceção de ponto flutuante
ieee(1);

//usar pathconvert para compatibilidade? guardar em uma constante o resultado de
//get_absolute_file_path?
exec(get_absolute_file_path("caminhao.sce") + '/caminhao.sci', -1);
exec(get_absolute_file_path("caminhao.sce") + '/plot_caminhao.sci', -1);



//=============================================================================
//Universos de discurso
//=============================================================================

//Universo de discurso da dimensão Y
//Esta variavel nao entra no sistema nebuloso, porque e assumido que
//o patio de manobra tem espaco suficiente para recuos.
yi =   0;
yf = 100;

//Universo de discurso da dimensão X
xi =   0;
xf = 100;

//Universo de discurso do ângulo do caminhão (phi)
phii = -105;
phif =  285;

//Universo de discurso do ângulo do volante do caminhão (teta)
tetai = -30;
tetaf =  30;



//=============================================================================
//Constantes importantes
//=============================================================================

//Sobre o caminhão
comp_cam = 18; //comprimento do caminhao
larg_cam =  8; //largura do caminhao

//Sobre a garagem
xmeta   =  50;   //posição X de estacionamento ideal
ymeta   = 100;  //posição Y de estacionamento ideal
phimeta =  90; //ângulo de estacionamento ideal

//Erro máximo admissivel nas metas
erro = 0.05;

//Quantidade de passos que o caminhao anda por iteração. Equivale à velocidade.
delta = 1;



//=============================================================================
//Variáveis de interesse
//=============================================================================

//Passos executados até chegar na garagem
passos = 0;


//=============================================================================
//Preparação do gerador de números aleatórios
//=============================================================================
rand("seed", getdate('s'));
rand("uniform");



//=============================================================================
//Leitura da descrição do sistema de inferência fuzzy do caminhão. É o mesmo
//arquivo FIS produzido no 
//
//Nota: no MATLAB, usa-se a função 'readfis', que também existe no sciFLT.
//Contudo, neste caso usamos a função a seguir.
//=============================================================================
fis = importfis(get_absolute_file_path("caminhao.sce") + "/caminhao.fis"); 



//Feitas todas as definições iniciais, podemos começar a realmente tratar do
//problema.


output_file_name = get_absolute_file_path("caminhao.sce") + ..
                   "output-" + string(getdate('s')) + ".log"
fd = mopen(output_file_name, 'wt');

//quantidade de experimentos que faremos
max_iteracoes = 100000;
iteracoes = 0;
while(iteracoes < max_iteracoes)
    x   = rnd_position(xi, xf);
    y   = rnd_position(yi, yf);
    phi = rnd_position(phii, phif);
    resultado = estaciona(x, y, phi, delta, [xi, xf, yi, yf], fis);
    mfprintf(fd, "%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n", x, y, phi, delta, ..
        resultado(1), resultado(2), resultado(3), resultado(4));
    iteracoes = iteracoes + 1;
end

mclose(fd);

