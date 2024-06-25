%% 要先跑cap11.m
Fs = 110;   %取樣頻率
T = 1/Fs;   
L = 110;    
t = 0:T/10:10-T/10;
t_sample = 0:T:10-T;

sig = sin(2*pi*22*t);
sig_sample = sin(2*pi*22*t_sample);

figure(1)   %弦波取樣
plot(t,sig);
hold on
stem(t_sample,sig_sample);

%% 全長度FFT 
fft_a = fft(sig_sample,L);
% fft_a_shift = fftshift(fft_a);
fft_a_mag = abs(fft_a);
power_a = mag2db(fft_a_mag);

figure(2)    
subplot(3,1,1)
stem(t_sample,sig_sample);
subplot(3,1,2)
%plot(-L/2:(Fs/L):L/2-1,fft_a_mag);
plot(fft_a_mag);
subplot(3,1,3)
%plot(-L/2:(Fs/L):L/2-1,power_a);
plot(power_a);

%% 11-point-FFT
fft_b = transpose(fft11(sig_sample(1,1:11),u,ip,op));
fft_b_shift = fftshift(fft_b);
fft_b_mag = abs(fft_b_shift);
power_b = mag2db(fft_b_mag);

figure(3)   
subplot(3,1,1)
stem(t_sample(1,1:11),sig_sample(1,1:11));
subplot(3,1,2)
plot(-5:(Fs/L):5,fft_b_mag);
subplot(3,1,3)
plot(-5:(Fs/L):5,power_b);
axis([-5 5 -inf 50])

%% 內建11-point-FFT
fft_c = fft(sig_sample(1,1:11),11);
fft_c_shift = fftshift(fft_c);
fft_c_mag = abs(fft_c_shift);
power_c = mag2db(fft_c_mag);

figure(4)   
subplot(3,1,1)
stem(t_sample(1,1:11),sig_sample(1,1:11));
subplot(3,1,2)
plot(-5:(Fs/L):5,fft_c_mag);
subplot(3,1,3)
plot(-5:(Fs/L):5,power_c);
axis([-5 5 -inf 50])

%% 全長度11-point-FFT
fft_b_result = [];
fft_b_result_n = [];
window = transpose(hamming(11));

for i=1:1:L/11
    fft_b_step = transpose(fft11(window.*sig_sample(1,11*(i-1)+1:11*i),u,ip,op));
    fft_b_step_shift = fftshift(fft_b_step);
    fft_b_result = [fft_b_step_shift(1,1:5),fft_b_result,fft_b_step_shift(1,6:11)];
    fft_b_result_n = [fft_b_result_n,fft_b_step_shift];
end

fft_b_result_mag = abs(fft_b_result);
fft_b_result_n_mag = abs(fft_b_result_n);
power_b_result = mag2db(fft_b_result_mag);
power_b_result_n = mag2db(fft_b_result_n_mag);

figure(5)   
subplot(5,1,1)
stem(t_sample,sig_sample);
subplot(5,1,2)
plot(0:(Fs/L):L-1,fft_b_result_n_mag); % 沒做中心頻率分離 
subplot(5,1,3)
plot(0:(Fs/L):L-1,power_b_result_n);
axis([0 L-1 -inf 50])
subplot(5,1,4)
plot(-L/2+5:(Fs/L):L/2-1+5,fft_b_result_mag); % 有做中心頻率分離(以右半邊頻率為準)
subplot(5,1,5)
plot(-L/2+5:(Fs/L):L/2-1+5,power_b_result);
axis([-L/2+5 L/2-1+5 -inf 50])

%% 全長度內建11-point-FFT
fft_c_result = [];
fft_c_result_n = [];
window = transpose(hamming(11));

for i=1:1:L/11
    fft_c_step = fft(window.*sig_sample(1,11*(i-1)+1:11*i),11);
    fft_c_step_shift = fftshift(fft_c_step);
    fft_c_result = [fft_c_step_shift(1,1:5),fft_c_result,fft_c_step_shift(1,6:11)];
    fft_c_result_n = [fft_c_result_n,fft_c_step_shift];
end

fft_c_result_mag = abs(fft_c_result);
fft_c_result_n_mag = abs(fft_c_result_n);
power_c_result = mag2db(fft_c_result_mag);
power_c_result_n = mag2db(fft_c_result_n_mag);

figure(6)   
subplot(5,1,1)
stem(t_sample,sig_sample);
subplot(5,1,2)
plot(0:(Fs/L):L-1,fft_c_result_n_mag); % 沒做中心頻率分離 
subplot(5,1,3)
plot(0:(Fs/L):L-1,power_c_result_n);
axis([0 L-1 -inf 50])
subplot(5,1,4)
plot(-L/2+5:(Fs/L):L/2-1+5,fft_c_result_mag); % 有做中心頻率分離(以右半邊頻率為準)
subplot(5,1,5)
plot(-L/2+5:(Fs/L):L/2-1+5,power_c_result);
axis([-L/2+5 L/2-1+5 -inf 50])

%% 全長度插值11-point-FFT
fft_b_result_insert = [];
insert_step = 5;
sig_sample_shift = [sig_sample(1,insert_step+1:end),zeros(1,insert_step)];
window = transpose(hamming(11));

for i=1:1:L/11
    fft_b_step_insert = transpose(fft11(window.*sig_sample_shift(1,11*(i-1)+1:11*i),u,ip,op));
    fft_b_step_insert_shift = fftshift(fft_b_step_insert);
    fft_b_result_insert = [fft_b_result_insert,fft_b_step_insert_shift];
end

fft_b_result_insert_shift = fft_b_result_n+[zeros(1,insert_step),fft_b_result_insert(1,1:end-11),zeros(1,11-insert_step)];
fft_b_result_insert_mag = abs(fft_b_result_insert);
fft_b_result_insert_shift_mag = abs(fft_b_result_insert_shift);
power_b_result_insert_shift = mag2db(fft_b_result_insert_shift_mag);

figure(7)   % 沒做中心頻率分離
subplot(5,1,1)
stem(t_sample,sig_sample);
subplot(5,1,2)
plot(0:(Fs/L):L-1,fft_b_result_n_mag); % 原全長度11-point-FFT
subplot(5,1,3)
plot(insert_step:(Fs/L):L-1+insert_step,[fft_b_result_insert_mag(1,1:end-11),zeros(1,11)]); % 11-point-FFT插值
subplot(5,1,4)
plot(0:(Fs/L):L-1,fft_b_result_insert_shift_mag); % 全長度11-point-FFT插值結果
subplot(5,1,5)
plot(0:(Fs/L):L-1,power_b_result_insert_shift);
axis([0 L-1 -inf 50])

%% 全長度內建11-point-FFT 疊加
fft_bb_sum = zeros(1,11);
window = transpose(hamming(11));

for i=1:1:L/11
    fft_bb_step = fft(sig_sample(1,11*(i-1)+1:11*i),11);
    % fft_bb_step_shift = fftshift(fft_bb_step);
    fft_bb_sum = fft_bb_sum + abs(fft_bb_step);
end

%fft_bb_sum_shift = fftshift(fft_bb_sum);
fft_bb_sum_mag = abs(fft_bb_sum);
power_bb_sum = mag2db(fft_bb_sum_mag);

figure(8)   
subplot(3,1,1)
stem(t_sample,sig_sample);
subplot(3,1,2)
%plot(0:(Fs/L):10,fft_bb_sum_mag); % 沒做中心頻率分離 
plot(fft_bb_sum_mag);

subplot(3,1,3)
%plot(0:(Fs/L):10,power_bb_sum);
plot(power_bb_sum);

%%
Fs1 = 55;   %取樣頻率
T1 = 1/Fs1;   
L1 = 55;    
t1 = 0:T1/10:1-T1/10;
t1_sample = 0:T1:1-T1;

sig1 = sin(2*pi*22*t1);
sig1_sample = sin(2*pi*22*t1_sample);

figure(9)   %弦波取樣
plot(t1,sig1);
hold on
stem(t1_sample,sig1_sample);

%% 全長度內建11-point-FFT 疊加
fft1_bb_sum = zeros(1,11);
window = transpose(hamming(11));

for i=1:1:L1/11
    fft1_bb_step = fft(sig1_sample(1,11*(i-1)+1:11*i),11);
    % fft_bb_step_shift = fftshift(fft1_bb_step);
    fft1_bb_sum = fft1_bb_sum + abs(fft1_bb_step);
end

%fft1_bb_sum_shift = fftshift(fft1_bb_sum);
fft1_bb_sum_mag = abs(fft1_bb_sum);
power1_bb_sum = mag2db(fft1_bb_sum_mag);

figure(10)   
subplot(3,1,1)
stem(t1_sample,sig1_sample);
subplot(3,1,2)
plot(0:(Fs1/L1):10,fft1_bb_sum_mag); % 沒做中心頻率分離
axis([-100 100 -inf 50])
subplot(3,1,3)
plot(0:(Fs1/L1):10,power1_bb_sum);
axis([-100 100 -inf 50])


