function x = tKRED(P,E,K,x)
% x = tKRED(P,E,K,x);
% (transpose)
% P : P = [P(1),...,P(K)];
% E : E = [E(1),...,E(K)];
for i = K:-1:1
   a = prod(P(1:i-1).^E(1:i-1));
   c = prod(P(i+1:K).^E(i+1:K));
   p = P(i);
   e = E(i);
   for j = 0:e-1
      x(1:a*c*(p^(j+1))) = tRED(p,a,c*(p^j),x(1:a*c*(p^(j+1))));
   end
end
