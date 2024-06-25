function y = ID2I(m,n,x)
y = zeros(m*n*3,1);
v = 0:n:2*n;
u = 0:n:n;
for i = 0:m-1
   for j = 0:n-1
      y(v+i*3*n+j+1) = D2(x(u+i*2*n+j+1));
   end
end
