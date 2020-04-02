function [reconstructedSignal, interferedIndex] = energyDetector(radarParameter,interferedSignal,channel)
signal  = interferedSignal(:, :, channel);
[m, n] = size(signal);
signal = reshape(signal,[1,m * n]);
squareSignal = abs(signal) .^ 2;
% maximal bandwidth for AAF
B_AAF = radarParameter.ramp * 200 / radarParameter.c0;   % maximal detection distance is 200m
% M is the expected length of the interfered signal
% M = floor(2 * B_AAF * radarParameter.N_sample / radarParameter.B);
M = floor(B_AAF * radarParameter.N_sample / radarParameter.B);
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
%         signal(i : i + M - 1 ) = 0;
        interferedIndex(i : i + M - 1) = 1;
        % reconstruct the echo signal of the interfered parts
%         for j = i : i + M - 1
%             uninterferedSignal = signal(1:j-1);
%             weights = lmsfilter(uninterferedSignal);
%             inverted_weights = fliplr(weights);
%             signal(j) = sum(inverted_weights .* uninterferedSignal);
%         end
    end
    reconstructedSignal = reshape(signal,[m,n]);
    interferedIndex = reshape(interferedIndex,[m,n]);
end


    
    

