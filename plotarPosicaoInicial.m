%função para ler o arquivo de resultados e plotar posições iniciais do caminhao
 
%Definicao do parque de estacionamento
yi=0; yf=100;
xi=0; xf=100;
%inicializa subgraficos
clf;
Axis = ([xi xf yi yf]);
plot([xi xf xf xi xi],[yi yi yf yf yi]);
legend('Azul -90 a 0, vermelho 0 a 90, verde 90 a 180, rosa 180 a 270');
hold on

%lê x, y , phi e sucesso e plota posição inicial
nome = input('insira o nome do arquivo: ');
fid = fopen(nome);

if fid==-1
    disp ('Arquivo não encontrado');
else

s = input('Deseja plotar sucesso (1) ou falha (0): ');

if s~=0 & s~=1
    disp('Digite 0 ou 1');
else
    
linha = fgetl(fid);
%testa se tem cabeçalho
if isempty(strfind(linha,'x'))==0
    %pega próxima linha
  linha = fgetl(fid);
end


while ischar(linha)

    
[x, y, phi,delta,xf,yf,phif,sucesso,passos,err_x,err_y,err_phi,EE,ET] = strread(linha,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f','delimiter',';');

%verifica a cor para plotar no sugráfico correto
if sucesso == s
% Verifica o angulo para decidir a cor de plotagem
    if -90<=phi & phi<0
        %cor azul
       cor= 'b';
       
    elseif 0<=phi & phi<90
    % cor vermelha
       cor='r';
        
   elseif 90<=phi & phi<180
    % cor verde 
        cor='g';
        
   elseif 180<=phi & phi<270
    % cor rosa
        cor= 'm';
    end
  
   plot(x,y,cor);
   hold on   
end
     linha = fgetl(fid);
end
end

fclose(fid);
end

