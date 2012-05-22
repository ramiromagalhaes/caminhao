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
    %----SA�?DA: Vetor onde suas posicoes possuem os seguintes resultados
    %    resultado[1] : posicao x final
    %    resultado[2] : posicao y final
    %    resultado[3] : angulo final
    %    resultado[4] : se conseguiu estacionar ou nao
    %    resultado[5] : quantidade de passos final
    %    resultado[6] : erro de x
    %    resultado[7] : erro de y
    %    resultado[8] : erro do angulo
   
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
    while ( (~(eval_err(x, xmeta) < erro & ...
             eval_err(y, ymeta) < erro & ...
             eval_err(phi, phimeta) < erro)) & ...
             xi < x & x < xf   &   yi < y & y < yf )

        %Chama o sistema de inferencia fuzzy, e calcula o novo giro do volante.
        output = evalfis([x phi], fis);

        %Com o resultado do sistema de inferencia, movemos o caminhao.
        phi = set_phi(phi + output);
        x = x + delta * cosd(phi); %cosd(x) recebe graus.
        y = y + delta * sind(phi); %sind(x) recebe graus.

        passos = passos + 1;

        if (should_plot)
            plot_caminhao(x, y, phi, larg_cam, comp_cam);
            pause(0.3);
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

   

    resultado = [x, y, phi, sucesso, passos, err_x, err_y, err_phi];
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
