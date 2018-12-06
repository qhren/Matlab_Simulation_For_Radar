% a
B = 2e6;%Hz
Tfa = 12*60;%s
f0 = 1.5e9;
Pfa = 1/(Tfa*B);% False Alarm Rate
a = sqrt((10^(13.85/10)*2));
Pd = marcumq(a, sqrt(2*log(1/Pfa)));%调用系统中的marcum函数
c = 3e8;
Rmax = 12000;
Tr = 2*Rmax/c;
Fr = 1/Tr;
lambda = c/f0;
F = 8;
L = 4;
Te = 290;% Kelvin
S = 1.38e-23*290*10^(13.85/10)*10^(8/10)*B;
G = 5000;
RCS = 1;% m^2
Pt = S*(4*pi)^3*Rmax^4*10^(L/10)/(G^2*RCS*lambda^2);

% b 
SNR_single = 24.2661/(2*10) + sqrt((24.2661)^2/(4*100)+24.2661/10);
L_NCI = (1+SNR_single)/(SNR_single);
Gain = 10*log10(10)-10*log10(L_NCI);