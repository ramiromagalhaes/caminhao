function name = get_output_file_name()
%Função utilitária que cria um nome variável para as saídas produzidas.
    the_time = clock();
    username = getenv('USERNAME');
    name = ['outputs/resultado-' username '-' ...
                num2str(the_time(1)) '-' num2str(the_time(2)) '-' ...
                num2str(the_time(3)) '-' num2str(the_time(4)) '-' ...
                num2str(the_time(5)) '-' num2str(the_time(6)) '.csv'];
end

