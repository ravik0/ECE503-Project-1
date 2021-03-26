%This functions uses the Hysteresis Zero Crossing algorithm to determine
%the amount of zero-crossings in a signal. This uses time-based hysteresis.
%The first input is an EMG signal, and the second is the number of samples
%before the sample is considered a zero-crossing sample.
%The output is a logical array where a 0 represents no crossing at that
%sample, and a 1 represents a zero crossing at that sample.
function[emg_zc] = hyst_zc(emg, samples)
    currentState = 0; %Current state of the state machine
    %There are three states: 0, 1, 2, 3.
    count = 1; %Counter to check whether we hit the sample threshold.
    foundSample = 1; %Index of sample suspected to be a crossing
    
    emg_zc = false(1,length(emg)); %Preallocated array
    
    if (emg(1) > 0) 
        currentState = 0; 
        %If the first value is positive, we start in state 0.
    elseif (emg(1) < 0) 
        currentState = 2;
        %If the first value is negative, we start in state 2.
    end
    
    for i = 1:length(emg)
        switch (currentState)
            case 0
                %State 0 is the positive state - if we have a positive
                %number and we aren't checking for a zero crossing, we're
                %in state 0.
                if (emg(i) < 0)
                    currentState = 1;
                    count = 1;
                    foundSample = i;
                    %If we go from a positive to negative sample, we enter
                    %state 1.
                end
            case 1
                %State 1 is the possible positive-negative zero-crossing
                %state. If we go from a positive number to a negative
                %number, we need to make sure we're negative for a certain
                %number of samples (denoted by 2nd input) before we truly
                %say we've crossed over.
                count = count + 1;
                %We count first because the first ZC already counted as 1.
                if (emg(i) >= 0)
                    currentState = 0;
                    %If we go back above zero, it's not a sample.
                elseif(emg(i) < 0 && count >= samples)
                    currentState = 2;
                    emg_zc(foundSample) = 1;
                    %If we are negative long enough, we go into state 2 and
                    %mark the crossed sample as a zero crossing.
                end
            case 2
                %State 2 is the negative state - if we have a negative
                %number and we aren't checking for a zero crossing, we're
                %in state 2.
                if (emg(i) >= 0)
                    currentState = 3;
                    count = 1;
                    foundSample = i;
                    %If we go from a negative to positive sample, we enter
                    %state 3.
                end
            case 3
                %State 3 is the possible negative-positive zero-crossing
                %state. If we go from a negative number to a positive
                %number, we need to make sure we're positive for a certain
                %number of samples (denoted by 2nd input) before we truly
                %say we've crossed over.
                count = count + 1;
                %We count first because the first ZC already counted as 1.
                if (emg(i) < 0)
                    currentState = 2;
                    %If we go back below zero, it's not a sample.
                elseif(emg(i) >= 0 && count >= samples)
                    currentState = 0;
                    emg_zc(foundSample) = 1;
                    %If we are positive long enough, we go into state 0
                    %and mark the crossed sample as a zero crossing.
                end
        end 
    end
end