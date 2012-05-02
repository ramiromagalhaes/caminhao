%
%Problema de estacionar um caminhao
%Livro: Neural Networks and Fuzzy Systems - A Dynamical Systems Approach 
%       to Machine Intelligence cap 9
%       Bart Kosko
%       Ed. Prentice Hall
%
%Data: 03/09/1999
%

%
%Nomes iniciando com letras maiusculas referem-se a Universos de Discurso
%Nomes iniciando com letras minusculas referem-se a variaveis nebulosas e 
%      conjuntos
%
%==========================================================================
%
%
clc;
%
%Definicao do caminhao
%
% comprimento do caminhao
comp_cam=18;
% largura do caminhao
larg_cam=8;


%Universo de discurso da variavel de posicao y
%Esta variavel nao entra no sistema nebuloso, porque e assumido que
%o patio de manobra tem espaco suficiente para recuos.
yi=0; yf=100; y_step=1;

vet_y = [0:10:50];

%
%Definicao das coordenadas da garagem
%  
xmeta=50; ymeta=100; phimeta=90;
%
%Definicao das variaveis de Entrada
%
%Posicao do caminhao - variável x
%=================================
%
%Universe of Discourse
%=====================
xi=0; xf=100; x_step=0.1;

%vetor de entrada de dados
vet_posicao = [0:10:100];
%
%=============================================================================
%
%Angulo do caminhao - variável phi
%=================================
%
%Universe of Discourse
%=====================
phii=-105; phif=285; phi_step=1;

vet_angulo = [-90:10:270];
%
%===============================================================================
%Definicao das variaveis de Saida
%
%Angulo do volante - variável tet
%================================
%
%Universe of Discourse
%=====================
teti=-30; tetf=30; tet_step=1;
%Angulo_v=[teti:tet_step:tetf];
%
%
%Agora que foram definidos todos os conjuntos, tanto os de 
%entrada como os de saida, iremos fazer os calculos do que
%deve acontecer na saida baseado nas entradas.
%
%inicializando arquivo de saída
fileID = fopen('resultado.csv','w');

fprintf(fileID,'%6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s\n','x','y','phi','delta','xf','yf','phif','passos','EE','ET','Cor');

for i=1:length(vet_posicao)
         
     for j=1:length(vet_y)
       
        for k=1:length(vet_angulo)
                   
            posicao = vet_posicao(i);
            y = vet_y(j);
            angulo = vet_angulo(k);

            %Passos para chegar na garagem
            passos = 0;

            %Erro admissivel nas metas
            erro=0.05;
            
            %Passo que o caminhao andara
            delta=5;
            %
            %Lendo a descricao do sistema de inferencia fuzzy do caminhao
            %
            fis = readfis('caminhao');
            %
            %variável criada para evitar loop infinito e registrar qdo não
            %estaciona
            status = '';
            
            %variavel cor é para plotar áreas problemáticas para o
            %relatório
            cor = 'w';
            
            %status incluido na condição de parada pra simular
            while ((((abs(posicao-xmeta)/xmeta)>erro) | ((abs(y-ymeta)/ymeta)>erro) | ((abs(angulo-phimeta)/phimeta)>erro)) & (strcmpi(status,'')==1) )
               
                output = evalfis([posicao angulo], fis);
               
            %Calculo das novas posições
            %================================================================================
            %Como as funcoes precisam dos angulos em radianos vou converter de graus
            %para radianos
                angulo = angulo + output;
                angulo_rad = (pi * angulo)/180;
                posicao = posicao + delta*cos(angulo_rad);
                y=y+delta*sin(angulo_rad);

                passos = passos+1;
            
                %testo x e y para registrar situações anormais para o
                %relatório
                if y>110
                    % Estourou o y, ou seja loop infinito 
                    status = ' estourou y acima';
                    cor = 'b';
                elseif (posicao<0 & posicao>-20) | (posicao>100 & posicao<120)
                     % sai do UoD de x mas recupera, pode ser interesante
                     % saber essa situação para comparação já que no novo
                     % sistema o caminhão não poderá sair dos limites do
                     % estacionamento
                     cor = 'g';
                elseif (posicao<-20 | posicao>120)
                    %carro sai dos limites do x e não estaciona mais
                    status = ' estourou x';
                    cor = 'm';
                elseif  y<0
                    % sai do UoD de y mas recupera
                    cor = 'g';
                end
                    
            end
          
            %armazenando dados de execução x	y	phi	delta	xf	yf	phif	passos
            %Erro de estacionamento
             EE = sqrt((angulo - phimeta)^2 + (posicao - xmeta)^2 + (y - ymeta)^2);

            %Erro da trajetoria: (distancia percorrida) / (distancia euclideana)
            ET = (passos * delta) / sqrt((vet_posicao(i) - xmeta)^2 + (vet_y(j) - ymeta)^2);
    
            fprintf(fileID,'%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6s\n',vet_posicao(i),vet_y(j),vet_angulo(k),delta,posicao,y,angulo,passos,EE,ET,cor);
           
          end
     end
end
%fecha arquivo resultados
fclose(fileID);
