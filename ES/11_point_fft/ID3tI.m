function y = ID3tI(m,n,x)
y = zeros(m*n*3,1);
v = 0:n:2*n;
u = 0:n:4*n;
for i = 0:m-1
   for j = 0:n-1
      y(v+i*3*n+j+1) = D3t(x(u+i*5*n+j+1));
   end
end
