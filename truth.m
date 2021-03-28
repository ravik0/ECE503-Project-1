%This function creates the truths for use in the test functions.
%It has no inputs and no outputs, but it saves truths to the folder.
function truth()
    %This function creates the truths for use in the test functions.
    Truth = struct('time', [], 'unit', []); %Create the struct

    [emg] = emg_sim(0, 40);
    %Simulate the emg operation with no noise and for 40 seconds.
    zc = hudgins_zc(emg, 0);
    %Get the zero crossing using the hudgin's method, 0 threshold.
    ff = find(zc==1); 
    %Find all samples where there is a zero crossing and make an array of them
    ff = ff./4096;
    %Convert the samples into timestamps.

    Truth.time = ff; %Set the time portion with the timestamps.
    Truth.unit = ones(1, length(ff)); %Unit is all 1

    save 'zctruth.mat' Truth %Save Truth as zctruth

    %Repeat the same as above, but with hudgin's slope sign changes.
    ssc = hudgins_ssc(emg, 0);
    ff = find(ssc==1);
    ff = ff./4096;

    Truth.time = ff;
    Truth.unit = ones(1, length(ff));

    save 'ssctruth.mat' Truth
    
    %Below is a repeat of above, but for hysteresis
    zc = hyst_zc(emg, 0);
    ff = find(zc==1); 
    ff = ff./4096;

    Truth.time = ff; 
    Truth.unit = ones(1, length(ff)); 

    save 'hystzctruth.mat' Truth 

    ssc = hyst_ssc(emg, 0);
    ff = find(ssc==1);
    ff = ff./4096;

    Truth.time = ff;
    Truth.unit = ones(1, length(ff));

    save 'hystssctruth.mat' Truth
end