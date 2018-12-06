function [output] = factori(N, index)
% ½×³Ë¼ÆËãN£¡
value = 1;
for i=1:index
    value = value * (N-i+1);
output = value;
end

