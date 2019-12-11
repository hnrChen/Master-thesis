function interferenceParameter = defineInterference(radarParameter,amplitude,SIR,type)
interferenceParameter.amplitude = amplitude * sqrt(SIR);
A = interferenceParameter.amplitude;
interferenceParameter.type = type;
%transmitted signal

% in which chirp
t_slow = (0 : radarParameter.N_chirp - 1) * radarParameter.T_chirp; 
% in which sample
t_fast = (0 : radarParameter.N_sample - 1) * radarParameter.T_sample;
% phase of the first chirp of CS radar
f_cs = radarParameter.f0 + radarParameter.ramp * t_fast;
f_cs = repmat(f_cs,1,radarParameter.N_chirp);
% phaseshift because of vr
fD = -2 * radarParameter.f0 * objectParameter.vr / radarParameter.c0;     % 1 x N_pn
% phaseshift because of r0
fR = -2 * radarParameter.ramp * objectParameter.r0 / radarParameter.c0;   %scalar
% maximal bandwidth for AAF
B_AAF = radarParameter.ramp * 200 / radarParameter.c0;   % maximal detection distance is 200m


%CW radar as the interference
if type == 1
    f_cw = 100 * 1e9;   %set the constant frequency for CW radar signal
    freq_diff = f_cw - f_cs + random();  %set an initial phase for this phase shift
    % SF = 1;
    % signal to interference mitgation gain
    % interferenceParameter.G_sir = radarParameter.B * radarParameter.T_chirp * SF;
    for i = 1:length(freq_diff)
        if freq_diff(i) > B_AAF || freq_diff(i) < -1 * B_AAF
            freq_diff(i) = 0;
        end
    end
    freq_diff = freq_diff + random();  %set an initial phase for this phase shift
    phase = cumtrapz(freq_diff);  % set a random initial phase
    reshaped_phase = reshape(phase,[radarParameter.N_sample,radarParameter.N_chirp]);
    for i = 1 : radarParameter.N_pn
        interferenceParameter.signal(:,:,i)= A ...
                           * exp(1j * 2 * pi * reshaped_phase)...
                           * exp(1j * 2 * pi * fD(ceil(i/radarParameter.N_Rx)) * t_slow)...
                           * exp(-1j * 2 * pi * radarParameter.f0(ceil(i/radarParameter.N_Rx)) / radarParameter.c0...
                                                    * radarParameter.P(i, :) * objectParameter.u');
    end

%FMCW radar as the interference
%set random chirp rates for different chirps !!!!!!!!!!!
elseif type == 2
    % T_fmcw / T_cs = m/n
    m = 20;
    n = 3;
    chirp_ramp_fmcw = 10 * radarParameter.ramp;
    f0_fmcw = 94 * 1e9;
    N_sample_fmcw = floor(m * radarParameter.N_sample / n);
    t = (0:N_sample_fmcw - 1) * radarParameter.T_sample;
    f_fmcw_first = f0_fmcw + chirp_ramp_fmcw * t;  %frequency of first chirp for FMCW
    number_chirp_fmcw = floor(radarParameter.N_sample * radarParameter.N_chirp / N_sample_fmcw);
    f_fmcw = repmat(f_fmcw_first,1,number_chirp_fmcw);
    len = radarParameter.N_sample * radarParameter.N_chirp - number_chirp_fmcw * N_sample_fmcw;
    f_fmcw_rest = f_fmcw_first(1:len);
    f_fmcw = [f_fmcw f_fmcw_rest];

    freq_diff = f_fmcw - f_cs + random();   %set an initial phase for this phase shift
    for i = 1:length(freq_diff)
        if freq_diff(i) > B_AAF || freq_diff(i) < -1 * B_AAF   %f_ifmax needs to be define
            freq_diff(i) = 0;
        end
    end
    phase = cumtrapz(freq_diff_new);   
    reshaped_phase = reshape(phase,[radarParameter.N_sample,radarParameter.N_chirp]);
    for i = 1 : radarParameter.N_pn
       interferenceParameter.signal(:,:,i) = A ...
                           * exp(1j * 2 * pi * reshaped_phase)...
                           * exp(-1j * 2 * pi * radarParameter.f0(ceil(i/radarParameter.N_Rx)) / radarParameter.c0...
                                                    * radarParameter.P(i, :) * objectParameter.u');
    end
    
    
%CS radar as the interference
else
    %CS interference with same chirp rate and duration
    if type == 3
        freq_diff = ones(1,radarParameter.N_sample * radarParameter.N_chirp) * random(); % just a different initial phase different:
        for i = 1:length(freq_diff)
            if freq_diff(i) > B_AAF || freq_diff(i) < -1 * B_AAF   %f_ifmax needs to be define
                freq_diff(i) = 0;
            end
        end
        phase = cumtrapz(freq_diff);
        reshaped_phase = reshape(phase,[radarParameter.N_sample,radarParameter.N_chirp]);
        for i = 1 : radarParameter.N_pn
            interferenceParameter.signal(:,:,i)= A ...
                           * exp(1j * 2 * pi * reshaped_phase)...
                           * exp(1j * 2 * pi * fD(ceil(i/radarParameter.N_Rx)) * t_slow)...
                           * exp(-1j * 2 * pi * radarParameter.f0(ceil(i/radarParameter.N_Rx)) / radarParameter.c0...
                                                    * radarParameter.P(i, :) * objectParameter.u');
        end
        
        
    %CS interference with same chirp duration but different rate
    elseif type == 4
        f0_inter = radarParameter.f0;  % set a different carrier frequency or not?
        ramp_inter = radarParameter.ramp + random();
        f_cs_inter = f0_inter + ramp_inter * t_fast;  % frequency of the first chirp of the CS interference
        f_cs_inter = repmat(f_cs_inter,1,radarParameter.N_chirp);

        freq_diff = f_cs_inter - f_cs + random();  % set a random initial phase for this phase difference
        for i = 1:length(freq_diff)
            if freq_diff(i) > B_AAF || freq_diff(i) < -1 * B_AAF   
                freq_diff(i) = 0;
            end
        end
        phase = cumtrapz(freq_diff);
        reshaped_phase = reshape(phase,[radarParameter.N_sample,radarParameter.N_chirp]);
        for i = 1 : radarParameter.N_pn
            interferenceParameter.signal(:,:,i)= A ...
                           * exp(1j * 2 * pi * reshaped_phase)...
                           * exp(1j * 2 * pi * fD(ceil(i/radarParameter.N_Rx)) * t_slow)...
                           * exp(-1j * 2 * pi * radarParameter.f0(ceil(i/radarParameter.N_Rx)) / radarParameter.c0...
                                                    * radarParameter.P(i, :) * objectParameter.u');
        end
        
    %CS interference with same chirp rate but different duration
    elseif type == 5
        ramp_inter = radarParameter.ramp;
        
        
        
    %CS interference with different chirp duration and rate   
    else
        
        
        
    end
end
    
    
    
