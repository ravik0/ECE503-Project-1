%This functions uses the Hysteresis Slope Change algorithm to determine
%the amount of slope changes in a signal. This uses time-based hysteresis.
%The first input is an EMG signal, and the second is the number of samples
%before the sample is considered a slope change.
%The output is a logical array where a 0 represents no crossing at that
%sample, and a 1 represents a slope change at that sample.
function[emg_ssc] = hyst_ssc(emg, samples)
    currentState = 0; %Current state of the state machine
    %There are four states: 0, 1, 2, 3.
    count = 1; %Counter to check whether we hit the sample threshold.
    foundSample = 1; %Index of sample suspected to be a crossing
    
    emg_ssc = false(1,length(emg)); %Preallocated array
    
    slope = emg(2) - emg(1); %Get the slope of the first set of numbers
    if(slope >= 0)
        currentState = 0; %If positive, state 0
    else
        currentState = 2; %If negative, state 2
    end

    i = 1;
    while i <= length(emg)-1
        slope = emg(i+1) - emg(i); %Get slope
        switch (currentState)
            case 0
                %State 0 is the positive state - if we have a positive
                %number and we aren't checking for a slope change, we're
                %in state 0.
                if(slope < 0)
                    currentState = 1;
                    count = 1;
                    foundSample = i;
                    %If we go from a positive to negative slope, we enter
                    %state 1.
                    %FoundSample is lower because sample i-1 is the last
                    %point before the slope change.
                end
                i = i + 1;
            case 1
                %State 1 is the possible positive-negative slope-change
                %state. If we go from a positive slope to a negative
                %slope, we need to make sure we're negative for a certain
                %number of samples (denoted by 2nd input) before we truly
                %say we've changed slope.
                if(count >= samples)
                    i = i - 2;
                    currentState = 2;
                    emg_ssc(foundSample) = 1;
                    %If we are negative long enough, we go into state 2 and
                    %mark the sample as a slope change.
                elseif(slope >= 0)
                    currentState = 0;
                    %If we go back to positive slope, it's not a sample.
                end
                count = count + 1;
                i = i + 1;
            case 2
                %State 2 is the negative state - if we have a negative
                %slope and we aren't checking for a slope change, we're
                %in state 2.
                if(slope >= 0)
                    currentState = 3;
                    count = 1;
                    foundSample = i;
                    %If we go from a negative to positive slope, we enter
                    %state 3.
                    %FoundSample is lower because sample i-1 is the last
                    %point before the slope change.
                end
                i = i + 1;
            case 3
                %State 3 is the possible negative-positive slope-change
                %state. If we go from a negative slope to a positive
                %slope, we need to make sure we're positive for a certain
                %number of samples (denoted by 2nd input) before we truly
                %say we've changed slope.
                if(count >= samples)
                    i = i - 2;
                    currentState = 0;
                    emg_ssc(foundSample) = 1;
                    %If we are positive long enough, we go into state 0 and
                    %mark the sample as a slope change.
                elseif(slope < 0)
                    currentState = 2;
                    %If we go back to negative slope, it's not a sample.
                end
                count = count + 1;
                i = i + 1;
        end
    end
end