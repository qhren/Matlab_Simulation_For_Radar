%% calculation of threshold and false alarm rate Given nfa and Np
function [Pfa, Vt] = threshold(nfa, np)
% input nfa:Ðé¾¯Êý
% input np:Integrated Pulses
format long
eps = 1e-6;
Pfa = np * log(2)/nfa; % with Integration, false alarm rate change with Integrated Pulses
V_temp = zeros(1, 2);
V_temp(1) = np - sqrt(np) + 2.3 * sqrt(-log10(Pfa))*(sqrt(-log10(Pfa)) + sqrt(np) - 1);
Iter_cnt = 1;
while (abs(V_temp(2) - V_temp(1)) > V_temp(1)/1e4)
    if Iter_cnt >= 2
        V_temp(1) = V_temp(2);
    end
    G = (0.5)^(np/nfa) - gammainc(V_temp(1), np, 'lower');
    G1 = -exp(-V_temp(1))*V_temp(1)^(np - 1)/factorial(np - 1);
    V_temp(2) = V_temp(1) - G/(G1 + eps) ;
    Iter_cnt = Iter_cnt + 1;
end
Vt = V_temp(2);
end