function [output] = PD_Swerling_IV(pfa, np, snr_numeric)
%PD_SWERLING_IV Calculate the Probability of Detection for Swerling IV
%Model

% snr_numeric can be given in dB in a high probability
snr_numeric = 10.^(snr_numeric/10);
% pfa -> nfa
nfa = log(2)*np/pfa;

% Threshold calculation
[~, Vt] = threshold(nfa, np);

% caculate the probability of Detection
if np < 50
    r = cell(1, np + 1);% ´æ´¢ r ÏòÁ¿ 
    A = cell(1, 2);
    r{1, 1} = gammainc(Vt./(1 + snr_numeric/2), np, 'lower');
    A{1, 1} = (Vt./(1 + snr_numeric./2)).^np./...
           (factorial(np) .* exp(Vt./(1+snr_numeric./2)));
    for iter =1:np
        r{1, iter+1} =  r{1, iter} - A{1, 1};
        A{1, 2} = (Vt./(1 + snr_numeric./2))/(np + iter) .* A{1,1};
        A{1, 1} = A{1, 2};
    end
    
    r_ = zeros(1, length(snr_numeric));
    % ¼ÆËãPd
    for i = 2: np + 1
        r_ = r_ + ((snr_numeric./2).^(i-1)).*factori(np, i-1)/factorial(i-1)...
            .* r{1, i};
    end
    r_ = r_ + r{1, 1};
    Pd = 1 - r_.*(1 + snr_numeric/2).^(-np);
else
    beta = 1 + snr_numeric./2;
    C_3 = 1/(3*sqrt(np))*(2*beta.^3-1)./((2*beta.^2-1).^1.5);
    C_6 = C_3.^2/2;
    C_4 = 1/(4*np)*(2*beta.^4-1)./((2*beta.^2-1).^2);
    w_ = sqrt(np*(2*beta.^2 - 1));
    V = (Vt - np*(1 + snr_numeric))./w_;
    Pd = erfc(V/sqrt(2))/2 - exp(-V.^2)/sqrt(2*pi).*(C_3.*(V.^2 -1) + C_4.*V.*(3-V.^2)...
    -C_6.*V.*(V.^4 - 10*V.^2+15));
end
output = Pd;

end

