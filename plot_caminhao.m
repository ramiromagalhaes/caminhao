function plot_caminhao(x,y,phi, lc ,cc);
% Desenha caminhao na tela
%  x = posicao do caminhao na garagem
%  y = posicao do caminhao na garagem
%  phi = angulo do caminhao
%  Adriano Cruz
%  UFRJ
%  Copyright 1999

phirad=(phi*pi)/180;
x2=x+0.5*lc*sin(phirad);
y2=y-0.5*lc*cos(phirad);
x3=x-0.5*lc*sin(phirad);
y3=y+0.5*lc*cos(phirad);
x1=x2-cc*cos(phirad);
y1=y2-cc*sin(phirad);
x4=x3-cc*cos(phirad);
y4=y3-cc*sin(phirad);
plot([x3 x4 x1 x2], [y3 y4 y1 y2]);
plot([x2 x3], [y2 y3], '*:');
%plot([x1 x2 x3 x4 x1], [y1 y2 y3 y4 y1]);

