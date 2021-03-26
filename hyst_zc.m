function[emg_zc] = hyst_zc(emg, samples)
    currentState = 0;
    count = 1;
    foundSample = 1;
    emg_zc = false(1,length(emg));
    
    if (emg(1) > 0) 
        currentState = 0;
    elseif (emg(1) < 0) 
        currentState = 2;
    end
    
    for i = 1:length(emg)
        switch (currentState)
            case 0
                if (emg(i) < 0)
                    currentState = 1;
                    count = 1;
                    foundSample = i;
                end
            case 1
                count = count + 1;
                if (emg(i) >= 0)
                    currentState = 0;
                elseif(emg(i) < 0 && count == samples)
                    currentState = 2;
                    emg_zc(foundSample) = 1;
                end
            case 2
                if (emg(i) >= 0)
                    currentState = 3;
                    count = 1;
                    foundSample = i;
                end
            case 3
                count = count + 1;
                if (emg(i) < 0)
                    currentState = 2;
                elseif(emg(i) >= 0 && count == samples)
                    currentState = 0;
                    emg_zc(foundSample) = 1;
                end
        end 
    end
end