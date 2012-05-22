function resultado = simula_estacionamento(delta, xmeta, ymeta, phimeta, erro, max_iteracoes, estacionamento, padding, universo_phi, fis, varargin)
% Simula diversas iterações do estacionamento e escreve o resultado da
% simulação num arquivo ou na memória o resultado.
%   ENTRADAS
%    delta: "velocidade" do caminhao. Quantas unidades lineares ele se desloca por iteração.
%    xmeta: o valor ideal de x para onde o caminhão deve se deslocar.
%    ymeta: o valor ideal de y para onde o caminhão deve se deslocar.
%    phimeta: o valor ideal de phi que o caminhão deve ter final de seu deslocamento.
%    estacionamento: vetor [xi, xf, yi, yf], com as dimensões do estacionamento
%    estacionamento: vetor [phii, phif], com os limites de phi
%    fis: o descritor do sistema nebuloso
%    ----ARGUMENTOS OPCIONAIS
%        file: descritor do arquivo aberto para escrita de texto para onde os resultados serão gravados.
%
%   SA�?DA: A saída muda de acordo com o uso do parâmetro opcional
%   (descritor do arquivo). Se foi fornecido um descritor de arquivo, o
%   parâmetro de saída é 0. Senão, será uma matriz com os resultados, onde
%   cada linha 'i' (isto é, resultado(i)) contém a saída da simulação i.
%   As colunas de resultado serão as seguintes:
%       resultado(i, 1):  valor inicial de x usado na simulação i
%       resultado(i, 2):  valor inicial de y usado na simulação i
%       resultado(i, 3):  valor inicial de phi usado na simulação i
%       resultado(i, 4):  delta usado ao longo da simulação
%       resultado(i, 5):  valor final de x na simulação i
%       resultado(i, 6):  valor final de y na simulação i
%       resultado(i, 7):  valor final de phi na simulação i
%       resultado(i, 8):  1 se o caminhao estacionou bem na simulação i; 0 caso contrário.
%       resultado(i, 9):  quantidade de passos tomada para estacionar na simulação i
%       resultado(i, 10): o erro de x na simulação i
%       resultado(i, 11): o erro de y na simulação i
%       resultado(i, 12): o erro de phi na simulação i


    write_to_file = false; %se false, vou retornar a memória
    file = 0; %file descriptor do arquivo de saída

    %se recebemos um descritor de arquivo como parâmetro da função, vamos
    %escrever nesse arquivo.
    if (length(varargin) > 0)
        file = varargin{1};
        write_to_file = true;
    end

    %se não vamos escrever em arquivo, o resultado retorna em uma matriz
    if (~write_to_file)
        %número mágico 12 é a quantidade de valores que retornamos
        resultado = zeros(max_iteracoes, 12);
    end



    %Inicio o contador de progresso se estiver escrevendo em arquivo
    if (write_to_file)
        progress_bar = waitbar(0, 'Simulando...');
    end
    
    %laco principal
    for iteracao = 1:max_iteracoes
        x = rnd_position(estacionamento(1) + padding, estacionamento(2) - padding); %não colocaremos o caminhão colado na parede
        y = rnd_position(estacionamento(3) + padding, 50); %não colocaremos o caminhão colado na parede. O '50' vem das restrições do problema original
        phi = rnd_position(universo_phi(1), universo_phi(2));

        if (write_to_file)
            resultado = estaciona(x, y, phi, delta, xmeta, ymeta, phimeta, erro, estacionamento, fis);

            %escreve resultados no arquivo
            fprintf(file,'%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n',...
                    x, y, phi, delta, resultado(1),resultado(2),resultado(3),resultado(4),resultado(5),...
                                      resultado(6),resultado(7),resultado(8));
        else
            resultado(iteracao,:) = [x y phi delta estaciona(x, y, phi, delta, xmeta, ymeta, phimeta, erro, estacionamento, fis)];
        end

        %atualiza contador de progresso, se estiver escrevendo em arquivo.
        if (write_to_file)
            waitbar(iteracao/max_iteracoes, progress_bar);
        end
    end

    %encerra o contador de progresso, se estiver escrevendo em arquivo.
    if (write_to_file)
        close(progress_bar);
    end

    %caso tenha escrito toda a saida em arquivo, preciso retornar algo
    if (write_to_file)
        resultado = 0;
    end
    
end



function rnd = rnd_position(minimo, maximo)
%Produz um valor aletorio entre os parametros 'minimo' e 'maximo'.
    rnd = rand() * (maximo - minimo) + minimo;
end
