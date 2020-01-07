function rangeFFTSignal = anc(L_filter,gamma,interferedSignal,channel)
% L_filter: filter length
L = L_filter;
signal = interferedSignal(:,:,channel)';
[M,N] = size(signal);
% get the interference power threshold
thr = sum(sum(abs(signal) .^ 2)) / (M * N);
out = zeros(M,N/2);
for i = 1:M
    y = fft(signal(i,:),N);  % range FFT
    pri = y(1:N / 2); % positive FFT
    ref = conj(flip(y(N / 2 + 1:N)));
    % interference power
    energy = abs(ref) .^ 2;
     power = mean(energy);
    if power > thr
        w0 = zeros(L,1);  % filter taps
        w0(1,1) = 1;
        fi = zeros(N / 2,1);  % filter input
        error = zeros(N / 2,1); % estimation error
        delta_w = 2 / (sum(energy) * gamma);  % step size
        for j = 1:N / 2
            fi = [ref(j);fi(1:L-1)];  % filter input
            fo = sum(w0 .* fi);       % filter output
            error(j) = pri(j) - fo;   % estimation error
            w0 = w0 + delta_w * fi * conj(error(j));   % tap update
        end
        out(i,:) = error;
    else    % bypass ANC
        out(i,:) = pri;
    end
end
rangeFFTSignal = out';
end
        
