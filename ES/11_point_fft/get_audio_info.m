function info = get_audio_info
% list available audio inputs and outputs

    info = audiodevinfo;
   
    fprintf('\nAvailable audio inputs:\n')
    for kk=1:length(info.input)
        fprintf('InpID=%i | %s\n',info.input(kk).ID,info.input(kk).Name)
    end
    
    fprintf('\nAvailable audio outputs:\n')
    for kk=1:length(info.output)
        fprintf('OutID=%i | %s\n',info.output(kk).ID,info.output(kk).Name)
    end    
    
    fprintf('\n')
end