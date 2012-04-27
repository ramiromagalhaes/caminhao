function resultado = estaciona(x, y, phi, delta,xmeta, ymeta, phimeta, erro, estacionamento, fis)
    %param_caminhao: vetor [x, y, z], onde x � a pos. x, y � a pos. y e z � seu �ngulo
    %delta: "velocidade" do caminh�o
    %estacionamento: vetor [xi, xf, yi, yf], com as posi��es do estacionamento
    xi = estacionamento(1);
    xf = estacionamento(2);
    yi = estacionamento(3);
    yf = estacionamento(4);

    %armazena o estado inicial do caminhao para calculo dos erros
    x0 = x;
    y0 = y;
    phi0 = phi;

    passos = 0;

    while ( (eval_err(x, xmeta) > erro | ...
            eval_err(y, ymeta) > erro | ...
            eval_err(phi, phimeta) > erro) & ...
            (x < xf & x > xi) & ...
            (y < yf & y > yi) )

        %Chama o sistema de infer�ncia fuzzy, e calcula o novo giro do volante.
        output = evalfis([x phi], fis);

        %Com o resultado do sistema de infer�ncia, alteramos o caminh�o.
        phi = phi + output;
        x = x + delta * cosd(phi); %cosd(x) recebe graus.
        y = y + delta * sind(phi); %sind(x) recebe graus.

        passos = passos + 1;
    end

    %calcula erros da iteracao 
    %erro estacionamento
    EE=sqrt((phi-phi0)^2+(x-x0)^2+(y-y0)^2);

    %erro da trajet�ria distancia percorrida/distancia(posi��o
    %inicial,posi��o final)
    ET=(passos*delta)/sqrt((x-x0)^2+(y-y0)^2);

    resultado = [x, y, phi, passos, EE, ET];
end
