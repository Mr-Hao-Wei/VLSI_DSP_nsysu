function x = KRED(P,E,K,x)
% x = KRED(P,E,K,x);
% P : P = [P(1),...,P(K)];
% E : E = [E(1),...,E(K)];
for i = 1:K
   a = prod(P(1:i-1).^E(1:i-1));
   c = prod(P(i+1:K).^E(i+1:K));
   p = P(i);
   e = E(i);
   for j = e-1:-1:0
      x(1:a*c*(p^(j+1))) = RED(p,a,c*(p^j),x(1:a*c*(p^(j+1))));
   end
end
