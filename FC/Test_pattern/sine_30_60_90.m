clear;
clc;

fs1=30;
fs2=60;
fs3=90;
t=0:0.0000001:0.1;

wave_30=900*sin(2*pi*t*fs1);
wave_60=900*sin(2*pi*t*fs2);
wave_90=900*sin(2*pi*t*fs3);

f_sample=360;
t_sample=0:1/f_sample:0.1;
wave_30_sample=900*sin(2*pi*t_sample*fs1);
wave_60_sample=900*sin(2*pi*t_sample*fs2);
wave_90_sample=900*sin(2*pi*t_sample*fs3);

figure(1)
subplot(2,1,1)
plot(t,wave_30);
xlabel("time");
ylabel("wave30(t)");
subplot(2,1,2)
plot(t_sample,wave_30_sample);
hold on ;
stem(t_sample,wave_30_sample);
xlabel("time");
ylabel("wave30sample(t)");

figure(2)
subplot(2,1,1)
plot(t,wave_60);
xlabel("time");
ylabel("wave60(t)");
subplot(2,1,2)
plot(t_sample,wave_60_sample);
hold on ;
stem(t_sample,wave_60_sample);
xlabel("time");
ylabel("wave60sample(t)");

figure(3)
subplot(2,1,1)
plot(t,wave_90);
xlabel("time");
ylabel("wave90(t)");
subplot(2,1,2)
plot(t_sample,wave_90_sample);
hold on ;
stem(t_sample,wave_90_sample);
xlabel("time");
ylabel("wave90sample(t)");







