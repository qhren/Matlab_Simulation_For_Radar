Points = 200;
SNR = linspace(1,18,Points);% in dB
False_Alarm_List = [1e-2, 1e-4, 1e-6, 1e-8, 1e-10, 1e-12];
Legend_List = cell(1,length(False_Alarm_List));
Temp = zeros(1,200);
a = sqrt(2*10.^(SNR/10)); % Marcum Function input
for K = 1:length(False_Alarm_List)
    for i = 1:Points
        Temp(i) = Marcum(a(i), sqrt(2*log(1/False_Alarm_List(K))));
    end
    Legend_List{K} = strcat('Probability of Detection = ', num2str(False_Alarm_List(K)));
    plot(SNR, Temp,'linewidth', 1.2);    hold on;
end
hold off;
grid on;
title('Probability of Detection--SNR');
xlabel('SNR/dB');
ylabel('Probability of Detection');
legend(Legend_List);