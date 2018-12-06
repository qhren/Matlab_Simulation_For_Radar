%% 测试指数平均的效果
% 产生0到1之间均匀分布的随机数
size = [1, 100];
index = sort(rand(size));
y_index = sin(2*pi*index);

% 绘制正弦函数的图
figure (1);
plot(index, y_index, 'r', 'linewidth', 2);
axis([-0.2, 1.2, -1.2, 1.2]);
hold on;

% 添加噪声
noise_square = 0.1;
y_awgn = noise_square * randn(size) + y_index;
plot(index, y_awgn, 'bo');
hold on;

%% 指数平均
% 设定指数平均的初始值
v = zeros(1, length(y_awgn) + 1);
v_norm = zeros(1, length(y_awgn) + 1);
v(1) = 0;
v_norm(1) = 0;
beta = 0.9;

n_points = 1/(1-beta);
% 
% % 构造权重系数向量
% exp_coefficients = zeros(1, n_points + 1);% 加上当前点的系数
% exp_coefficients(1) = beta^n_points;
% for i = 2:(n_points+1)
%     exp_coefficients(i) = (1 - beta) * beta^(n_points + 1 - i);
% end

for i = 1:length(y_awgn)
    v(i+1) = beta * v(i) + (1-beta) * y_awgn(i);
    % 系数修正
    % 系数修正中的用的v是未修正的
    v_norm(i+1) = (beta * v(i) + (1-beta) * y_awgn(i)) * (1 - beta^i);
end

plot(index, v(2:end), 'k+', index, v_norm(2:end), 'y*');
plot(index, v_norm(2:end), 'y*');
title('指数平均');
xlabel('t');
ylabel('value');
grid on;
hold off;
legend("y=sin(2*\pi*x)", "加噪后" ,"指数平均\beta="+num2str(beta), "系数修正后");
