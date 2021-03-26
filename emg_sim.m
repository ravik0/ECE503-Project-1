%This function simulates an EMG signal. It samples at 4096Hz
%There are two inputs the first is a noise level between 0 and 1. 
%The second input is the amount of time we are capturing the EMG signal
%for.
%There are three outputs - the first is the complete EMG signal, the second
%is the EMG signal without noise, and the third is the noise alone.
function[emg, emgnonoise, noise] = emg_sim(noiselevel, time)
    fc = 150; %cutoff frequency
    fs = 4096; %sampling frequency
    samples = fs*time;
    RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', 54));
    x = randn(1,samples+100); % Pad by 100 for start-up transient.
    fc = 150;
    fs = 4096;
    [b, a] = butter(2,fc/(fs/2));
    EMGin = filter(b, a, x); % Shape spectrum similar to real EMG.
    EMGin = EMGin(101:end); % Trim filter start-up transient.
    
    emgnonoise = EMGin;
    
    noise = noiselevel*randn(1,samples); 
     
    emg = noise + EMGin;
end