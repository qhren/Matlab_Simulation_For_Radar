%% Delay Test one
t = linspace(0, 1, 500);
% f =1Hz
y_1 = cos(2*pi*t);
y_2 = cos(2*pi*(t-0.2));% delay one-third period
y_3 = cos(2*pi*(t+0.2));% Advance one-third period
figure (1);
% 横坐标的Range固定，满足关系左加右减（延时右减）
plot(t, y_1,'r-', t, y_2, 'b--', t, y_3, 'k-.', 'LineWidth', 1.2);
legend('Transmit Signal', 'Delayed Signal', 'Advanced Signal');
xlabel('t/s');
ylabel('Amp');
hold on;
%% Delay Test two
t_1 = linspace(0, 1, 1000);
t_2 = t_1 + 0.2; % Delay Signal
t_3 = t_1 - 0.2; % Advanced Signal
% f=1Hz
y_1 = cos(2*pi*t_1);
y_2 = cos(2*pi*(t_2-0.2));% delay one-third period
y_3 = cos(2*pi*(t_3+0.2));% advance one-third period
figure(2);
subplot(3,1,1);
plot(t_1, y_1, 'r-', 'LineWidth', 1.2);
title('Transmit Signal');
subplot(3,1,2);
plot(t_2, y_2, 'b--', 'LineWidth', 1.2);
title('Delayed Signal');
subplot(3,1,3);
plot(t_3 ,y_3, 'k-.', 'LineWidth', 1.2);
title('Advanced Signal');