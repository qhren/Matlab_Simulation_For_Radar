x = linspace(0, 20, 500);
N = [1, 3, 6, 10];
Label = cell(1,length(N));
figure (1);
for i = 1:length(N)
    result = 1 - gammainc(x, N(i), 'lower');
%   result = incomp_gamma(x, N(i)); % 近似公式中出现的计算误差不知如何消除
    plot(x, result, 'LineWidth', 1.5);
    hold on;
    Label{i} = strcat('N=', num2str(N(i)));
end
hold off;
title('False Alarm Rate');
xlabel('Vt')
ylabel('Possibility of False Alarm');
legend(Label);

%% Plot the curve of threshold
figure (2);
Np = linspace(1, 100, 100);
Nfa = [1000, 10000, 500000];
v_temp = zeros(1, 100);
Label_Nfa = cell(1, length(Nfa));
for Nfa_index = 1: length(Nfa)
    for j = 1:length(Np)
        [Pfa, v_temp(1, j)] = threshold(Nfa(Nfa_index), Np(j));
    end
    loglog(Np, v_temp, 'LineWidth', 1.5);
    hold on;
    Label_Nfa{Nfa_index} = strcat('Nfa = ', num2str(Nfa(Nfa_index)));
end
hold off;
title('Non-Coherent Pulse Integration threshold with nfa and np');
legend(Label_Nfa);
grid on;

