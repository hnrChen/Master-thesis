function weights = lmsfilter(uninterferedSignal)

% len = length(uninterferedSignal);
% uninterferedSignal = uninterferedSignal';
% mu = 0.05;  % algorithm adjustment step size control factor
% % M = filter_order;
% weights = zeros(1,len); % weights
% error = zeros(len,1); % error
% out = zeros(len,1); % output
% 
% for i = 1 :len - 1
%     weights(:,i+1) = weights(:,i) + mu * uninterferedSignal(i-1:-1:i-2,:) * conj(error(i));
%     out(i+1) = weights(:,i+1)' * uninterferedSignal(i:-1:i-1,:);
%     error(i+1) = uninterferedSignal(i+1,:) - out(i+1);
% end

signal = uninterferedSignal';
signal_expand = [signal;0];
signal_delay = [0;signal];
M = 20;  % filter order
mu = 0.0005;
itr = length(signal_expand);   % iteration number
[w,error,output] = LMS(signal_delay,signal_expand,M,mu,itr);
W = w(M,:);
weights = W(2:length(W));


end


