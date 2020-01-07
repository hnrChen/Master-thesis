function estimatedInterference = interferenceEstimator(interferedSignal,interferedIndex,p)
% interferenceEstimator is going to estimate the phase and amplitude of the
% interference from the interferedSignal
% interferedSignal contains interference and the echo signal
signal = interferedSignal(:,:,p);
[m,n] = size(signal);
Index = interferedIndex(:,:,p);
Index = reshape(Index,[1, m * n]);
signal = reshape(signal,[1, m * n]);
%estimate the phase of the interference
differentiatedSignal = diff(signal);
differentiatedSignal = [signal(1) differentiatedSignal];
% real and imaginary part of the differentiated signal
real_signal = real(differentiatedSignal);
imag_signal = imag(differentiatedSignal);
estimatedPhase = atan(-1 * real_signal ./ imag_signal);

% estimate the amplitude of the interference
realPart = real_signal .* cos(estimatedPhase);
interferedPart = realPart .* Index;
estimatedAmplitude = sum(interferedPart)...
                     / sum((cos(estimatedPhase) .* Index) .^ 2 );

% estimated interference
Interference = estimatedAmplitude * exp(1j * 2 * pi * estimatedPhase);
estimatedInterference = reshape(Interference,[m,n]);

end


