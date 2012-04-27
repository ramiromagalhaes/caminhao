function err = eval_err(val, expected)
%Avalia qual o erro percentual entre val e expected, onde val � o valor atual
%da vari�vel e expected � o valor esperado para ela.
    err = abs((val - expected)/expected);
end
