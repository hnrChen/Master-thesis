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

%generate the baseband signal and the interfered signal
generated_signal = 0;
for i = 1:num_target
    targetParameter = defineTarget(ranges(i), speeds(i), DOA(i,:), amplitudes(i), SNR);
    generated_signal = generated_signal + signalGenerator_SO(radarParameter, targetParameter);
end
SIR = 1e5;
interferenceParameter = defineInterference(radarParameter,targetParameter,SIR,1);
interferedSignal = generated_signal + interferenceParameter.signal;

%% generate the interfered signal
% SIR = 1e5;
% % get the training dataset
% for i = 1:200
%     % get the random interference type
%     type = [1 2 3 4 5];
%     index = randperm(numel(type));
%     interferenceType = type(index(1));
%     interferenceParameter = defineInterference(radarParameter,targetParameter,SIR,interferenceType);
%     % generate the interfered signal
%     interferedSignals = generated_signal(:,:,1) + interferenceParameter.signal(:,:,1);
%     interferedSignal = normalization(interferedSignals);
%     filename = ['interferedSignal_train' num2str(i)];
%     save(filename,'interferedSignal');
% end
% % get the test data
% for i = 1:100
%     % get the random interference type
%     type = [1 2 3 4 5];
%     index = randperm(numel(type));
%     interferenceType = type(index(1));
%     interferenceParameter = defineInterference(radarParameter,targetParameter,SIR,interferenceType);
%     % generate the interfered signal
%     interferedSignals = generated_signal(:,:,1) + interferenceParameter.signal(:,:,1);
%     interferedSignal = normalization(interferedSignals);
%     filename = ['interferedSignal_test' num2str(i)];
%     save(filename,'interferedSignal');
% end

%% Interference Mitigation

for i = 1 : radarParameter.N_pn
      [reconstructedSignal(:,:,i), interferedIndex(:,:,i)] = energyDetector(radarParameter,interferedSignal,i);
%     estimatedInterference(:,:,i) = interferenceEstimator(interferedSignal,interferedIndex,i);
%     L_filter = 200;
%     gamma = 100;
%     estimatedBasebandFFT(:,:,i) = anc(L_filter,gamma,interferedSignal,i);
%     estimatedBaseband(:,:,i) = ifft(estimatedBasebandFFT(:,:,i));
      uninterferedSignal(:,:,i) = mserdetection(interferedSignal,interferedIndex(:,:,i),i);
end
% estimatedBasebandsignal = interferedSignal - estimatedInterference;
subplot(211)
surf(abs(fft2(interferedSignal(:,:,1))))
subplot(212)
surf(abs(fft2(uninterferedSignal(:,:,1))))


%% signal processing

detectedValue = signalProcessing(uninterferedSignal, radarParameter);
% cellArrayText = {};
% for i = 1 : size(detectedValue, 1)
% 	cellArrayText{i} = sprintf('%0.6f, %0.6f, %0.3e\n',detectedValue(i, :));
% end
% TargetsList = cellArrayText;

%% save the data in different forms
% save the data as numpy matrices
% for i = 1:200
%     filename = ['interferedSignal_train' num2str(i)];
%     load(filename);
%     filename_new = [filename '.npy'];
%     writeNPY(interferedSignal,filename_new);
% end
% for i = 1:100
%     filename = ['interferedSignal_test' num2str(i)];
%     load(filename);
%     filename_new = [filename '.npy'];
%     writeNPY(interferedSignal,filename_new);
% end

% save the data as .png
% for i = 1:200
%     filename = ['interferedSignal_train' num2str(i)];
%     load(filename);
%     filename_new = [filename '.png'];
%     imwrite(interferedSignal,filename_new);
% end
% for i = 1:100
%     filename = ['interferedSignal_test' num2str(i)];
%     load(filename);
%     filename_new = [filename '.png'];
%     imwrite(interferedSignal,filename_new);
% end
