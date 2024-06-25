
double_complex_format=1+1j;

% x=ones(1,12,'like',double_complex_format);
x=[1+1j,2+2j,3+3j,4+4j,5+5j,6+6j,7+7j,8+8j,9+9j,10+10j,11+11j,0];
G=zeros(3,4,'like',double_complex_format);
X=zeros(1,12,'like',double_complex_format);

chart=[x(1,1),x(1,4),x(1,7),x(1,10);
        x(1,5),x(1,8),x(1,11),x(1,2);
        x(1,9),x(1,12),x(1,3),x(1,6);];

for n2=0:1:2
    for k1=0:1:3
        for n1=0:1:3
           G(n2+1,k1+1)=G(n2+1,k1+1)+chart(n2+1,n1+1)*exp(-1j*k1*n1*2*pi/4); 
        end
    end
end

for k1=0:1:3
    for k2=0:1:2
        for n2=0:1:2
            X(1,mod(9*k1+4*k2,12)+1)=X(1,mod(9*k1+4*k2,12)+1)+G(n2+1,k1+1)*exp(-1j*k2*n2*2*pi/3);
        end
    end
end

XX=transpose(X);

%%
x_test=[1+1j,2+2j,3+3j,4+4j,5+5j,6+6j,7+7j,8+8j,9+9j,10+10j,11+11j];
X_test=fft(x_test);

XX_test=transpose(X_test);

%%

Y=fft11(x_test,u,ip,op);



