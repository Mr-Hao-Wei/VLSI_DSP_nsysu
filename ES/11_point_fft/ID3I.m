function y = ID3I(m,n,x)
y = zeros(m*n*5,1);
v = 0:n:4*n;
u = 0:n:2*n;
for i = 0:m-1
   for j = 0:n-1
      y(v+i*5*n+j+1) = D3(x(u+i*3*n+j+1));
   end
end
