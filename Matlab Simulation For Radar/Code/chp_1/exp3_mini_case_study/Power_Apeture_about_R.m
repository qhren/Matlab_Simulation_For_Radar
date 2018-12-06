% Given Other Parameters, Compute How much the Power Apeture we need.

% Basic Parameter
T_sc = 2;% Scan Time
T_e = 290; % Common Noise Temperature (K)
SNR_o_dB = 13;% Signal To Noise Ratio
Theta_e = 10;% Elevation Search range(degree)
Theta_a = 360;% Azimuth Search Range(degree)
F = 8;%(dB)
L = 10;%(dB)
R_min = 2;%(Km)
R_max = 100;%(Km)
k = 1.38e-23;% Boltzman's Const
% Assume alpha =1(Antenna Gain中的系数）

% Plot The Curve of Power Apeture changing with Range(Differ Sigma)

% Input Parameter
R_input = 2:0.5:100;
Index = find(R_input==60);
Sigma_Input_dbsm = [6,-10];% in dbsm
% Compute Parameter
Omega = (Theta_a*Theta_e)/(57.296)^2;% in steradians 
Power_A_pro = zeros(length(Sigma_Input_dbsm),length(R_input));
for i = 1:length(Sigma_Input_dbsm)
    Power_A_pro(i,:) =  10^(SNR_o_dB/10)*4*pi*k*T_e*10^((F+L)/10)*(R_input*1000)...
        .^4*Omega/(10^(Sigma_Input_dbsm(i)/10));
end
Color_Control=['r-','b-'];

Text_y = 10*log10(Power_A_pro);
figure (1);
for i=1:length(Sigma_Input_dbsm)
    plot(R_input,10*log10(Power_A_pro(i,:)),Color_Control(i),'LineWidth',1.2);
    hold on;
end
hold off;
title('Power Apeture about Detection Range in km');
xlabel('Detection Range in kilometers');
ylabel('Power Apeture in dB');
text(60,Text_y(1,Index),strcat(num2str(Text_y(1,Index)),'dB Needed'));
text(60,Text_y(2,Index),strcat(num2str(Text_y(2,Index)),'dB Needed'));
legend('Aircraft','Missile');
grid on;
