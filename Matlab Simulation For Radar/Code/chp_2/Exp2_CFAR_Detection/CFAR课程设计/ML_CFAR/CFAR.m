%% Params Setting
% 采用PR雷达体制 使用线性调频信号进行调制
B = 2e6;% 带宽设置为2MHz
PRI = 1e-3;% 脉冲重复周期设置成2ms
taur = 2e-4;% 脉冲宽度设置为0.2ms
Fs = 2*B;% 系统的采样率设置为2倍带宽
c = 3e8;% 电磁波传播的速度
% 默认天线收发共用
% 在发射脉冲的时刻无法接收回波信号

% Paras Computing
% 不考虑相应的taur的设置下，辐射能量能否满足远距离探测的需求
% 距离探测的范围为：30km->150km（对应于发射脉冲的脉冲宽度和脉冲重复间隔值）
% 距离分辨率为：75m(delta_R = c/2B)
%% Notes
% 为了方便实验，不考虑载频（载频设置为0频）
% 不考虑杂波背景，只在高斯白噪声背景下进行实验

%  Notes
% 发射线性调频脉冲信号
% j = sqrt(-1);
% u = B/taur; % 线性调频信号的调制系数
% t = 0:1/Fs:taur;
% transmitted_signal = exp(j*2*pi*u*t.^2);

% 目标设置
% R = 100e3;% 静止目标位于径向距离100km处

% 接收信号

% delay = 2*R/c;
% sigma = 0.1;% 噪声的标准差
% alpha = 0.5;% 回波幅度衰减
% 对发射的线性调频信号采用脉冲压缩，脉冲宽度变为：1/B = 5e-7
% 采样率为 Fs = 2*B，采样时间为2.5e-7
% 单个距离单元 所对应的回波脉冲（经脉冲压缩后） 一般只有一个采样点
% 为了便于实验，以下不对脉冲压缩的实验过程进行仿真

delta_R = c/(2*B);
% 观测的回波的距离单元
range_bins = 1:1:(1/2*c*PRI - 1/2*c*taur)/(delta_R);
% 两路正交 guass_noise
sigma = 0.5;% 设置单路噪声的标准差
% 噪声功率等于噪声方差
noise_channel_i = sigma * randn(1, length(range_bins));
noise_channel_q = sigma * randn(1, length(range_bins));
% 经平方律检波器->指数分布/卡方分布
V = noise_channel_i.^2 + noise_channel_q.^2;
% 经平方律检波器后 噪声功率为两路高斯噪声的功率的和

% 设定目标
index = 200;% 目标位于第200个距离单元处
SNR_dB = 30;% 信噪比设置为30dB
SNR_numeric = 10^(SNR_dB/10);% 信噪比的数值形式
% 目标的回波功率（经过平方律检波器）
target_echo = SNR_numeric * 2 * sigma^2;

echo_ = V;echo_(index) = target_echo;

%%% Single Target with Square Law Detection
% Normal Conditions：均匀杂波(噪声)背景（Unifrom Clutter Background）
%% Threshold Compare
% 针对于距离单元进行仿真
N = 20;% 滑动窗口选择为20个距离单元（前后选择10个）

% 估计噪声的功率（假设均值已知为0，只需要对噪声的方差进行估计）
% 实际中应当设置guard cells（防止目标的能量泄露）
% 仿真时只考虑目标全部落入一个距离单元的情况
% 噪声功率的无偏估计(不平均 平均放到标称因子上)
noise_power_estimation = zeros(1, length((N/2+1):1:(length(range_bins)-N/2)));
for i = (N/2+1):1:(length(range_bins)-N/2)
    noise_power_estimation(i-N/2) = sum([echo_(i-N/2:i-1),echo_(i+1:i+N/2)]);
end
% 虚警率设置
% 虚警概率不依赖于噪声功率
Pfa = 1e-6;
T = Pfa^(-1/N) - 1;% 归一化的标称因子

% 可视化
figure (1);
plot(range_bins, 10*log10(echo_), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N/2+1):1:(length(range_bins)-N/2)), ...
    10*log10(T*noise_power_estimation), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins, repelem(10*log10(N * T * 2 * sigma^2), length(range_bins)),...
    'r--', 'LineWidth', 1.0);
hold off;
xlabel('距离单元/index');
ylabel('回波功率/dB');
title('CA-CFAR单元平均恒虚警');
legend('Echo', 'Estimate Threshold', 'Ideal Threshold');

%% 恒虚警率，检测概率和信噪比的关系(单个目标)
% 采样单元确定
N_test =20;
Pfa_test = [1e-3, 1e-5, 1e-7];
SNR_dB_test = linspace(10, 30, 400);
SNR_numeric_test = 10.^(SNR_dB_test/10);
T = Pfa_test.^(-1/N_test) - 1;% 归一化的标称因子
Label = cell(1, length(Pfa_test));
Color = {'r-', 'g-', 'b-'};
Pd = zeros(length(SNR_dB_test), length(Pfa_test));
figure (2);
for i = 1:length(Pfa_test)
    Pd(:, i) = (1 + T(i)./(1 + SNR_numeric_test)).^-N_test;
    plot(SNR_dB_test, Pd(:, i), char(string(Color(i))), 'LineWidth', 1.0);
    hold on;
    Label{i} = strcat('Pfa = ', num2str(Pfa_test(i)));
end
hold off;
grid on;
legend(Label);
xlabel('SNR/dB');
ylabel('Probability of Detection');
title('CA-CFAR Pd——SNR曲线');
%% 单目标下 采样单元N 对检测概率的影响
N_1 = 4:2:70;% 采样单元 N最好设置为偶数
SNR_dB_1 = 30;% 在信噪比为30dB的情形下进行测试
SNR_numeric_1 = 10^(SNR_dB_1/10);
Label_1 = cell(1, length(Pfa_test));
Color = {'r-', 'g-', 'b-'};
Pd = zeros(length(N_1), length(Pfa_test));
figure (3);
for i = 1:length(Pfa_test)
    T = Pfa_test(i).^(-1./N_1) - 1;% 归一化的标称因子
    Pd(:, i) = (1 + T./(1 + SNR_numeric_1)).^-N_1;
    plot(N_1, Pd(:, i), char(string(Color(i))), 'LineWidth', 1.0);
    hold on;
    Label_1{i} = strcat('Pfa = ', num2str(Pfa_test(i)));
end
hold off;
legend(Label_1);
xlim([0, 70]);
ylim([0.6, 1]);
grid on;
xlabel('采样的窗口数/个');
ylabel('Probability of Detection');
title('CA-CFAR Pd——采样单元曲线');
%% CA-CFAR Loss
% 由于对噪声功率估计不准所带来的损失（需要更大的信噪比）
Pd_2 = 0.9;
Pfa_2 = [1e-3, 1e-6];
N_2 = 4:2:70;% 采样单元的变化
Label_2 = cell(1, length(Pfa_2));
Color_1 = {'r-', 'b-'};
figure (4);
subplot(2,1,1);
for j = 1:length(Pfa_2)
    % 由于恒虚警处理带来的损失
    cfar_snr = ((Pd_2/Pfa_2(j)).^(1./N_2)-1)./(1 - Pd_2.^(1./N_2));
    actual_snr = log(Pfa_2(j)/Pd_2)/log(Pd_2);
    cfar_loss = 10*log10(cfar_snr./actual_snr);
    plot(N_1, cfar_loss, char(string(Color_1(j))), 'LineWidth', 1.0);
    hold on;
    Label_2{j} = strcat('Pd = ', num2str(Pd_2), 'Pfa = ', ...
        num2str(Pfa_2(j)));
end
hold off;
xlabel('采样单元的个数/个');
ylabel('CFAR loss/dB');
title('CFAR Loss——采样单元');
legend(Label_2);
grid on;

subplot(2,1,2);
Pd_3 = [0.9, 0.95];
Pfa_3 = 1e-6;
N_3 = 4:2:70;% 采样单元的变化
Color_2 = {'r-', 'b-'};
Label_3 = cell(1, length(Pd_3));
for j = 1:length(Pd_3)
    % 由于恒虚警处理带来的损失
    cfar_snr = ((Pd_3(j)/Pfa_3).^(1./N_3)-1)./(1 - Pd_3(j).^(1./N_3));
    actual_snr = log(Pfa_3/Pd_3(j))/log(Pd_3(j));
    cfar_loss = 10*log10(cfar_snr./actual_snr);
    if j == 2
        % 两个曲线重合
        plot(N_1 + 0.5, cfar_loss, char(string(Color_2(j))), 'LineWidth', 1.0);
    else
        plot(N_1, cfar_loss, char(string(Color_2(j))), 'LineWidth', 1.0);
    end
    hold on;
    Label_3{j} = strcat('Pd = ', num2str(Pd_3(j)), 'Pfa = ', ...
        num2str(Pfa_3));
end
hold off;
xlabel('采样单元的个数/个');
ylabel('CFAR loss/dB');
title('CFAR Loss——采样单元');
legend(Label_3);
grid on;

%%% 主要目标的 Reference Cells中包含次目标
% 如果目标尺寸过大（多个散射体落入多个距离单元，可能会存在类似的自遮蔽现象）
%% 参考单元包含强点目标的情形
% 容易产生漏警 可用 SO-CFAR方法进行改进
index_2 = 200;% 目标1位于第200个距离单元处
index_3 = 195;% 目标2位于第195个距离单元处
SNR_dB_2 = 30;% 目标1处的信噪比
SNR_dB_3 = 20;% 目标2处的信噪比
SNR_numeric_2 = 10^(SNR_dB_2/10);% 目标1的信噪比的数值形式
SNR_numeric_3 = 10^(SNR_dB_3/10);% 目标2的信噪比的数值形式
% 目标的回波功率（经过平方律检波器）
target_1_echo = SNR_numeric_2 * 2 * sigma^2;
target_2_echo = SNR_numeric_3 * 2 * sigma^2;
echo_1 = V;echo_1(index_2) = target_1_echo;echo_1(index_3) = target_2_echo;
N = 20;% 参考单元仍然选择为20个距离单元的长度

noise_power_estimation_1 = zeros(1, length((N/2+1):1:(length(range_bins)-N/2)));
for i = (N/2+1):1:(length(range_bins)-N/2)
    noise_power_estimation_1(i-N/2) = sum([echo_1(i-N/2:i-1),echo_1(i+1:i+N/2)]);
end

% 虚警概率不依赖于噪声功率
Pfa = 1e-6;
T_1 = Pfa^(-1/N) - 1;% 归一化的标称因子

% 可视化
figure (5);
plot(range_bins, 10*log10(echo_1), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N/2+1):1:(length(range_bins)-N/2)), ...
    10*log10(T_1*noise_power_estimation_1), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins, repelem(10*log10(N * T_1 * 2 * sigma^2), length(range_bins)),...
    'k--', 'LineWidth', 0.5);
hold off;
xlabel('距离单元/index');
ylabel('回波功率/dB');
title('CA-CFAR单元平均恒虚警');
legend('Echo', 'Estimate Threshold', 'Ideal Threshold');
% 提高参考单元的个数，在同等虚警概率下能够减小由于恒虚警带来的损失
% 单目标下能够使得检测概率提升
% 在多目标/强点干扰进入参考单元的情形下，干扰/杂波进入门限的概率也提升了，主目标的检测概率是下降的

%% 非均匀杂波背景
% 这里仍然假设 杂波仍然满足高斯分布
% 通过噪声功率的突变来模拟杂波的变化（非均匀性）
sigma_1 = 0.5;% 设置单路噪声的标准差
sigma_2 = 1;
% 噪声功率等于噪声方差
noise_channel_i_1 = [sigma_1 * randn(1, floor(length(range_bins)/2)),...
                   sigma_2 * randn(1, ceil(length(range_bins)/2))];
noise_channel_q_1 = [sigma_1 * randn(1, floor(length(range_bins)/2)),...
                    sigma_2 * randn(1, ceil(length(range_bins)/2))];
% 经平方律检波器->指数分布/卡方分布
V_1 = noise_channel_i_1.^2 + noise_channel_q_1.^2;

% 目标设置
index_4 = 200;
SNR_dB_4 = 30;
% 杂波边缘的低杂波区域的小目标可能出现漏警
index_5 = floor(length(range_bins)/2)-10;
SNR_dB_5 = 15;
% 在主目标旁设置干扰/次目标，观测影响
index_6 = 195;
SNR_dB_6 = 20;
% 杂波区域的高杂波区域可能出现虚警
echo_2 = V_1;echo_2(index_4) = 2 * sigma_1^2 * 10^(SNR_dB_4/10);
echo_2(index_5) = 2 * sigma_1^2 * 10^(SNR_dB_5/10);
echo_2(index_6) = 2 * sigma_1^2 * 10^(SNR_dB_6/10);
% 假定仍然看成均匀（高斯）杂波背景下的检测
N = 20;
Pfa = 1e-6;
T_2 = Pfa^(-1/N) - 1;% 归一化的标称因子

% GO_CFAR 方法求解门限
% 可根据虚警率求解标称化因子的值
% 因为GO_CFAR方法和SO_CFAR方法只使用了半滑窗口长度的功率（因此这里的窗口长度设置为之前的两倍）
N_4 = 40;
Pfa_Go_given = 1e-6;
T_calculate_Go = fzero(@(T)Pfa_GO(T, 20) - Pfa_Go_given, 0.5);% 设置迭代初值为0.5

% SO_CFAR 方法求解门限
Pfa_So_given = 1e-6;
T_calculate_So = fzero(@(T)Pfa_SO(T, 20) - Pfa_So_given, 0.5);% 设置迭代初值为0.5

% CA_CFAR 估计噪声功率
noise_power_estimation_2 = zeros(1, length((N/2+1):1:(length(range_bins)-N/2)));
for i = (N/2+1):1:(length(range_bins)-N/2)
    noise_power_estimation_2(i-N/2) = sum([echo_2(i-N/2:i-1),echo_2(i+1:i+N/2)]);
end

% GO_CFAR  SO_CFAR估计噪声功率
noise_power_estimation_3 = zeros(1, length((N_4/2+1):1:(length(range_bins)-N_4/2)));
noise_power_estimation_4 = zeros(1, length((N_4/2+1):1:(length(range_bins)-N_4/2)));
for i = (N_4/2+1):1:(length(range_bins)-N_4/2)
    noise_power_estimation_3(i-N_4/2) = max([sum(echo_2(i-N_4/2:i-1)),...
        sum(echo_2(i+1:i+N_4/2))]);
    noise_power_estimation_4(i-N_4/2) = min([sum(echo_2(i-N_4/2:i-1)),...
        sum(echo_2(i+1:i+N_4/2))]);
end

% 可视化
figure (6);
plot(range_bins, 10*log10(echo_2), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N/2+1):1:(length(range_bins)-N/2)), ...
    10*log10(T_2*noise_power_estimation_2), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N_4/2+1):1:(length(range_bins)-N_4/2)), ...
    10*log10(T_calculate_Go*noise_power_estimation_3), 'r-', ...
             'LineWidth', 1.0);
hold on;
plot(range_bins, [repelem(10*log10(N * T_2 * 2 * sigma_1^2),... 
                        floor(length(range_bins)/2)),...
                  repelem(10*log10(N * T_2 * 2 * sigma_2^2),... 
                        ceil(length(range_bins)/2))], 'k--',...
                        'LineWidth', 0.5);
hold on;
xlabel('距离单元/index');
ylabel('回波功率/dB');
title('CA-CFAR单元平均恒虚警');
legend('Echo', 'CA-CFAR Estimate Threshold', 'GO-CFAR Estimate Threshold',...
       'Ideal Threshold');
   
figure (7);
plot(range_bins, 10*log10(echo_2), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N/2+1):1:(length(range_bins)-N/2)), ...
    10*log10(T_2*noise_power_estimation_2), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N_4/2+1):1:(length(range_bins)-N_4/2)), ...
    10*log10(T_calculate_So*noise_power_estimation_4), 'b-', ...
             'LineWidth', 1.0);
hold on;
plot(range_bins, [repelem(10*log10(N * T_2 * 2 * sigma_1^2),... 
                        floor(length(range_bins)/2)),...
                  repelem(10*log10(N * T_2 * 2 * sigma_2^2),... 
                        ceil(length(range_bins)/2))], 'k--',...
                        'LineWidth', 0.5);
hold on;
xlabel('距离单元/index');
ylabel('回波功率/dB');
title('CA-CFAR单元平均恒虚警');
legend('Echo', 'CA-CFAR Estimate Threshold', 'SO-CFAR Estimate Threshold',...
       'Ideal Threshold');


%% GO_CFAR算法
% 给定虚警率Pfa_go，求门限值的数值解
N = 10;% 滑动窗口的长度设置为20
T_Go_Plot = 0:0.01:100;
temp_sum = zeros(1, length(T_Go_Plot));
for i = 0:N-1
    temp_sum =temp_sum + nchoosek(N + i -1, i) * (2 + T_Go_Plot).^(-(N+i));
end
Pfa_go_Plot = 2 * (1 + T_Go_Plot).^(-N) - 2 * temp_sum;
% 可视化 Pfa_Go 和标称化因子的关系
% 初步确定 标称化因子的范围
figure (8);
subplot(2, 1, 1);
plot(T_Go_Plot, Pfa_go_Plot, 'k-', 'LineWidth', 1.0);
xlabel('标称化因子的值');
ylabel('虚警概率');
title('直角坐标');
subplot(2, 1, 2);
Pfa_go_Plot(Pfa_go_Plot < 0) = 0;
semilogy(T_Go_Plot, Pfa_go_Plot, 'k-', 'LineWidth', 1.0);
grid on ;
xlabel('标称化因子的值');
ylabel('虚警概率/dB');
title('半对数坐标');

%% SO_CFAR 算法
N = 10;% 滑动窗口的长度设置为20
T_So_Plot = 0:0.01:100;
temp_sum = zeros(1, length(T_So_Plot));
for i = 0:N-1
    temp_sum =temp_sum + nchoosek(N + i -1, i) * (2 + T_So_Plot).^(-(N+i));
end
Pfa_so_Plot = 2 * temp_sum;
% 可视化 Pfa_So 和标称化因子的关系
% 初步确定 标称化因子的范围
figure (9);
subplot(2, 1, 1);
plot(T_So_Plot, Pfa_so_Plot, 'k-', 'LineWidth', 1.0);
xlabel('标称化因子的值');
ylabel('虚警概率');
title('直角坐标');
subplot(2, 1, 2);
Pfa_so_Plot(Pfa_so_Plot < 0) = 0;
semilogy(T_So_Plot, Pfa_so_Plot, 'k-', 'LineWidth', 1.0);
grid on ;
xlabel('标称化因子的值');
ylabel('虚警概率/dB');
title('半对数坐标');

%% 单脉冲（无干扰）平方律检波器，均匀杂波背景下的检测性能比较
N = [30, 50];
% 当 N 取值为20时，GO_CFAR方法和SO_CFAR方法 对门限的估计值不准
Pfa = 1e-6;
SNR_dB_ = linspace(10, 30, 400);
Pd = zeros(length(N), length(SNR_dB_));
Label_Compare_Cfar = cell(1, length(N) * 3 + 1);
Color = cell(2,3);
Color(1,:) = {{'k-'}, {'r-'}, {'b-'}};
Color(2,:) = {{'k--'}, {'r--'}, {'b--'}};
figure (10);
for i = 1:length(N)
    T_Cacfar = Pfa^(-1/N(i)) - 1;
    T_Gocfar = fzero(@(T)Pfa_GO(T,N(i)/2) - Pfa, 0.5);
    T_Socfar = fzero(@(T)Pfa_SO(T,N(i)/2) - Pfa, 0.5);
    plot(SNR_dB_, (1 + T_Cacfar./(1 + 10.^(SNR_dB_/10))).^-N(i), ...
        char(string(Color(i, 1))), 'LineWidth', 1.0);
    Label_Compare_Cfar(1, (i-1)*3 + 1) = {strcat('CA-CFAR', ':N=', num2str(N(i)))};
    hold on;
    plot(SNR_dB_, Pd_GO(T_Gocfar, 10.^(SNR_dB_/10), N(i)), ...
        char(string(Color(i, 2))), 'LineWidth', 1.0);
    Label_Compare_Cfar(1, (i-1)*3 + 2) = {strcat('GO-CFAR', ':N=', num2str(N(i)))};
    hold on;
    plot(SNR_dB_, Pd_SO(T_Socfar, 10.^(SNR_dB_/10), N(i)), ...
        char(string(Color(i, 3))), 'LineWidth', 1.0);
    Label_Compare_Cfar(1, (i-1)*3 + 3) = {strcat('SO-CFAR', ':N=', num2str(N(i)))};
    hold on;
end
T_optimal_estimation = Pfa^(-1/length(range_bins)) - 1;
plot(SNR_dB_, (1 + T_optimal_estimation./(1 + 10.^(SNR_dB_/10))).^-length(range_bins), ...
        'r+', 'LineWidth', 0.1);
Label_Compare_Cfar(1, end) = {'Approximately Optimal Estimate'};
xlabel('SNR/dB');
ylabel('The Probability of Detection');
title('Pd Compare with Pfa = 1e-6');
grid on;
legend(Label_Compare_Cfar);