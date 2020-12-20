% Plot the Power Spectral Density of M-PAM raised cosine and square pulses
% Author: Matt Blake (ID: 58979250)
% Date: 20/12/20


%% Clean up program
close all
clear
clc


%% Define values of system
Rb = 1*10^6; % The required maximum data rate (bps)
M = 4; % Order of PAM
R0 = 5; % Zeroth autocorrelation coefficient
Bt = [300000, 350000, 400000, 450000]; % Signal bandwidth
XrangeSquare = 15*10^5; % Square PSD will be plotted from (-XrangeSquare + 1) to +XrangeSquare (Hz)
XrangeNyquist = 6*10^5; % Square PSD will be plotted from (-XrangeNyquist + 1) to +XrangeNyquist (Hz)
channelBandlimit = 5*10^5; % Bandwidth limitations of channel (Hz)
Xstep = 100; % Resolution of PSD plot (Hz)


%% Calculate the PSD
PSDNyquistResults = {}; % Array to store the results of each different Bt
RolloffF = zeros(1, length(Bt)); % Array to store the roll-off factors for each Bt
for j = [1:1:length(Bt)]
    % Preform conversion calculations
    Tb = 1/Rb; % Calculate maximum time per bit in order to achieve Rb (s)
    Ts = log2(M) * Tb; % Calculate the maximum signal time in order to achieve Rb (s)
    Rs = 1/Ts; % Calculate the symbol rate to achieve Rb (bps)
    W = Rs/2; % Calculate the essential pulse width (folding frequency) in f domain (Hz)
    RolloffF(j) = 2*Bt(j)/Rs - 1; % Calculate the rolloff factor of a Nyquist Pulse
    f1 = W * (1 - RolloffF(j)); % Calculate the pulse's max amplitude frequency (Hz)

    % Define Pulse Shape PSD
    PpSquare = @(f) Ts * sinc(Ts * f); % The formula for the power spectral density of the pulse
    Pp1 = @(f) 1/(2*W); % 1st part of piecewise pulse function
    Pp2 = @(f) (1/(4*W))*(1-sin((pi*(abs(f)-W))/(2*W-2*f1))); % 2nd part of piecewise pulse function
    Pp3 = @(f) 0; % 3rd part of piecewise pulse function
    Condition1 = f1; % Upperbound of 1st part of piecewise function
    Condition2 = 2*W - f1; % Upperbound of 2nd part of piecewise function

    % Calculate required PSD forumlas
    Pm = R0; % The formula for the power spectral density of the message, based on autocorrelation
    
    % Calculate PSD values
    PSDNyquist = zeros(1, 2 * XrangeSquare/Xstep); % Yaxis of plot
    PSDsquare = zeros(1, 2 * XrangeSquare/Xstep); % Yaxis of square pulse plot
    freq = [-XrangeSquare + Xstep:Xstep:XrangeSquare]; % Xaxis of plot

    for i= [1:1:length(freq)]; % Iterate through all required frequencies
        if abs(freq(i)) < Condition1 % Select appropriate portion of peicewise function
            PpNyquist = Pp1;
        elseif (Condition1 <= abs(freq(i))) && (abs(freq(i)) <= Condition2)
            PpNyquist = Pp2;
        elseif abs(freq(i)) >= Condition2
            PpNyquist = Pp3;
        end
        SyNyquist = @(f) Pm * (PpNyquist(f))^2/(Ts); % The formula for power spectral density of the Nyquist pulse and message
        PSDNyquist(i) = SyNyquist(freq(i)); % Calculate PSD at selected frequency for Nyquist Pulse
        
        if j == 1     % Square pulse only needs to be calculated once  
            SySquare = @(f) Pm * (PpSquare(f))^2/(Ts); % The formula for power spectral density of the Square pulse and message
            PSDSquare(i) = SySquare(freq(i)); % Calculate PSD at selected frequency for Square Pulse
        end
    end
    PSDNyquistResults{j} = PSDNyquist; % Store the PSD associated with the current Bt
end


%% Plot PSD 
figure(1) % Plot the chosen Nyquist and Square pulse compared
plot(freq, PSDSquare)
hold on 
plot(freq,PSDNyquistResults{4})
xline(-channelBandlimit, '--r', 'LineWidth', 1) % Plot bandwidth limits
xline(channelBandlimit, '--r',  'LineWidth', 1) % Plot bandwidth limits
xlabel('Frequency (Hz)');
ylabel('Power Density (W/Hz)');
title('Power Spectral Densities of 4-PAM Signal with Different Pulse Shapes');
legend('Square Pulse', sprintf('Nyquist pulse with α = %.1f', RolloffF(4)), 'Channel bandwidth limit');
ylim([0, (1.2*R0)/(2*W)])
xlim([-XrangeSquare + 1, XrangeSquare])
hold off

figure(2) % Plot the PSD of the square pulse
plot(freq, PSDSquare)
hold on
xline(-channelBandlimit, '--r', 'LineWidth', 1) % Plot bandwidth limits
xline(channelBandlimit, '--r',  'LineWidth', 1) % Plot bandwidth limits
xlabel('Frequency (Hz)');
ylabel('Power Density (W/Hz)');
title('Power Spectral Densities of 4-PAM Signal with a Square Pulse');
legend('Square Pulse', 'Channel bandwidth limit');
ylim([0, (1.2*R0)/(2*W)])
xlim([-XrangeSquare + 1, XrangeSquare])
hold off

figure(3) % Plot the PSD of the Nyquist pulses
plot(freq,PSDNyquistResults{1}) 
hold on
plot(freq,PSDNyquistResults{2}) 
plot(freq,PSDNyquistResults{3})   
plot(freq,PSDNyquistResults{4})
xline(-channelBandlimit, '--r', 'LineWidth', 1) % Plot bandwidth limits
xline(channelBandlimit, '--r',  'LineWidth', 1) % Plot bandwidth limits
xlabel('Frequency (Hz)');
ylabel('Power Density (W/Hz)');
title('Power Spectral Densities of 4-PAM Signal with Different Pulse Shapes');
legend(sprintf('Nyquist pulse with α = %.1f', RolloffF(1)), ...
    sprintf('Nyquist pulse with α = %.1f',RolloffF(2)), sprintf('Nyquist pulse with α = %.1f', RolloffF(3)), ...
    sprintf('Nyquist pulse with α = %.1f', RolloffF(4)), 'Channel bandwidth limit');
ylim([0, (1.2*R0)/(2*W)])
xlim([-XrangeNyquist + 1, XrangeNyquist])
hold off
