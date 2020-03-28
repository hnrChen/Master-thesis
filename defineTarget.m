function targetParameter = defineTarget(range, speed, DOA, Amplitude, SNR)
%define the scenatio modeule parameters for one target
    targetParameter.r0 = range;
    targetParameter.vr = speed;
    targetParameter.SNR = SNR;
    targetParameter.u = DOA;
    targetParameter.A = Amplitude; 
end