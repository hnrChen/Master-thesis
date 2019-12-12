function weights = rlsfilter(uninterferedSignal,filter_order)

originalSignal = uninterferedSignal;
len = length(originalSignal);
noisySignal = originalSignal + randn(1,len);
order = filter_order;

weights = zeros(order,len); % weights vector
err=zeros(1,num ); % error vector
kn=zeros(2,num );
 
lamda = 0.99; % forget factor
diag_I=[1,0;0,1];

for i=1 : len   
    if i == 1
        hn = [originalSignal(1,i);0];
        corr=10^5 * diag_I;
        kn(:,1) = (corr * hn)./(lamda^i+(hn') * corr * hn);% column vector
        err(1,i) = noisySignal(1,i) - weights(1,1) * originalSignal(1,i);
        weights(:,i) = err(1,i) .* kn(:,i);   
    else
        hn = [originalSignal(1,i); originalSignal(1,i-1)];
        kn(:,i) = (corr*hn)./(lamda^i+(hn')*corr*hn);% column vector
        err(1,i) = noisySignal(1,i) - weights(:,i-1)' * hn;
        weights(:,i) = weights(:,i-1) + err(1,i) .* kn(:,i);
    end
end

