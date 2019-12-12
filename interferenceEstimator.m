function estimatedInterference = interferenceEstimator(radarParameter,interferedSignal,interferedIndex)
% interferenceEstimator is going to estimate the phase and amplitude of the
% interference from the interferedSignal
% interferedSignal contains interference and the echo signal

% total number of interfered samples
num = sum(interferedIndex);
% sampling period
T_sample = radarParameter.T_sample;

%estimate the phase of the interference
differentiatedSignal = diff(interferedSignal);
differentiatedSignal = [interferedSignal(1) differentiatedSignal];
% real and imaginary part of the differentiated signal
real_signal = real(differentiatedSignal);
imag_signal = imag(differentiatedSignal);
estimatedPhase = atan(-1 * real_signal ./ imag_signal);

% estimate the amplitude of the interference
realPart = real_signal .* cos(estimatedPhase);
interferedPart = realPart .* interferedIndex;
estimatedAmplitude = sum(interferedPart)...
                     / sum((cos(estimatedPhase) .* interferedIndex) ^2 );

% estimated interference
estimatedInterference = estimatedAmplitude * exp(1j * 2 * pi * estimatedPhase);

end


