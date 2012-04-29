function resultado = estaciona(x, y, phi, delta, xmeta, ymeta, phimeta, erro, estacionamento, fis)
    %Executa o algoritmo de estacionar o caminhao.
    %----ENTRADAS
    %    param_caminhao: vetor [x, y, z], onde x e a pos. x, y e a pos. y e z e seu angulo
    %    delta: "velocidade" do caminhao
    %    estacionamento: vetor [xi, xf, yi, yf], com as posicoes do estacionamento
    %    fis: o descritor do sistema nebuloso
    %----SAÍDA: Vetor onde suas posicoes possuem os seguintes resultados
    %    resultado[1] : posicao x final
    %    resultado[2] : posicao y final
    %    resultado[3] : angulo final
    %    resultado[4] : se conseguiu estacionar ou nao
    %    resultado[5] : quantidade de passos final
    %    resultado[6] : erro de x
    %    resultado[7] : erro de y
    %    resultado[8] : erro do angulo
    %    resultado[9] : erro de estacionamento
    %    resultado[10]: erro de trajetória

    xi = estacionamento(1);
    xf = estacionamento(2);
    yi = estacionamento(3);
    yf = estacionamento(4);

    x_inicial = x;
    y_inicial = y;

    sucesso = false; %no final do laço, o caminhao conseguiu estacionar?
    passos = 0;      %quantidade de iteracoes passadas para chegar no resultado

    %enquanto o erro é alto demais E enquanto o caminhao pode manobrar no estacionamento
    while true
        passos = passos + 1;

        %Se o caminhao conseguiu estacionar, pare e informe sucesso.
        if ((eval_err(x, xmeta) < erro | ...
             eval_err(y, ymeta) < erro | ...
             eval_err(phi, phimeta) < erro))
            sucesso = true;
            break;
        end

        %Pare se o caminhao NAO conseguiu estacionar, e infome falha.
        if ((x < xi | x > xf) | (y < yi | y > yf))
            sucesso = false;
            break;
        end

        %Chama o sistema de inferencia fuzzy, e calcula o novo giro do volante.
        output = evalfis([x phi], fis);

        %Com o resultado do sistema de inferencia, movemos o caminhao.
        phi = phi + output;
        x = x + delta * cosd(phi); %cosd(x) recebe graus.
        y = y + delta * sind(phi); %sind(x) recebe graus.
    end

    %Calculo dos erros
    err_x   = eval_err(x, xmeta);
    err_y   = eval_err(y, ymeta);
    err_phi = eval_err(phi, phimeta);

    %Erro de estacionamento
    EE = sqrt((phi - phimeta)^2 + (x - xmeta)^2 + (y - ymeta)^2);

    %Erro da trajetoria: (distancia percorrida) / (distancia euclidiana)
    ET = (passos * delta) / sqrt((x_inicial - xmeta)^2 + (y_inicial - ymeta)^2);

    resultado = [x, y, phi, sucesso, passos, err_x, err_y, err_phi, EE, ET];
end


function err = eval_err(val, expected)
%Avalia qual o erro percentual entre val e expected.
%O parâmetro val e o valor atual; expected e o valor esperado.
    err = abs((val - expected) / expected);
end

