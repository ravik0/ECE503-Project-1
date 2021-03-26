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

    for i = 2:length(emg)
        slope = emg(i) - emg(i-1); %Get slope
        switch (currentState)
            case 0
                %State 0 is the positive state - if we have a positive
                %number and we aren't checking for a slope change, we're
                %in state 0.
                if(slope < 0)
                    currentState = 1;
                    count = 1;
                    foundSample = i-1;
                    %If we go from a positive to negative slope, we enter
                    %state 1.
                    %FoundSample is lower because sample i-1 is the last
                    %point before the slope change.
                end
            case 1
                %State 1 is the possible positive-negative slope-change
                %state. If we go from a positive slope to a negative
                %slope, we need to make sure we're negative for a certain
                %number of samples (denoted by 2nd input) before we truly
                %say we've changed slope.
                count = count + 1;
                %We count first because the first SSC already counted as 1.
                if(slope >= 0)
                    currentState = 0;
                    %If we go back to positive slope, it's not a sample.
                elseif(slope < 0 && count >= samples)
                    currentState = 2;
                    emg_ssc(foundSample) = 1;
                    %If we are negative long enough, we go into state 2 and
                    %mark the sample as a slope change.
                end
            case 2
                %State 2 is the negative state - if we have a negative
                %slope and we aren't checking for a slope change, we're
                %in state 2.
                if(slope >= 0)
                    currentState = 3;
                    count = 1;
                    foundSample = i-1;
                    %If we go from a negative to positive slope, we enter
                    %state 3.
                    %FoundSample is lower because sample i-1 is the last
                    %point before the slope change.
                end
            case 3
                %State 3 is the possible negative-positive slope-change
                %state. If we go from a negative slope to a positive
                %slope, we need to make sure we're positive for a certain
                %number of samples (denoted by 2nd input) before we truly
                %say we've changed slope.
                count = count + 1;
                %We count first because the first SSC already counted as 1.
                if(slope < 0)
                    currentState = 2;
                    %If we go back to negative slope, it's not a sample.
                elseif(slope >= 0 && count >= samples)
                    currentState = 0;
                    emg_ssc(foundSample) = 1;
                    %If we are positive long enough, we go into state 0 and
                    %mark the sample as a slope change.
                end
        end
    end
end