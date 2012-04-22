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
//Definição da posição inicial do caminhão
//=============================================================================
x   = ask_position(xi, xf, "X");
y   = ask_position(yi, yf, "Y");
phi = ask_position(phii, phif, "φ");



//Feitas todas as definições iniciais, podemos começar a realmente tratar do
//problema.



//Renderização inicial do estacionamento
clf;
plot([xi, xf, xf, xi, xi], [yi, yi, yf, yf, yi]);
set(gca(), "auto_clear", "off"); //equivale, em MATLAB a: hold on;
plot_caminhao(x, y, phi, larg_cam, comp_cam);



//=============================================================================
//Leitura da descrição do sistema de inferência fuzzy do caminhão. É o mesmo
//arquivo FIS produzido no 
//
//Nota: no MATLAB, usa-se a função 'readfis', que também existe no sciFLT.
//Contudo, neste caso usamos a função a seguir.
//=============================================================================
fis = importfis(get_absolute_file_path("caminhao.sce") + "/caminhao.fis"); 



//Laço principal do programa
while ( (eval_err(x, xmeta) > erro | ..
         eval_err(y, ymeta) > erro | ..
         eval_err(phi, phimeta) > erro) & ..
         (y < yf & y > yi) & ..
         (x < xf & x > xi) )

    //Chama o sistema de inferência fuzzy, e calcula o novo giro do volante.
    //O nome da função que chama o sistema de inferência do MATLAB é quase o
    //mesmo: evalfis
    output = evalfls( [x, phi], fis);

    //Com o resultado do sistema de inferência, alteramos o estado do caminhão.
    phi = phi + output;
    x = x + delta * cosd(phi); //cosd(x) recebe graus.
    y = y + delta * sind(phi); //sind(x) recebe graus.

    plot_caminhao(x, y, phi, larg_cam, comp_cam);

    passos = passos + 1;
end



//Impressao do estado final do caminhão e das variáveis de interesse
printf("X final (e erro)  : %.2f (%.2f) \n", x,   eval_err(x, xmeta));
printf("Y final (e erro)  : %.2f (%.2f) \n", y,   eval_err(y, ymeta));
printf("PHI final (e erro): %.2f (%.2f) \n", phi, eval_err(phi, phimeta));
printf("Numero de passos  : %d\n", passos);

