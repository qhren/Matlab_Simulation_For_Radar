%% 静止目标
n_scatter = 3;% 散射体个数
range_scatter = [908, 910, 912];% 散射体向量

% closing condition 1
% range_scatter = [909.8, 910, 912];
% 
% % closing condition 2
% range_scatter = [909.5, 910, 912];
% 
% % closing condition 3
% range_scatter = [909.2, 910, 912];

% unambiguious range widow
% range_scatter = [908, 910, 912, 920];

rcs_scat = [100, 10, 1];% 散射体的 RCS向量
n = 64;% 单个脉冲串包含的脉冲的个数
delta_f = 10e6;% 步进频率为10Mhz
win_bool = 0;% 是否对信号进行加窗
SNR_dB = 40;% 修正40dB

% 固定的参数
c = 3e8;
num_pulses = n;
freq_step = delta_f;

% 回波信号的正交分量的提取
% 内存预分配
% I Q两路回波信号采样
Inphase_tgt = zeros(num_pulses, 1);
Quadrature_tgt = zeros(num_pulses, 1);
% I Q两路频域采样信号（加窗后）
Weighted_I_freq_domain = zeros((num_pulses), 1);
Weighted_Q_freq_domain = zeros((num_pulses), 1);
% I Q两路信号合成一路复信号 并补充0元素
% FFT 和 IFFT 都满足叠加原理
Weighted_IQ_freq_domain = zeros((2*num_pulses), 1);
for jscat = 1:n_scatter
   ii = 0;
   for i = 1:num_pulses
      ii = ii+1;
      rec_freq = ((i - 1)*freq_step);
      Inphase_tgt(ii) = Inphase_tgt(ii) + sqrt(rcs_scat(jscat)) * cos(-2*pi*rec_freq*...
          2*range_scatter(jscat)/c);
      Quadrature_tgt(ii) = Quadrature_tgt(ii) + sqrt(rcs_scat(jscat))*sin(-2*pi*rec_freq*...
          2*range_scatter(jscat)/c);
   end
end

if(win_bool >= 0)
    window(1:num_pulses) = hamming(num_pulses);
else
    window(1:num_pulses) = 1;
end

Inphase = Inphase_tgt;
Quadrature = Quadrature_tgt;
% 加窗
Weighted_I_freq_domain(1:num_pulses) = Inphase(1:num_pulses).* window';
Weighted_Q_freq_domain(1:num_pulses) = Quadrature(1:num_pulses).* window';
% 合成一路复信号
Weighted_IQ_freq_domain(1:num_pulses)= Weighted_I_freq_domain + ...
   Weighted_Q_freq_domain*1i;
Weighted_IQ_freq_domain(num_pulses:2*num_pulses)=0.+0.i;
% 进行反变换 得到一维距离像
Weighted_IQ_time_domain = (ifft(Weighted_IQ_freq_domain));
abs_Weighted_IQ_time_domain = (abs(Weighted_IQ_time_domain));
dB_abs_Weighted_IQ_time_domain = 20.0*log10(abs_Weighted_IQ_time_domain)+SNR_dB;
% Plot Figure
Ru = c /2/delta_f;% 不模糊距离窗的大小

numb = 2*num_pulses;% 距离分辨单元的个数
delx_meter = Ru / numb;
xmeter = 0:delx_meter:Ru-delx_meter;
figure (1);
plot(xmeter, dB_abs_Weighted_IQ_time_domain,'k-', 'LineWidth', 1.0);
% xlabel ('relative distance - meters');
% ylabel ('Range profile - dB');
% grid on;
hold on;
%% 匀速运动目标
n_scatter = 3;% 散射体个数
range_scatter = [908, 910, 912];% 散射体向量

rcs_scat = [100, 10, 1];% 散射体的 RCS向量
n = 64;% 单个脉冲串包含的脉冲的个数
delta_f = 10e6;% 步进频率为10Mhz
prf = 10e3;% 脉冲重复频率10Khz
win_bool = 0;% 是否对信号进行加窗
SNR_dB = 40;% 修正40dB
r_note = 900;% 距离像的起点
v = 200;% metre per second

% 固定的参数
c = 3e8;
num_pulses = n;
PRI = 1./prf;% 脉冲重复周期
nfft = 2*num_pulses;% 作ifft的点数
freq_step = delta_f;
taur = 2*r_note/c;

% 回波信号的正交分量的提取
% 内存预分配
% I Q两路回波信号采样
Inphase_tgt = zeros(num_pulses, 1);
Quadrature_tgt = zeros(num_pulses, 1);
% I Q两路频域采样信号（加窗后）
Weighted_I_freq_domain = zeros((num_pulses), 1);
Weighted_Q_freq_domain = zeros((num_pulses), 1);
% I Q两路信号合成一路复信号 并补充0元素
% FFT 和 IFFT 都满足叠加原理
Weighted_IQ_freq_domain = zeros((2*num_pulses), 1);
for jscat = 1:n_scatter
   ii = 0;
   for i = 1:num_pulses
      ii = ii+1;
      rec_freq = ((i - 1)*freq_step);
      Inphase_tgt(ii) = Inphase_tgt(ii) + sqrt(rcs_scat(jscat)) * cos(-2*pi*rec_freq*...
          (2*range_scatter(jscat)/c - 2*(v/c)*((i-1)*PRI + taur/2 + 2*range_scatter(jscat)/c)));
      Quadrature_tgt(ii) = Quadrature_tgt(ii) + sqrt(rcs_scat(jscat))*sin(-2*pi*rec_freq*...
          (2*range_scatter(jscat)/c - 2*(v/c)*((i-1)*PRI + taur/2 + 2*range_scatter(jscat)/c)));
      
        % 观察相位偏移项的第一项的影响(无法观察 会抵消带来的偏移)
%       Inphase_tgt(ii) = Inphase_tgt(ii) + sqrt(rcs_scat(jscat)) * cos(-2*pi*rec_freq*...
%           (2*range_scatter(jscat)/c - 2*(v/c)*(taur/2 + 2*range_scatter(jscat)/c)));
%       Quadrature_tgt(ii) = Quadrature_tgt(ii) + sqrt(rcs_scat(jscat))*sin(-2*pi*rec_freq*...
%           (2*range_scatter(jscat)/c - 2*(v/c)*(taur/2 + 2*range_scatter(jscat)/c)));
      
        % 观察相位偏移项第二项的影响(主瓣展宽 峰值下降)
%         Inphase_tgt(ii) = Inphase_tgt(ii) + sqrt(rcs_scat(jscat)) * cos(-2*pi*rec_freq*...
%             (2*range_scatter(jscat)/c - 2*(v/c)*((i-1)*PRI)));
%         Quadrature_tgt(ii) = Quadrature_tgt(ii) + sqrt(rcs_scat(jscat))*sin(-2*pi*rec_freq*...
%             (2*range_scatter(jscat)/c - 2*(v/c)*((i-1)*PRI)));
   end
end

if(win_bool >= 0)
    window(1:num_pulses) = hamming(num_pulses);
else
    window(1:num_pulses) = 1;
end

Inphase = Inphase_tgt;
Quadrature = Quadrature_tgt;
% 加窗
Weighted_I_freq_domain(1:num_pulses) = Inphase(1:num_pulses).* window';
Weighted_Q_freq_domain(1:num_pulses) = Quadrature(1:num_pulses).* window';
% 合成一路复信号
Weighted_IQ_freq_domain(1:num_pulses)= Weighted_I_freq_domain + ...
   Weighted_Q_freq_domain*1i;
Weighted_IQ_freq_domain(num_pulses:2*num_pulses)=0.+0.i;
% 进行反变换 得到一维距离像
Weighted_IQ_time_domain = (ifft(Weighted_IQ_freq_domain));
abs_Weighted_IQ_time_domain = (abs(Weighted_IQ_time_domain));
dB_abs_Weighted_IQ_time_domain = 20.0*log10(abs_Weighted_IQ_time_domain)+SNR_dB;
% Plot Figure
Ru = c /2/delta_f;% 不模糊距离窗的大小

numb = 2*num_pulses;% 距离分辨单元的个数
delx_meter = Ru / numb;
xmeter = 0:delx_meter:Ru-delx_meter;
% figure (2);
plot(xmeter, dB_abs_Weighted_IQ_time_domain,'r--', 'LineWidth', 1.0);
xlabel ('relative distance - meters');
ylabel ('Range profile - dB');
grid on;
hold off;