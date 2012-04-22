// 
//Problema de estacionar um caminhao
//Livro: Neural Networks and Fuzzy Systems - A Dynamical Systems Approach 
//       to Machine Intelligence cap 9
//       Bart Kosko
//       Ed. Prentice Hall
// 
//Data: 03/09/1999
// 

// 
//Nomes iniciando com letras maiusculas referem-se a Universos de Discurso
//Nomes iniciando com letras minusculas referem-se a variaveis nebulosas e 
//      conjuntos
// 
//==========================================================================
// 
// 

// Modo de exibição
mode(0);

// Exibir aviso para a exceção de ponto flutuante
ieee(1);

//Dispenso a exibição da janela do gráfico no início.
clf;

exec(get_absolute_file_path("caminhao.sce") + '/plot_caminhao.sci'); //usar pathconvert para compatibilidade?

// 
//Universo de discurso da variavel de posicao y
// 
//Esta variavel nao entra no sistema nebuloso, porque e assumido que
//o patio de manobra tem espaco suficiente para recuos.
// 
yi = 0;yf = 100;y_step = 1;
// 
//Definicao do caminhao
// 
// comprimento do caminhao
comp_cam = 18;
// largura do caminhao
larg_cam = 8;
// 
// 
//Definicao das coordenadas da garagem
//  
xmeta = 50;ymeta = 100;phimeta = 90;
// 
//Definicao das variaveis de Entrada
// 
//Posicao do caminhao - variável x
//=================================
// 
//Universe of Discourse
//=====================
xi = 0;xf = 100;x_step = 0.1;

posicao = input("Qual a posicao x do caminhao? (0 <= x <= 100)");
while mtlb_logic(mtlb_double(posicao),"<",xi) | mtlb_logic(mtlb_double(posicao),">",xf)
  posicao = input("Posicao invalida. Entre com um valor entre 0 e 100 .");
end;
// 
// 
//=============================================================================
// 
//Angulo do caminhao - variável phi
//=================================
// 
//Universe of Discourse
//=====================
phii = -105;phif = 285;phi_step = 1;
//Angulo_c=[phii:phi_step:phif];
// 
angulo = input("Qual o angulo do caminhao? (-105 <= angulo <= 285)");
while mtlb_logic(mtlb_double(angulo),"<",phii) | mtlb_logic(mtlb_double(angulo),">",phif)
  angulo = input("Angulo invalido. Entre com um valor entre -105 e 285 .");
end;
// 
//===============================================================================
//Definicao das variaveis de Saida
// 
//Angulo do volante - variável tet
//================================
// 
//Universe of Discourse
//=====================
teti = -30;tetf = 30;tet_step = 1;
//Angulo_v=[teti:tet_step:tetf];
// 
// 
//Agora que foram definidos todos os conjuntos, tanto os de 
//entrada como os de saida, iremos fazer os calculos do que
//deve acontecer na saida baseado nas entradas.
// 
//Estabelecendo uma posicao inicial do caminhao
// 
//posicao=48;
//angulo=-80;
//y=10;

y = input("Qual a posicao y do caminhao? (0 <= y <= 50)");
while mtlb_logic(mtlb_double(y),"<",0) | mtlb_logic(mtlb_double(y),">",50)
  y = input("Posicao invalida. Entre com um valor entre 0 e 50")
end;

// 
//Definicao do parque de estacionamento
// 
Axis = [xi,xf,yi,yf];
// 
plot([xi,xf,xf,xi,xi],[yi,yi,yf,yf,yi]);
set(gca(),"auto_clear","off");
plot_caminhao(posicao,y,angulo,larg_cam,comp_cam);
// 
// 
//Passos para chegar na garagem
// 
passos = 0;
// 
//Erro admissivel nas metas
// 
erro = 0.05;
// 
//Passo que o caminhao andara
// 
delta = 5;
// 
//Lendo a descricao do sistema de inferencia fuzzy do caminhao
// 
fis = importfis(get_absolute_file_path("caminhao.sce") + "/caminhao.fis"); //também existe uma readfis no sciFLT, mas não é essa que devemos usar.

// 
while mtlb_logic(abs(mtlb_s(mtlb_double(posicao),xmeta))/xmeta,">",erro) | mtlb_logic(abs(mtlb_s(mtlb_double(y),ymeta))/ymeta,">",erro) | mtlb_logic(abs(mtlb_s(mtlb_double(angulo),phimeta))/phimeta,">",erro)
  // 
  //    output=centroid(Angulo_v, aggregation);
  output = evalfls([posicao,angulo],fis); //o nome em MATLAB é quase igual: evalfis
  // c_plot(Angulo_v, aggregation, output, ''Angulo do volante do carro'');
  // 
  //Calculo das novas posições
  //================================================================================
  //Como as funcoes precisam dos angulos em radianos vou converter de graus
  //para radianos
  // 
  //    fprintf(''Angulo atual    = %.2f\n'', angulo);
  //   fprintf(''Posicao atual x = %.2f\n'', posicao);
  //    fprintf(''Posicao atual y = %.2f\n'', y);
  angulo = mtlb_a(mtlb_double(angulo),mtlb_double(output));
  angulo_rad = (%pi*angulo)/180;
  posicao = mtlb_a(mtlb_double(posicao),delta*cos(angulo_rad));
  y = mtlb_a(mtlb_double(y),delta*sin(angulo_rad));

  //    fprintf(''Saida do fis   = %.2f\n'', output);
  //    fprintf(''Novo Angulo    = %.2f\n'', angulo);
  //    fprintf(''Nova Posicao x = %.2f\n'', posicao);
  //    fprintf(''Nova Posicao   = %.2f\n'', y);
  //    input(''Digite qualquer coisa para continuar'');
  plot_caminhao(posicao,y,angulo,larg_cam,comp_cam);
  // 
  //input(''Digite qualquer coisa para mais uma iteracao'');
  //xpause(1000*1);
  passos = passos+1;
end;
// 
//Impressao dos valores finais
// 
mtlb_fprintf("Numero de passos = %d\n",passos);
mtlb_fprintf("Posicao final x  = %.2f\n",posicao);
mtlb_fprintf("Posicao final y  = %.2f\n",y);
mtlb_fprintf("Angulo final phi = %.2f\n",angulo);
