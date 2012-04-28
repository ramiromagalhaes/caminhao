function rnd = rnd_position(minimo, maximo)
%Produz um valor aletorio entre os parametros 'minimo' e 'maximo'.
    rnd = rand() * (maximo - minimo) + minimo;
end

