clc
load('den.mat');
load('num.mat');


%%
N=13;
den_bin=[];
for ii=1:size(den,1)
    for jj=1:size(den,2)
        temp=truncate(den(ii,jj),N);
        den_bin(ii,jj)=temp;
    end
end
num_bin=[];
for ii=1:size(num,1)
    for jj=1:size(num,2)
        temp=truncate(num(ii,jj),N);
        num_bin(ii,jj)=temp;
    end
end



function data_cutoff=truncate(data,N)
    data_scale=data*(2^N);
    data_cutoff=fix(data_scale);
    %data_bin=dec2bin(data_cutoff);
end