function [y,FS] = load_audio(filename)
% load audio signal from file
%
% usage:
%   load_audio(filename)
%   filename : name of file (include path information)

fprintf('Loading %s...\n',filename)
[y,FS] = audioread(filename);

end


