%% Swerling V Model
Pfa = 1e-9;
np_V = [1, 10];
snr = linspace(-10, 30, 500);% in form of dB
V_Label = cell(1,length(np_V));
figure (1);
for i = 1:length(np_V)
    plot(snr, PD_Swerling_V(Pfa, np_V(i), snr), 'LineWidth', 1.5);
    V_Label{i} = strcat('Np = ', num2str(np_V(i)));
    hold on;
end
hold off;
grid on;
title('Pd on Swerling V Model');
xlabel('SNR/dB');
ylabel('Probability of Detection');
legend(V_Label);

%% Swerling I Model

% Compare with Swerling V Model
np_I = 1;
Pfa = 1e-9;
figure (2);
plot(snr, PD_Swerling_V(Pfa, np_I, snr),snr + 0.24, ...
    PD_Swerling_I(Pfa, np_I, snr), snr, PD_Swerling_II(Pfa, np_I, snr), ...
    snr + 0.24, PD_Swerling_III(Pfa, np_I, snr), snr, PD_Swerling_IV(Pfa, np_I, snr),...
    'LineWidth', 1.5);
grid on;
legend('Probability of Swerling V','Probability of Swerling I', ...
    'Probability of Swerling II','Probability of Swerling III',...
    'Probability of Swerling IV');
title('Compare Swerling Model');
xlabel('SNR/dB');
ylabel('Probability of Detection');

% PD Relation with np and snr
figure (3);
Pfa = 1e-8;
Np_I = [1, 10, 50, 100];
V_Label = cell(1,length(Np_I));
for i = 1:length(Np_I)
    plot(snr, PD_Swerling_I(Pfa, Np_I(i), snr), 'LineWidth', 1.5);
    V_Label{i} = strcat('Np = ', num2str(Np_I(i)));
    hold on;
end
hold off;
grid on;
title('Pd on Swerling I Model');
xlabel('SNR/dB');
ylabel('Probability of Detection');
legend(V_Label);

%% Swerling II Model

figure (4);
Pfa = 1e-10;
Np_II = [1, 10, 50, 100];
V_Label = cell(1,length(Np_II));
for i = 1:length(Np_II)
    plot(snr, PD_Swerling_II(Pfa, Np_II(i), snr), 'LineWidth', 1.5);
    V_Label{i} = strcat('Np = ', num2str(Np_II(i)));
    hold on;
end
hold off;
grid on;
title('Pd on Swerling II Model');
xlabel('SNR/dB');
ylabel('Probability of Detection');
legend(V_Label);

%% Swerling III Model

figure (5);
Pfa = 1e-9;
Np_III = [1, 10, 50, 100];
V_Label = cell(1,length(Np_III));
for i = 1:length(Np_III)
    plot(snr, PD_Swerling_III(Pfa, Np_III(i), snr), 'LineWidth', 1.5);
    V_Label{i} = strcat('Np = ', num2str(Np_III(i)));
    hold on;
end
hold off;
grid on;
title('Pd on Swerling III Model');
xlabel('SNR/dB');
ylabel('Probability of Detection');
legend(V_Label);

%% Swerling IV Model

figure (6);
Pfa = 1e-9;
Np_IV = [1, 10, 50, 100];
V_Label = cell(1,length(Np_IV));
for i = 1:length(Np_IV)
    plot(snr, PD_Swerling_IV(Pfa, Np_IV(i), snr), 'LineWidth', 1.5);
    V_Label{i} = strcat('Np = ', num2str(Np_IV(i)));
    hold on;
end
hold off;
grid on;
title('Pd on Swerling IV Model');
xlabel('SNR/dB');
ylabel('Probability of Detection');
legend(V_Label);


