function [Pd_go] = Pd_SO(T, SNR_numeric, N)
%PD_GO 给定标称化因子和信噪比，计算GO_CFAR的检测概率
% input:给定虚警概率下的标称化因子 T，SNR的数值形式，以及半滑窗宽度
temp_sum = 0;
for i = 0:N-1
    temp_sum =temp_sum + nchoosek(N + i - 1, i) * (2 + T./(1 + SNR_numeric)).^(-(N+i));
end
Pd_go =  2 * temp_sum;
end

