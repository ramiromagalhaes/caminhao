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



