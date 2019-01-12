function [output] = PD_Swerling_V(pfa, np, snr)
% input paras:False Alarm Rate
%             Non-Coherent Pulses
%             Signal to Noise Ratio

% 
snr_numeric = 10.^(snr/10);
% pfa -> nfa
nfa = log(2)*np/pfa;
C_3 = -(snr_numeric + 1/3)./(sqrt(np)*(2*snr_numeric + 1).^1.5);
C_4 = (snr_numeric + 1/4)./(np*(2*snr_numeric + 1).^2);
C_6 = C_3.^2/2;
w_ = sqrt(np*(2*snr_numeric + 1));
[~, Vt] = threshold(nfa, np);
V = (Vt - np*(1 + snr_numeric))./w_;

% calculation the probability of Detection
Pd = erfc(V/sqrt(2))/2 - exp(-V.^2)/sqrt(2*pi).*(C_3.*(V.^2 -1) + C_4.*V.*(3-V.^2)...
    -C_6.*V.*(V.^4 - 10*V.^2+15));

% Return Pd
output =Pd;
end