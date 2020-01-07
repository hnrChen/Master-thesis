function fftSignal = signalFFT(rawData)
% input radarSignal is a 3-D signal
% compute fft to graph it in the figure

% using chebishelv window function
windowData = repmat(chebwin(size(rawData, 1), 60) * chebwin(size(rawData, 2), 60)' , 1, 1, size(rawData, 3));
radarData = rawData .* windowData;
% fft for 3-D signal
fftSignal = abs(fftshift(fft2(radarData, size(radarData, 1), size(radarData, 2)), 2));
end