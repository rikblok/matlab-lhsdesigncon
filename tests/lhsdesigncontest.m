function lhsdesigncontest( )
%LHSDESIGNCONTEST Test for LHSDESIGNCON function.
%
%   Requires LHSDESIGNCON.
%
%   See also LHSDESIGNCON.


A = [1, 1; 1, -1]; b = [50; -25]; % A x <= b
x = lhsdesigncon(10000,2,[-100 1e-1],[100 1e2],[false true],A,b);
% Show samples are well distributed within constraints.
figure;
semilogy(x(:,1),x(:,2),'.');

end

