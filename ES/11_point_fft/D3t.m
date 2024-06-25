function y = D3t(x)
y = zeros(3,1);
y(1) = x(2)+x(3)+x(4);
a = x(4)+x(4);
y(2) = x(2)-x(3)+a;
y(3) = y(1)+x(4)+a;
y(1) = y(1)+x(1);
y(3) = y(3)+x(5);
