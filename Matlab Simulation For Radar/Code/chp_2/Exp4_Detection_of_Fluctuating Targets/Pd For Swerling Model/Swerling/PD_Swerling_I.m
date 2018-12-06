function [output] = PD_Swerling_I(pfa,np, snr)
%PD_SWERLING_I calculation the probability of detection for Swerling I
%Model
%input: False Alarm Rate and Non-Coherent Integration Pulses

% SNR can be given in dB in a high probability
snr_numeric = 10.^(snr/10);
% pfa -> nfa
nfa = log(2)*np/pfa;

% Solve threshold
[~, Vt] = threshold(nfa, np);

% Solve Pd
if np == 1
    Pd = exp(-Vt./(1 + snr_numeric));
else
    Pd = 1 - gammainc(Vt, np-1, 'lower') + (1 + 1./(np*snr_numeric)).^(np - 1)...
        .* gammainc(Vt./(1 + 1./(np*snr_numeric)), np - 1, 'lower').* ...
        exp(-Vt./(1 + np*snr_numeric));
end
% Retrun Pd
output = Pd;
end

