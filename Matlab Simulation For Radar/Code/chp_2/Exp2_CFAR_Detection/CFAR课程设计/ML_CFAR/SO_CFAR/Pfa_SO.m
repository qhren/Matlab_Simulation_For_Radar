function [Pfa_go] = Pfa_SO(T, N)
%Pfa_So SO_CFAR方法中根据虚警概率求 标称化因子的值 
temp_sum = 0;
for i = 0:N-1
    temp_sum =temp_sum + nchoosek(N + i - 1, i) * (2 + T).^(-(N+i));
end
Pfa_go = 2 * temp_sum;
end


