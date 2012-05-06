function resultado = estaciona(x, y, phi, delta, xmeta, ymeta, phimeta, erro, estacionamento, fis, varargin)
    %Executa o algoritmo de estacionar o caminhao.
    %----ENTRADAS
    %    x: posição x inicial do caminhão.
    %    y: posição y inicial do caminhão.
    %    phi: ângulo phi inicial do caminhão.
    %    delta: "velocidade" do caminhao. Quantas unidades lineares ele se desloca por iteração.
    %    xmeta: o valor ideal de x para onde o caminhão deve se deslocar.
    %    ymeta: o valor ideal de y para onde o caminhão deve se deslocar.
    %    phimeta: o valor ideal de phi que o caminhão deve ter final de seu deslocamento.
    %    estacionamento: vetor [xi, xf, yi, yf], com as dimensões do estacionamento
    %    fis: o descritor do sistema nebuloso
    %    ----ARGUMENTOS OPCIONAIS
    %        should_plot: Booleano. Se true, plota o estacionamento.
    %        comp_cam: Comprimento do caminhão usado para plotá-lo. Se ausente, assume-se o valor 8.
    %        larg_cam: Largura do caminhão usado para plotá-lo. Se ausente, assume-se o valor 18.
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

    %Valor padrão das variáveis opcionais.
    should_plot = false;
    larg_cam = 8;
    comp_cam = 18;

    %Atribuição das variáveis opcionais que foram declaradas
    for i = 1:length(varargin)
        if (i == 1)
            should_plot = varargin{i};
        end
        if (i == 2)
            larg_cam = varargin{i};
        end
        if (i == 3)
            comp_cam = varargin{i};
        end
    end

    xi = estacionamento(1);
    xf = estacionamento(2);
    yi = estacionamento(3);
    yf = estacionamento(4);

    %Vamos usar esses valores para o cálculo dos erros.
    x_inicial = x;
    y_inicial = y;

    passos = 0;      %quantidade de iteracoes passadas para chegar no resultado

    if (should_plot)
        hold on;
        plot([xi xf xf xi xi],[yi yi yf yf yi]);
        plot_caminhao(x, y, phi, larg_cam, comp_cam);
    end

    %enquanto o erro é alto demais E o caminhao pode manobrar no estacionamento
    while ( xi < x & x < xf   &   yi < y & y < yf )

        %Chama o sistema de inferencia fuzzy, e calcula o novo giro do volante.
        output = evalfis([x phi y], fis);

        %Com o resultado do sistema de inferencia, movemos o caminhao.
        phi = set_phi(phi + output(1));
        x = x + output(2) * cosd(phi); %cosd(x) recebe graus.
        y = y + output(2) * sind(phi); %sind(x) recebe graus.

        passos = passos + 1;

        if (should_plot)
            plot_caminhao(x, y, phi, larg_cam, comp_cam);
            pause(0.3);
        end

        %se estamos quase parando, pare.
        if ( output(2) < 0.5 )
            break;
        end
    end

    %Calculo dos erros
    err_x   = eval_err(x, xmeta);
    err_y   = eval_err(y, ymeta);
    err_phi = eval_err(phi, phimeta);

    %Consegui estacionar?
    sucesso = err_x < erro & ...
              err_y < erro & ...
              err_phi < erro;

    %Erro de estacionamento
    EE = sqrt((phi - phimeta)^2 + (x - xmeta)^2 + (y - ymeta)^2);

    %Erro da trajetoria: (distancia percorrida) / (distancia euclideana)
    ET = (passos * delta) / sqrt((x_inicial - xmeta)^2 + (y_inicial - ymeta)^2);

    resultado = [x, y, phi, sucesso, passos, err_x, err_y, err_phi, EE, ET];
end



function err = eval_err(val, expected)
   %Avalia qual o erro percentual entre val e expected.
   %O parâmetro val e o valor atual; expected e o valor esperado.
    err = abs((val - expected) / expected);
end

function newphi = set_phi(p)
%Calcula o valor de phi considerando seus limites máximo e mínimo.
%Segundo a definição do problema, phi é um ângulo entre -90 e 270. Esta
%função se certifica de que seu valor permanecerá dentro desses limites.
    newphi = p;
    if (p > 270.0)
        newphi = p - 360.0;
    end
    if (p < -90.0)
        newphi = p + 360.0;
    end
end



function val = distancia_canto_proximo(x, y, estacionamento)
%Calcula a distancia do caminhão até o canto mais próximo do
%estacionamento.
    x_pow = 0;
    if (x > (estacionamento(2) - estacionamento(1))/2)
        x_pow = estacionamento(2) - x;
    else
        x_pow = x - estacionamento(1);
    end
    x_pow = x_pow^2;

    y_pow = 0;
    if (y > (estacionamento(4) - estacionamento(3))/2)
        y_pow = estacionamento(4) - y;
    else
        y_pow = y - estacionamento(3);
    end
    y_pow = y_pow^2;

    val = sqrt(x_pow + y_pow);
end

function atg = angulo_meta(x, y, phi, xmeta, ymeta)
%Retorna o ângulo em graus da inclinação da reta que passa por (x,y) e
%(xmeta,ymeta).
    atg = atand((ymeta - y) / (xmeta - x));
    if (atg < 0)
        atg = atg + 180;
    end
end
