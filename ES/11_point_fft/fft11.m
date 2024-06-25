function y = fft11(x,u,ip,op)
% y = fft11(x,u,ip,op)
% y  : the 11 point DFT of x 
% u  : a vector of precomputed multiplicative constants
% ip : input permutation
% op : ouput permutation

y = zeros(11,1);
x = x(ip);                                        % input permutation
x(2:11) = KRED([2,5],[1,1],2,x(2:11));            % reduction operations
y(1) = x(1)+x(2);                                 % DC term calculation
% -------------------- block : 1 -------------------------------------------------
y(2) = x(2)*u(1);                       
% -------------------- block : 2 -------------------------------------------------
y(3) = x(3)*u(2);                       
% -------------------- block : 5 -------------------------------------------------
v = ID2I(1,2,x(4:7));              % v = (I(1) kron D2 kron I(2)) * x(4:7)
v = ID2I(3,1,v);                   % v = (I(3) kron D2 kron I(1)) * v
v = v.*u(3:11);                         
v = ID2tI(1,3,v);                  % v = (I(1) kron D2' kron I(3)) * v
y(4:7) = ID2tI(2,1,v);             % y(4:7) = (I(2) kron D2' kron I(1)) * v
% -------------------- block : 10 = 2 * 5 ----------------------------------------
v = ID2I(1,2,x(8:11));             % v = (I(1) kron D2 kron I(2)) * x(8:11)
v = ID2I(3,1,v);                   % v = (I(3) kron D2 kron I(1)) * v
v = v.*u(12:20);                        
v = ID2tI(1,3,v);                  % v = (I(1) kron D2' kron I(3)) * v
y(8:11) = ID2tI(2,1,v);            % y(8:11) = (I(2) kron D2' kron I(1)) * v
% --------------------------------------------------------------------------------
y(2) = y(1)+y(2);                                 % DC term calculation
y(2:11) = tKRED([2,5],[1,1],2,y(2:11));           % transpose reduction operations
y = y(op);                                        % output permutation

% For complex data - 
% Total Number of Real Multiplications : 40
% Total Number of Real Additions: 168

