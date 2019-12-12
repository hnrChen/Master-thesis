% set the parameters of the CS radar
f0 = 94 * 1e9;    %carrier frequency
Bc = 3 * 1e9;     %bandwidth of chirps
fs = 10 * 1e6;    %sampling frequency
N_chirps = 160;   %number of chirps per pulse
N_samples = 1000; %sampling number per chirp
Tx_position = [0 0 0];
Rx_position = [0 0 0;1/2 0 0;0 1/2 0;1/2 1/2 0];
%define a CS radar
radarParameter = defineRadar(f0, Bc, fs, N_chirps, N_samples, Tx_position, Rx_position);


%set the parameters of the targets
ranges = [5 10 15 20];
speeds = [1 1.5 2 2.5];
DOA = [0.224143868, 0.5, 0.8365163037; 0.433, 0.5, 0.75; 0.433, 0.5, 0.75; 0.433, 0.5, 0.75];
amplitudes = [1 1 1 1];
SNR = 8;
num_target = length(ranges);

%generate the baseband signal
generated_signal = 0;
for i = 1:num_target
    targetParameter = defineTarget(ranges(i), speeds(i), DOA(i,:), amplitudes(i), SNR);
    generated_signal = generated_signal + signalGenerator_SO(radarParameter, targetParameter);
end
% plot the spectrum after FFT
% processed_signal = signalFFT(generated_signal);
% surf(processed_signal(:, :, 1));
detectedValue = signalProcessing(generated_signal, radarParameter);
cellArrayText = {};
for i = 1 : size(detectedValue, 1)
	cellArrayText{i} = sprintf('%0.6f, %0.6f, %0.3e\n',detectedValue(i, :));
end
TagetsList = cellArrayText;
