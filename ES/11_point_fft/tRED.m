function y = tRED(p,a,c,x)
% y = tRED(p,a,c,x);
% (transpose)
y = zeros(a*c*p,1);
for i = 0:c:(a-1)*c
   for j = 0:c-1
      y(i*p+j+c*(p-1)+1) = x(i+j+1);
      for k = 0:c:c*(p-2)
         y(i*p+j+k+1) = x(i+j+1) + x(i*(p-1)+j+k+a*c+1);
         y(i*p+j+c*(p-1)+1) = y(i*p+j+c*(p-1)+1) - x(i*(p-1)+j+k+a*c+1);
      end
   end
end
