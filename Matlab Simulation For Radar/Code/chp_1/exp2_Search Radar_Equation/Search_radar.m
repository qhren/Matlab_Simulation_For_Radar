% Inplements the Search Radar Equation
%%
% Given Other Parameters, Compute How much the Power Apeture we need.

% Basic Parameter
T_sc = 2.5;% Scan Time
T_e = 900; % Noise Temperature (K)
SNR_o_dB = 13;% Signal To Noise Ratio
Theta_e = 2;% Elevation Search range(degree)
Theta_a = 2;% Azimuth Search Range(degree)
F_L_pro = 13;%(dB)
R_min = 25;%(Km)
R_max = 250;%(Km)
k = 1.38e-23;% Boltzman's Const
% Assume alpha =1(Antenna Gain中的系数）

% Plot The Curve of Power Apeture changing with Range(Differ Sigma)

% Input Parameter
R_input = linspace(25,250,200);
Sigma_Input_Num = [1,0.1,0.01];% in Numerical
% Compute Parameter
Omega = (Theta_a*Theta_e)/(57.296)^2;% in steradians 
Power_A_pro = zeros(length(Sigma_Input_Num),length(R_input));
for i = 1:length(Sigma_Input_Num)
    Power_A_pro(i,:) =  10^(SNR_o_dB/10)*4*pi*k*T_e*10^(F_L_pro/10)*(R_input*1000)...
        .^4*Omega/Sigma_Input_Num(i);
end
Color_Control=['r-','b-','k-'];

figure (1);
for i=1:length(Sigma_Input_Num)
    plot(R_input,10*log10(Power_A_pro(i,:)),Color_Control(i),'LineWidth',1.2);
    hold on;
end
hold off;
title('Power Apeture about Detection Range in km');
xlabel('Detection Range in kilometers');
ylabel('Power Apeture in dB');
legend('\sigma=0dbsm','\sigma=-10dbsm','\sigma=-20dbsm');
grid on;
%% 
% Plot the Curve of Power_average about the Antenna Apeture Size Given
% other paramters,while changing sigma

% Input Parameters
R_fix = 250;%(Km)
Apeture_size = linspace(2,25,200);
Power_average = zeros(length(Sigma_Input_Num),length(Apeture_size));
for i = 1:length(Sigma_Input_Num)
    Power_average(i,:) = 10^(SNR_o_dB/10)*4*pi*k*T_e*10^(F_L_pro/10)*(R_fix*1000)...
        ^4*Omega/Sigma_Input_Num(i)./Apeture_size;
end

figure (2);
for i=1:length(Sigma_Input_Num)
    plot(Apeture_size,10*log10(Power_average(i,:)),Color_Control(i),'LineWidth',1.2);
    hold on;
end
hold off;
title('Power average about Apeture size in m^2');
xlabel('Apeture size in m^2');
ylabel('Power average in dB');
legend('\sigma=0dbsm','\sigma=-10dbsm','\sigma=-20dbsm');
grid on;









