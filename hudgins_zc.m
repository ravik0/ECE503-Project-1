function[emg_zc] = hudgins_zc(emg, thresh)
    nextsample = [emg(1) emg(1:end-1)]; % Shift left.
    emg_zc = ( (emg>0 & nextsample<0)|(emg<0 & nextsample>0) ) ...
     & ( abs(emg-nextsample)>=thresh );
end