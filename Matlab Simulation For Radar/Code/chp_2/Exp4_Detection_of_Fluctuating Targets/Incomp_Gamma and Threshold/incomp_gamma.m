function [output] = incomp_gamma(x,N_)
%INCOMP_GAMMA calculaton of Incomplete Gamma Function
%   return a value
format long
Vt = x;

sum = 0;
for i=1:N_
    sum = sum + factor(N_, i)./(Vt.^i);
sum = sum + 1;
value = (Vt.^N_) .* exp(-Vt)/factori(N_, N_) .* sum;
output = value;
end

