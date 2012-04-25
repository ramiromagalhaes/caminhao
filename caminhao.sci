//param_caminhao: vetor [x, y, z], onde x é a pos. x, y é a pos. y e z é seu ângulo
//delta: "velocidade" do caminhão
//estacionamento: vetor [xi, xf, yi, yf], com as posições do estacionamento
function resultado = estaciona(x, y, phi, delta, estacionamento, fis)
    xi = estacionamento(1);
    xf = estacionamento(2);
    yi = estacionamento(3);
    yf = estacionamento(4);

    passos = 0;

    while ( (eval_err(x, xmeta) > erro | ..
             eval_err(y, ymeta) > erro | ..
             eval_err(phi, phimeta) > erro) & ..
             (x < xf & x > xi) & ..
             (y < yf & y > yi) )
        //Chama o sistema de inferência fuzzy, e calcula o novo giro do volante.
        //O nome da função que chama o sistema de inferência do MATLAB é quase o
        //mesmo: evalfis
        output = evalfls( [x, phi], fis);
    
        //Com o resultado do sistema de inferência, alteramos o caminhão.
        phi = phi + output;
        x = x + delta * cosd(phi); //cosd(x) recebe graus.
        y = y + delta * sind(phi); //sind(x) recebe graus.

        passos = passos + 1;
    end

    resultado = [x, y, phi, passos];
endfunction



function rnd = rnd_position(minimo, maximo)
    rnd = rand() * (maximo - minimo) + minimo;
endfunction



//Função genérica para pedir ao usuário algum valores de entrada.
function val = ask_position(min_val, max_val, val_name)
    val = max_val + 1;
    while (val < min_val | val > max_val)
        val = input("Forneça um valor para a variável " + string(val_name) + ..
                    " (" + string(min_val) + " ≤ " + string(val_name) + ..
                    " ≤ " + string(max_val) + "): ");
    end
endfunction



//Avalia qual o erro percentual entre val e expected, onde val é o valor atual
//da variável e expected é o valor esperado para ela.
function err = eval_err(val, expected)
    err = abs((val - expected)/expected)
endfunction
