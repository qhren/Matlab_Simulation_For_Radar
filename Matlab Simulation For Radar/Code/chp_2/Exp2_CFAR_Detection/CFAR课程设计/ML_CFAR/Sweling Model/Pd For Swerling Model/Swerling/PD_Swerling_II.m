function [output] = PD_Swerling_II(pfa,np, snr)
%PD_SWERLING_II calculation of Pd for Swerling Model II
% input:false alarm rate, coherent integration pulses, snr

% SNR can be given in dB in a high probability
snr_numeric = 10.^(snr/10);
% pfa -> nfa
nfa = log(2)*np/pfa;
% calculate threshold
[~, Vt] = threshold(nfa, np);

% Calculate Probability of Detection
if np <= 50
    Pd = 1 - gammainc(Vt./(1 + snr_numeric), np);
else
    C_3 = -1/(3 * sqrt(np));
    C_4 = 1/(4 * np);
    C_6 = C_3^2/2;
    w_ = sqrt(np)*(1 + snr_numeric);
    
    V = (Vt - np*(1 + snr_numeric))./w_;
    Pd = erfc(V/sqrt(2))/2 - exp(-V.^2)/sqrt(2*pi).*(C_3.*(V.^2 -1) + C_4.*V.*(3-V.^2)...
    -C_6.*V.*(V.^4 - 10*V.^2+15));
end
output = Pd;
end