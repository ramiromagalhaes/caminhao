function fis = create_caminhao_fis(p)
%Cria um FIS com base em outro FIS, mas monta a matriz de regras de acordo
%com os parâmetros fornecidos.
%   Parâmetros de ENTRADA
%       p: vetor com as respostas do volante para as 14 formas com que o
%       caminhão pode estar na ESQUERDA do estacionamento. Os 3 últimos
%       parâmetros, contudo, se referem às respostas do volante para as 
%       3 formas com que o caminhão pode estar à esquerda do centro.

    basefis = readfis('caminhao.fis');

    fis = newfis(...
        'caminhao', 'mamdani', 'min', 'max', 'min', 'max', 'centroid');

    fis.input = basefis.input;
    fis.output = basefis.output;

    qtd_mf_input_1 = 5;
    qtd_mf_input_2 = 7;
    qtd_mf_output_1 = 7;

    rule_number = 1;
    for i = 1:floor(qtd_mf_input_1 / 2) %centro eu trato a parte
        for j = 1:qtd_mf_input_2
            fis = addrule(fis, [                  i                  j                   p(rule_number) 1 1] );
            fis = addrule(fis, [ qtd_mf_input_1+1-i qtd_mf_input_2+1-j qtd_mf_output_1+1-p(rule_number) 1 1] );

            rule_number = rule_number + 1;
        end
    end

    %regras para o centro
    centro = ceil(qtd_mf_input_1 / 2);

    for i = 1:floor(qtd_mf_input_2/2)
        fis = addrule(fis, [centro                   i                     p(rule_number)  1 1] );
        fis = addrule(fis, [centro (qtd_mf_input_2+1-i) (qtd_mf_output_1+1-p(rule_number)) 1 1] );
        rule_number = rule_number + 1;
    end

    %caminhão está no centro e alinhado com a direção para o estacionamento
    fis = addrule(fis, [centro 4 4 1 1] );
end
