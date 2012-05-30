function savefis( gene )
    %Salva em arquivo um FIS gerado a partir do vetor de 17 posicoes 'gene'.
    fis = create_caminhao_fis(gene);
    writefis(fis, get_fis_file_name(clock()));
end



function name = get_fis_file_name(the_time)
%Cria um nome para o FIS a salvar.
    username = getenv('USERNAME');
    name = ['caminhao-' username '-' ...
                num2str(the_time(1)) '-' num2str(the_time(2)) '-' ...
                num2str(the_time(3)) '-' num2str(the_time(4)) '-' ...
                num2str(the_time(5)) '-' num2str(the_time(6)) '.fis'];
end
