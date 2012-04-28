function resultado = estaciona(x, y, phi, delta,xmeta, ymeta, phimeta, erro, estacionamento, fis)
    %Executa o algoritmo de estacionar o caminhao.
    %param_caminhao: vetor [x, y, z], onde x e a pos. x, y e a pos. y e z e seu angulo
    %delta: "velocidade" do caminhao
    %estacionamento: vetor [xi, xf, yi, yf], com as posicoes do estacionamento
    xi = estacionamento(1);
    xf = estacionamento(2);
    yi = estacionamento(3);
    yf = estacionamento(4);

    %armazena o estado inicial do caminhao para calculo dos erros
    x0 = x;
    y0 = y;
    phi0 = phi;

    passos = 0;

    %enquanto o erro é alto demais E enquanto o caminhao pode manobrar no estacionamento
    while ( (eval_err(x, xmeta) > erro | ...
            eval_err(y, ymeta) > erro | ...
            eval_err(phi, phimeta) > erro) & ...
            (x < xf & x > xi) & ...
            (y < yf & y > yi) )

        %Chama o sistema de inferencia fuzzy, e calcula o novo giro do volante.
        output = evalfis([x phi], fis);

        %Com o resultado do sistema de inferencia, alteramos o caminhao.
        phi = phi + output;
        x = x + delta * cosd(phi); %cosd(x) recebe graus.
        y = y + delta * sind(phi); %sind(x) recebe graus.

        passos = passos + 1;
    end

    %calcula erros da iteracao 
    %erro estacionamento
    EE=sqrt((phi-phi0)^2+(x-x0)^2+(y-y0)^2);

    %erro da trajetoria distancia percorrida/distancia euclidiana
    ET=(passos*delta)/sqrt((x-x0)^2+(y-y0)^2);

    resultado = [x, y, phi, passos, EE, ET];
end

function err = eval_err(val, expected)
%Avalia qual o erro percentual entre val e expected.
%O parâmetro val e o valor atual e expected e seu valor esperado.
    err = abs((val - expected)/expected);
end

