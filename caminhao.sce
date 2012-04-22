//Problema de estacionar um caminhao
//Livro: Neural Networks and Fuzzy Systems - A Dynamical Systems Approach
//       to Machine Intelligence cap 9
//       Bart Kosko
//       Ed. Prentice Hall
//
//Data: 03/09/1999



// Exibir aviso para a exceção de ponto flutuante
ieee(1);

//usar pathconvert para compatibilidade?
exec(get_absolute_file_path("caminhao.sce") + '/plot_caminhao.sci', -1);
exec(get_absolute_file_path("caminhao.sce") + '/caminhao.sci', -1);

clf;

// 
//Universo de discurso da variavel de posicao y
// 
//Esta variavel nao entra no sistema nebuloso, porque e assumido que
//o patio de manobra tem espaco suficiente para recuos.
// 
yi = 0;
yf = 100;
y_step = 1;

//Definicao do caminhao
//comprimento do caminhao
comp_cam = 18;
//largura do caminhao
larg_cam = 8;

//Definicao das coordenadas da garagem
xmeta = 50;
ymeta = 100;
phimeta = 90;

//Definicao das variaveis de Entrada
//
//Posicao do caminhao - variável x
xi = 0;
xf = 100;

posicao = input("Qual a posicao x do caminhao? (0 <= x <= 100)");
while (posicao < xi | posicao > xf)
    posicao = input("Posicao invalida. Entre com um valor entre 0 e 100 .");
end

//
//=============================================================================
// 
//Angulo do caminhao - variável phi
//=================================
phii = -105;
phif = 285;

angulo = input("Qual o angulo do caminhao? (-105 <= angulo <= 285)");
while (angulo < phii | angulo > phif)
    angulo = input("Angulo invalido. Entre com um valor entre -105 e 285 .");
end


//Estabelecendo uma posicao inicial do caminhao
// 
//posicao=48;
//angulo=-80;
//y=10;

y = input("Qual a posicao y do caminhao? (0 <= y <= 50)");
while (y < 0 | y > 50)
    y = input("Posicao invalida. Entre com um valor entre 0 e 50")
end

//
//===============================================================================
//Definicao das variaveis de Saida
// 
//Angulo do volante - variável tet
//================================
teti = -30;
tetf = 30;

// 
//Definicao do parque de estacionamento
// 
Axis = [xi, xf, yi, yf];
plot([xi, xf, xf, xi, xi], [yi, yi, yf, yf, yi]);
set(gca(), "auto_clear", "off");
plot_caminhao(posicao, y, angulo, larg_cam, comp_cam);

//Passos para chegar na garagem
passos = 0;

//Erro admissivel nas metas
erro = 0.05;

//Passo que o caminhao andara
delta = 5;


//
//Agora que foram definidos todos os conjuntos, tanto os de entrada como os de
//saida, iremos fazer os calculos do que deve acontecer na saida baseado nas
//entradas.
//


//Lendo a descricao do sistema de inferencia fuzzy do caminhao
//Também existe uma função readfis no sciFLT, mas não é essa que devemos usar.
fis = importfis(get_absolute_file_path("caminhao.sce") + "/caminhao.fis"); 



while ( eval_err(posicao, xmeta) > erro | eval_err(y, ymeta) > erro | eval_err(angulo, phimeta) > erro )
    //output=centroid(Angulo_v, aggregation);
    output = evalfls([posicao,angulo], fis); //o nome em MATLAB é quase igual: evalfis

    // c_plot(Angulo_v, aggregation, output, ''Angulo do volante do carro'');

    //Calculo das novas posições
    angulo = angulo + output;
    posicao = posicao + delta * cosd(angulo); //Não converterei de graus → rads.
                                              //cosd(x) recebe graus.
    y = y + delta * sind(angulo); //Não converterei de graus → rads. sind(x)
                                  //recebe graus.

    plot_caminhao(posicao, y, angulo, larg_cam, comp_cam);

    passos = passos + 1;
end

//Impressao dos valores finais
printf("Numero de passos = %d\n", passos);
printf("Posicao final x  = %.2f\n", posicao);
printf("Posicao final y  = %.2f\n", y);
printf("Angulo final phi = %.2f\n", angulo);
