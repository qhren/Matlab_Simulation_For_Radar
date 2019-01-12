function [output] = PD_Swerling_III(pfa, np, snr)
%PD_SWERLING_III calculation Pd for Swerling Model III
% SNR can be given in dB in a high probability

% 原书中的表述出现了一些错误
snr_numeric = 10.^(snr/10);
% pfa -> nfa
nfa = log(2)*np/pfa;
% calculate threshold
[~, Vt] = threshold(nfa, np);

% calculate Probability of Detection
K0 = 1 + Vt./(1 + np*snr_numeric/2) - 2./(np*snr_numeric)*(np - 2);

if np==1||np==2
    Pd = exp(-Vt./(1 + np*snr_numeric/2)).*((1 + 2./(np*snr_numeric)).^(np-2)).*K0;
else
    % 对于Np的值大于2的情况 K0实际上发生了改变
    K0 = exp(-Vt./(1 + np*snr_numeric/2)).*((1 + 2./(np*snr_numeric)).^(np-2)).*K0;
    Pd = (Vt^(np-1))*exp(-Vt)./((1 + np*snr_numeric/2)*factorial(np-2))...
        + 1 - gammainc(Vt, np-1,'lower') + K0.* gammainc(Vt./(1 + 2./(np*snr_numeric)), np-1); 
end

% Reference Code
% temp1 = Vt ./ (1.0 + 0.5 * np *snr_numeric);
% temp2 = 1.0 + 2.0 ./ (np * snr_numeric);
% temp3 = 2.0 * (np - 2.0) ./ (np * snr_numeric);
% ko = exp(-temp1) .* temp2.^(np-2.) .* (1.0 + temp1 - temp3);
% if (np <= 2)
%     Pd = ko;
% else
%     temp4 = Vt^(np-1.) * exp(-Vt) ./ (temp1 * (factorial(np-2.)));
%     temp5 = Vt ./ (1.0 + 2.0 ./ (np *snr_numeric));
%     Pd = temp4 + 1.0 - gammainc(Vt, np-1., 'lower') + ko .* ...
%     gammainc(temp5, np-1., 'lower');
% end

output = Pd;
end

