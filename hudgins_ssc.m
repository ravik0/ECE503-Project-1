%This functions uses the Hudgin's Slope Sign Changes algorithm to determine
%the amount of slope changes in a signal.
%The first input is an EMG signal, and the second is a threshold value
%between 0 and 1. 
%The output is a logical array where a 0 represents no sign change at that
%sample, and a 1 represents a sign change at that sample.
function[emg_ssc] = hudgins_ssc(emg, thresh)
    sampleL = [emg(1) emg(1:end-1)]; % Shift left.
    sampleR = [emg(2:end) emg(end)]; % Shift right.
    emg_ssc = ((emg>sampleL & emg>sampleR)| ...
     (emg<sampleL & emg<sampleR)) ...
     & (abs(emg-sampleL)>=thresh | ...
     abs(emg-sampleR)>=thresh); %Implement Hudgin's SSC algorithm.
end