function plot_spectrogram(y,FS)
% plot spectrogram of time-domain signal
%
% usage:
%   plot_spectrogram(y,FS)
%   y  : signal
%   FS : sampling rate 

fprintf('Plotting spectrogram...\n')
spectrogram(y,hamming(128),64,256*4,FS,'yaxis')

end

