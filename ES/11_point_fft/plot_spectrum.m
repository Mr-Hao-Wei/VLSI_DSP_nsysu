function plot_spectrum(y,FS)
% plot spectrum of time-domain signal
%
% usage:
%   plot_spectrum(y,FS)
%   y  : signal
%   FS : sampling rate 

fprintf('Plotting spectrum...\n')

len = round(length(y)/2);
freq = linspace(0, FS/2, len);
y_freq = abs(fft(y)/sqrt(length(y)));
plot(freq,y_freq(1:len),'bo-');
xlabel('Frequency [Hz]')
ylabel('Magnitude')
grid on
axis([0 FS/2 0 max(y_freq)+0.1])

end

