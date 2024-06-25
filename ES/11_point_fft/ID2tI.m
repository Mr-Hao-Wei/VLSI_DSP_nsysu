function y = ID2tI(m,n,x)
y = zeros(m*n*2,1);
v = 0:n:n;
u = 0:n:2*n;
for i = 0:m-1
   for j = 0:n-1
      y(v+i*2*n+j+1) = D2t(x(u+i*3*n+j+1));
   end
end
