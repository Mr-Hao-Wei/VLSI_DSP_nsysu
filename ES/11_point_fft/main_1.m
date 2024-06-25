clc;
clear;

Fs = 220;   %取樣頻率
T = 1/Fs;   
L = 220;    
t = 0:T/10:1-T/10;
t_sample = 0:T:1-T;
f1 = 22;
f2 = 88;

sig1 = sin(2*pi*f1*t);
sig2 = sin(2*pi*f2*t);
mix_sig = sig1+sig2;

sig1_sample = sin(2*pi*f1*t_sample);
sig2_sample = sin(2*pi*f2*t_sample);
mix_sig_sample = sig1_sample+sig2_sample;

figure(1)   %弦波取樣
subplot(3,1,1)
plot(t,sig1);
hold on
stem(t_sample,sig1_sample);
subplot(3,1,2)
plot(t,sig2);
hold on
stem(t_sample,sig2_sample);
subplot(3,1,3)
plot(t,mix_sig);
hold on
stem(t_sample,mix_sig_sample);

%% 全長度FFT 
fft_1 = fft(mix_sig_sample,L);
%fft_1_shift = fftshift(fft_1);
fft_1_mag = abs(fft_1);
power_1 = mag2db(fft_1_mag);

figure(2)    
subplot(3,1,1)
stem(t_sample,mix_sig_sample);
subplot(3,1,2)
%plot(-L/2:(Fs/L):L/2-1,fft_a_mag);
plot(fft_1_mag);
axis tight
subplot(3,1,3)
%plot(-L/2:(Fs/L):L/2-1,power_a);
plot(power_1);
axis tight

%% 全長度內建11-point-FFT 疊加
fft_2_sum = zeros(1,11);
window = transpose(hamming(11));

for i=1:1:L/11
    fft_2_step = fft(mix_sig_sample(1,11*(i-1)+1:11*i),11);
    % fft_2_step_shift = fftshift(fft_2_step);
    fft_2_sum = fft_2_sum + abs(fft_2_step);
end

%fft_2_sum_shift = fftshift(fft_2_sum);
fft_2_sum_mag = abs(fft_2_sum);
power_2_sum = mag2db(fft_2_sum_mag);

figure(3)   
subplot(3,1,1)
stem(t_sample,mix_sig_sample);
subplot(3,1,2)
%plot(0:(Fs/L):10,fft_bb_sum_mag); % 沒做中心頻率分離 
plot(fft_2_sum_mag);
axis tight
subplot(3,1,3)
%plot(0:(Fs/L):10,power_bb_sum);
plot(power_2_sum);
axis tight

%%
figure(4)
plot_spectrum(mix_sig_sample,Fs)

%%
figure(5)
plot_spectrogram(mix_sig_sample,Fs)

%%
figure(6)
spectrogram(mix_sig_sample,rectwin(11),0,11,"yaxis");


