function normalizedSignal = normalization(interferedSignal)
% normalize the data to 0-255
realpart = real(interferedSignal);
imagpart = imag(interferedSignal);
abssignal = abs(interferedSignal);

realmax = max(max(realpart));
realmin = min(min(realpart));
realpart_norm = round(255 * (realpart - realmin) / (realmax - realmin));

imagmax = max(max(imagpart));
imagmin = min(min(imagpart));
imagpart_norm = round(255 * (imagpart - imagmin) / (imagmax - imagmin));

absmax = max(max(abssignal));
absmin = min(min(abssignal));
abspart_norm = round(255 * (abssignal - absmin) / (absmax - absmin));

normalizedSignal(:,:,1) = realpart_norm;
normalizedSignal(:,:,2) = imagpart_norm;
% normalizedSignal(:,:,3) = abspart_norm;
end

