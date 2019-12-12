function [reconstructedSignal, interferedIndex] = energyDetector(interferedSignal,channel)
signal  = interferedSignal(:, :, channel);
[m, n] = size(signal);
signal = reshape(signal,[1,m * n]);
squareSignal = abs(signal) .^ 2;
% M is the expected length of the interfered signal
M = L_chirp;
% calculate the average enengy of the interfered signal
average_energy = mean(squareSignal);
% set a certain threshold for energy detector
threshold =  average_energy;
% get the interfered part
interferedIndex = zeros(1,length(signal));

for i = 2 : length(signal) - M
    energy  = mean(squareSignal(i : i + M - 1));
    if energy >= threshold
        % remove the interfered samples
        signal(i : i + M - 1 ) = 0;
        interferedIndex(i : i + M - 1) = 1;
        % reconstruct the echo signal of the interfered parts
        for j = i : i + M - 1
            uninterferedSignal = signal(1:j-1);
            weights = rlsfilter(uninterferedSignal,2);
            inverted_weights = fliplr(weights(2,:));
            signal(j) = sum(inverted_weights .* uninterferedSignal);
        end
    end
    reconstructedSignal = signal;
end


    
    

