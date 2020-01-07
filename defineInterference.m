function interferenceParameter = defineInterference(radarParameter,targetParameter,SIR,type)
interferenceParameter.amplitude = targetParameter.A * sqrt(SIR);
A = interferenceParameter.amplitude;
interferenceParameter.type = type;
%transmitted signal

% in which chirp
t_slow = (0 : radarParameter.N_chirp - 1) * radarParameter.T_chirp; 
% in which sample
t_fast = (0 : radarParameter.N_sample - 1) * radarParameter.T_sample;
f_cs = radarParameter.f0 + radarParameter.ramp * t_fast;
f_cs = repmat(f_cs,1,radarParameter.N_chirp);
% phaseshift because of vr
fD = -2 * radarParameter.f0 * targetParameter.vr / radarParameter.c0;     % 1 x N_pn
% phaseshift because of r0
fR = -2 * radarParameter.ramp * targetParameter.r0 / radarParameter.c0;   %scalar
% maximal bandwidth for AAF
B_AAF = radarParameter.ramp * 200 / radarParameter.c0;   % maximal detection distance is 200m


%CW radar as the interference
if type == 1
    f_cw = 95 * 1e9;   %set the constant frequency for CW radar signal
    freq_diff = f_cw - f_cs;  %set an initial phase for this phase shift
    phase = cumtrapz(2 * pi * freq_diff) + 2 * pi * rand();  % set a random initial phase
%     reshaped_phase = reshape(phase,[radarParameter.N_sample,radarParameter.N_chirp]);
    for i = 1 : radarParameter.N_pn
        interference = A * exp(1j * 2 * pi * phase)...
                         * exp(-1j * 2 * pi * radarParameter.f0(ceil(i/radarParameter.N_Rx)) / radarParameter.c0...
                                                    * radarParameter.P(i, :) * targetParameter.u');
        for j = 1:length(freq_diff)
             if freq_diff(j) > B_AAF || freq_diff(j) < -1 * B_AAF
                 interference(j) = 0;
             end
        end
        interferenceParameter.signal(:,:,i) = reshape(interference,[radarParameter.N_sample,radarParameter.N_chirp]);
    end

%FMCW radar as the interference
elseif type == 2
    t_fmcw = (0 : radarParameter.N_sample * radarParameter.N_chirp - 1) * radarParameter.T_sample;
    ramp_fmcw = radarParameter.ramp / 100;
    f_fmcw = radarParameter.f0 + ramp_fmcw * t_fmcw;
    freq_diff = f_fmcw - f_cs;   %set an initial phase for this phase shift
    
    phase = cumtrapz(2 * pi * freq_diff) + 2 * pi * rand();    %set an initial phase for this phase shift
%     reshaped_phase = reshape(phase,[radarParameter.N_sample,radarParameter.N_chirp]);
    for i = 1 : radarParameter.N_pn
        interference = A * exp(1j * 2 * pi * phase)...
                         * exp(-1j * 2 * pi * radarParameter.f0(ceil(i/radarParameter.N_Rx)) / radarParameter.c0...
                                                    * radarParameter.P(i, :) * targetParameter.u');
        for j = 1:length(freq_diff)
             if freq_diff(j) > B_AAF || freq_diff(j) < -1 * B_AAF
                 interference(j) = 0;
             end
        end
        interferenceParameter.signal(:,:,i) = reshape(interference,[radarParameter.N_sample,radarParameter.N_chirp]);
    end
    
    
%CS radar as the interference
else
    %CS interference with same chirp rate and duration
    if type == 3
        freq_diff = ones(1,radarParameter.N_sample * radarParameter.N_chirp) * 2 * B_AAF; % just a different initial phase different:
        phase = cumtrapz(2 * pi * freq_diff) + 2 * pi * rand();
        for i = 1 : radarParameter.N_pn
            interference = A * exp(1j * 2 * pi * phase)...
                            * exp(-1j * 2 * pi * radarParameter.f0(ceil(i/radarParameter.N_Rx)) / radarParameter.c0...
                                                    * radarParameter.P(i, :) * targetParameter.u');
            interferenceParameter.signal(:,:,i) = reshape(interference,[radarParameter.N_sample,radarParameter.N_chirp]);
        end     
    %CS interference with same chirp duration but different rate
    elseif type == 4
        f0_inter = radarParameter.f0;  % set a different carrier frequency or not?
        ramp_inter = radarParameter.ramp * (rand() + 1);
        f_cs_inter = f0_inter + ramp_inter * t_fast;  % frequency of the first chirp of the CS interference
        f_cs_inter = repmat(f_cs_inter,1,radarParameter.N_chirp);
        freq_diff = f_cs_inter - f_cs;  % set a random initial phase for this phase difference
        phase = cumtrapz(2 * pi * freq_diff) + 2 * pi * rand();
        for i = 1 : radarParameter.N_pn
            interference = A * exp(1j * 2 * pi * phase)...
                         * exp(-1j * 2 * pi * radarParameter.f0(ceil(i/radarParameter.N_Rx)) / radarParameter.c0...
                                                    * radarParameter.P(i, :) * targetParameter.u');
            for j = 1:length(freq_diff)
                if freq_diff(j) > B_AAF || freq_diff(j) < -1 * B_AAF
                    interference(j) = 0;
                end
            end
            interferenceParameter.signal(:,:,i) = reshape(interference,[radarParameter.N_sample,radarParameter.N_chirp]);
        end
        
    %CS interference with same chirp rate but different duration
    elseif type == 5
        ramp_inter = radarParameter.ramp;
        % case 1: N_chirp > m %case 2: N_chirp < m      N_chirp = 160
        m = 171; n = 200;  % T_chirp_interference / T_chirp = m / n
        N_chirp_inter = floor(n * radarParameter.N_chirp / m) + 1;
        t_cs = (0 : floor(radarParameter.N_sample * m / n) - 1) * radarParameter.T_sample;
        f_cs_inter = radarParameter.f0 + ramp_inter * t_cs;
        f_cs_inter = repmat(f_cs_inter,1,N_chirp_inter);
        f_cs_inter = f_cs_inter(1:length(f_cs));
        
        freq_diff = f_cs_inter - f_cs;  
        phase = cumtrapz(2 * pi * freq_diff) + 2 * pi * rand();
        for i = 1 : radarParameter.N_pn
            interference = A * exp(1j * 2 * pi * phase)...
                         * exp(-1j * 2 * pi * radarParameter.f0(ceil(i/radarParameter.N_Rx)) / radarParameter.c0...
                                                    * radarParameter.P(i, :) * targetParameter.u');
            for j = 1:length(freq_diff)
                if freq_diff(j) > B_AAF || freq_diff(j) < -1 * B_AAF
                    interference(j) = 0;
                end
            end
            interferenceParameter.signal(:,:,i) = reshape(interference,[radarParameter.N_sample,radarParameter.N_chirp]);
        end
        

        
        
    %CS interference with different chirp duration and rate   
    else
        
        
        
    end
end
    
    
    

    
    
