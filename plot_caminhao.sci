function [] = plot_caminhao(x,y,phi,lc,cc) 

// Modo de exibição
mode(0);

// Exibir aviso para a exceção de ponto flutuante
ieee(1);

// Desenha caminhao na tela
// plot_caminhao(x,y, phi)
// 
//Desenha caminhao na tela.
//x = posicao do caminhao na garagem
//  y = posicao do caminhao na garagem
//  phi = angulo do caminhao
//  Adriano Cruz
//  UFRJ
//  Copyright 1999

// comprimento do caminhao
//cc=20;
// largura do caminhao
//lc=10;
// 
phirad = (mtlb_double(phi)*%pi)/180;
x2 = mtlb_a(mtlb_double(x),(0.5*mtlb_double(lc))*sin(phirad));
y2 = mtlb_s(mtlb_double(y),(0.5*mtlb_double(lc))*cos(phirad));
x3 = mtlb_s(mtlb_double(x),(0.5*mtlb_double(lc))*sin(phirad));
y3 = mtlb_a(mtlb_double(y),(0.5*mtlb_double(lc))*cos(phirad));
x1 = mtlb_s(x2,mtlb_double(cc)*cos(phirad));
y1 = mtlb_s(y2,mtlb_double(cc)*sin(phirad));
x4 = mtlb_s(x3,mtlb_double(cc)*cos(phirad));
y4 = mtlb_s(y3,mtlb_double(cc)*sin(phirad));
plot([x3,x4,x1,x2],[y3,y4,y1,y2]);
plot([x2,x3],[y2,y3],"*:");
//plot([x1 x2 x3 x4 x1], [y1 y2 y3 y4 y1]);

endfunction
