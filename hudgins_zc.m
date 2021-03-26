%This functions uses the Hudgin's Zero Crossing algorithm to determine the
%amount of zero-crossings in a signal.
%The first input is an EMG signal, and the second is a threshold between 0
%and 1. 
%The output is a logical array where a 0 represents no crossing at that
%sample, and a 1 represents a zero crossing at that sample.
function[emg_zc] = hudgins_zc(emg, thresh)
    nextsample = [emg(1) emg(1:end-1)]; %Shift left.
    emg_zc = ((emg>0 & nextsample<0)|(emg<0 & nextsample>0))...
     &(abs(emg-nextsample)>=thresh); %Implement Hudgin's ZC algorithm.
end