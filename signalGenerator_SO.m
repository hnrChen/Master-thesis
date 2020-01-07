function signal = signalGenerator_SO(radarParameter, objectParameter) % input 
    % from which Tx
    tpn = (0 : radarParameter.N_Tx - 1) * radarParameter.T_pn;
    % in which chirp
    t_slow = (0 : radarParameter.N_chirp - 1) * radarParameter.T_chirp; 
     % in which sample
    t_fast = (0 : radarParameter.N_sample - 1) * radarParameter.T_sample;  
    
    % phaseshift because of vr
    fD = -2 * radarParameter.f0 * objectParameter.vr / radarParameter.c0;     % 1 x N_pn
    % phaseshift because of r0
    fR = -2 * radarParameter.ramp * objectParameter.r0 / radarParameter.c0;   %scalar
    
    % build radar signal
    % radarParameter.N_pn    antenna position number
    for i = 1 : radarParameter.N_pn
        X(:, :, i) = objectParameter.A ...
          * exp(1j * 2 * pi * (-2 * radarParameter.f0(ceil(i/radarParameter.N_Rx)) * objectParameter.r0 / radarParameter.c0))...
          * exp(1j * 2 * pi * (fD(ceil(i/radarParameter.N_Rx)) * tpn(ceil(i/radarParameter.N_Rx))))... % scalar
          * exp(1j * 2 * pi * fR * t_fast')... % N_sample x 1
          * exp(1j * 2 * pi * fD(ceil(i/radarParameter.N_Rx)) * t_slow)... % 1 x N_T_chirp
          * exp(-1j * 2 * pi * radarParameter.f0(ceil(i/radarParameter.N_Rx)) / radarParameter.c0... 
                           * radarParameter.P(i, :) * objectParameter.u');
    end   
    %n = normrnd(0, objectParameter.sigma, radarParameter.N_sample, radarParameter.N_chirp, radarParameter.N_pn);
    % add complex noise
    signal = awgn(X, objectParameter.SNR, 'measured');
end