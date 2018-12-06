close all;clearvars;
% Radar_Eq Simulation

% Radar Basic Parameters
P_t = 1.5e6;
f_0 = 5.6e9;
k = 1.38e-23;
Gain = 45; %(dB) 换算成数值应用10^(Gain(dB)/10) 表示功率的放大倍数
T_e = 290; %(K)
L = 6;%(dB) 换算成数值应当用10^(L(dB)/10)
F = 3;%(dB) 换算成数值应当用10^(L(dB)/10)
B = 5e6;
R_min = 25;%(km)
R_max = 165;%(km)
c = 3e8;%(m)

%%
% Plot the Curve of SNR about Detection Range
R_var = linspace(25,165,200);%Divide Detection Range
sigma_dbsm = [0,-10,-20];%(dBsm)
SNR_o = zeros(length(sigma_dbsm), 200);
sigma_dB = 10.^(sigma_dbsm/10);
% 这里采用先转换成数值 计算完成后再转换成dB的形式
% 也验证了数值转换方式的正确性
for i=1:length(sigma_dbsm)
    SNR_o(i,:) = (P_t * (10^(Gain/10))^2 * (c/f_0)^2 * sigma_dB(i))./((4*pi)^3 * k * T_e * B...
    * (10^(F/10)) * (10^(L/10)) * (R_var*1000).^4);
end
figure (1);

Format_Color = ['r-', 'b-', 'k-'];
for i=1:length(sigma_dbsm)
    plot(R_var, 10*log10(SNR_o(i,:)), Format_Color(i), 'LineWidth', 1.2);
    hold on;
end
title('SNR_o about Dection Range');
xlabel('Detection Range in km');
ylabel('SNR_o in dB');
legend('\sigma = 0dbsm', '\sigma = -10dbsm', '\sigma = -20dbsm');
grid on;
hold off;
%%
% Plot the Curve of needed SNR_o about the Detection Range when changing P_t
P_t_var = 1e6*[0.6, 1.5, 2.16];
sigma_fix_dB = -10;
sigma_fix = 10.^(sigma_fix_dB/10);
SNR_o_1 = zeros(length(P_t_var), length(R_var));

for i=1:length(P_t_var)
    SNR_o_1(i,:) = (P_t_var(i) * (10^(Gain/10))^2 * (c/f_0)^2 * sigma_fix)./((4*pi)^3 * k * T_e * B...
    * (10^(F/10)) * (10^(L/10)) * (R_var*1000).^4);
end
figure (2);

Format_Color = ['r-', 'b-', 'k-'];
for i=1:length(P_t_var)
    plot(R_var, 10*log10(SNR_o_1(i,:)), Format_Color(i), 'LineWidth', 1.2);
    hold on;
end
title('SNR_o about Dection Range');
xlabel('Detection Range in km');
ylabel('SNR_o in dB');
legend('p_t=0.6MW', 'p_t=1.5MW', 'P_t=2.16MW');
grid on;
hold off;
%%
% Plot the Curve of the needed Pulse Width about the SNR_o when chaning R_var
R_fix_var = [75, 100, 150];%(km)
sigma_dB = -10;
% For Pulse Radar: pulse width = 1/B;
SNR_o_2 = linspace(5,20,100);
pulse_width = zeros(3,100);
for i = 1:length(R_fix_var)
    pulse_width(i,:) = (R_fix_var(i)*1000).^4 * ((4*pi)^3 * k * T_e * (10^(F/10))...
    * (10^(L/10)) * 10.^(SNR_o_2/10)) / (P_t * (10^(Gain/10))^2 * (c/f_0)^2 *...
    10^(sigma_dB/10));
end    
figure (3);
subplot(2,1,1);
Format_Color = ['r-', 'b-', 'k-'];
for i=1:length(R_fix_var)
    plot(SNR_o_2, pulse_width(i,:)*1e6, Format_Color(i), 'LineWidth', 1.2);
    hold on;
end
title('pulse width about SNR_o');
xlabel('SNR_o in dB');
ylabel('pulse width in us');
legend('R = 75km', 'R = 100km', 'R = 150 km');
grid on;
hold off;
subplot(2,1,2);
Format_Color = ['r-', 'b-', 'k-'];
for i=1:length(R_fix_var)
    plot(10.^(SNR_o_2/10), pulse_width(i,:)*1e6, Format_Color(i), 'LineWidth', 1.2);
    hold on;
end
title('pulse width about SNR_o');
xlabel('SNR_o in Numerical');
ylabel('pulse width in us');
legend('R = 75km', 'R = 100km', 'R = 150 km');
grid on;
hold off;
