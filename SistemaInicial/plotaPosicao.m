%função para ler o arquivo de resultados e plotar posições iniciais do caminhao
 
% comprimento do caminhao
cc=10;
% largura do caminhao
lc=5;

%Definicao do parque de estacionamento
yi=0; yf=100;
xi=0; xf=100;
%inicializa subgraficos
clf;
Axis = ([xi xf yi yf]);
subplot(1,3,1);
plot([xi xf xf xi xi],[yi yi yf yf yi]);
subplot(1,3,2);
plot([xi xf xf xi xi],[yi yi yf yf yi]);
subplot(1,3,3);
plot([xi xf xf xi xi],[yi yi yf yf yi]);
hold on

%lê x, y , phi e cor (situação) e plota posição inicial
%fid = fopen('ResultadosOriginal_01_05.csv');
fid = fopen('resultado.csv');

linha = fgetl(fid);
%testa se tem cabeçalho
if isempty(strfind(linha,'x'))==0
    %pega próxima linha
  linha = fgetl(fid);
end


while ischar(linha)

    
[x, y, phi,delta,xf,yf,phif,passos,EE,ET,cor] = strread(linha,'%f %f %f %f %f %f %f %f %f %f %c','delimiter',';');

%calcula disposição do caminhao
phirad=(phi*pi)/180;
x2=x+0.5*lc*sin(phirad);
y2=y-0.5*lc*cos(phirad);
x3=x-0.5*lc*sin(phirad);
y3=y+0.5*lc*cos(phirad);
x1=x2-cc*cos(phirad);
y1=y2-cc*sin(phirad);
x4=x3-cc*cos(phirad);
y4=y3-cc*sin(phirad);

%verifica a cor para plotar no sugráfico correto
if cor == 'm'
% cor magenta são os que saem do UoD de x e não conseguem estacionar
    subplot(1,3,1);
    
elseif cor=='b'
    % cor azul são os que alinham mas não param
    subplot(1,3,2);
    
elseif cor =='g'
    % cor verde são os que saem dos limites do estacionamento mas estacionam
    subplot(1,3,3);
    
end
    plot([x3 x4 x1 x2], [y3 y4 y1 y2],cor);
    plot([x2 x3], [y2 y3],strcat(cor,'*:'));
    hold on   

     linha = fgetl(fid);
end

fclose(fid);

