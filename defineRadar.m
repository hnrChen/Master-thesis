function radarParameter = defineRadar(carrier_frequence , bandwidth, sample_frequence,...
                                        N_chirps, N_samples, Tx_positions, Rx_positions)
%define the configration module parameters

% Tx numbers
radarParameter.N_Tx = size(Tx_positions, 1);
% Rx numbers
radarParameter.N_Rx = size(Rx_positions, 1);
% for i = 1: radarParameter.N_Tx
%     radarParameter.P = [radarParameter.P;... 
%                     repmat(Tx_positions(i, :), radarParameter.N_Rx, 1) + Rx_positions];   % Ante Positions
% end  

% antenna position number
radarParameter.N_pn = radarParameter.N_Tx * radarParameter.N_Rx;   
% chirp number per pulse
radarParameter.N_chirp = N_chirps;  
% sample number per chirp
radarParameter.N_sample = N_samples;
% sample duration
radarParameter.T_sample = 1 / sample_frequence;
% chirp duration
radarParameter.T_chirp = radarParameter.T_sample * radarParameter.N_sample;
% duration per antenna
radarParameter.T_pn = radarParameter.T_chirp * radarParameter.N_chirp;  
% full time
radarParameter.T_full = radarParameter.T_pn * radarParameter.N_Tx;    
%bandwidth
radarParameter.B = bandwidth;
% chirp rate
radarParameter.ramp = radarParameter.B / radarParameter.T_chirp; 

% carrier frequence, only N_Tx
if length(carrier_frequence) == 1
    radarParameter.f0(1: radarParameter.N_Tx) = carrier_frequence;% carrier frequency
else
    radarParameter.f0 = carrier_frequence;
end

% antenna_configuration
radarParameter.c0 = 299792458;

% build antenna positions
radarParameter.P = radarParameter.c0 ./ kron(radarParameter.f0', ...
                                    ones([radarParameter.N_Rx, 1]))...
                    .* (kron(Tx_positions, ones([radarParameter.N_Rx, 1])) + ...
                    kron(ones([radarParameter.N_Tx, 1]), Rx_positions));
end