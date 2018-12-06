function [Pd] = Marcum(a, b)
%MARCUM function Numerical Integration to compute Pd
%  input: alpha and beta two params
%  output: a real number

% Value Initialization
alpha = zeros(1,2);
beta = zeros(1, 2);
d = zeros(1, 2);
alpha(1) = 0;
if a >= b
    alpha(2) = 0;
    d(1) = b/a;
else
    alpha(2) = 1;
    d(1) = a/b;
end
beta(1) = 0;
beta(2) = 0.5;
d(2) = d(1);

% Iteration
n = 1;
while beta(2) < 1e3
    if a >= b
        temp = 1 - ((alpha(2)/(2*beta(2)))*exp(-(a-b)^2/2));
   else
        temp = (alpha(2)/(2*beta(2)))*exp(-(a-b)^2/2);
    end
    temp_alpha = d(2) + 2*n/(a*b)*alpha(2) + alpha(1);
    temp_beta = 1 + 2*n/(a*b)*beta(2) + beta(1);
    alpha(1) = alpha(2);
    alpha(2) = temp_alpha;
    beta(1) = beta(2);
    beta(2) = temp_beta;
    d(2) = d(2)*d(1);
    n = n + 1;
end
Pd = temp;
end

