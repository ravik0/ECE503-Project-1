%This function tests hudgin's slope sign changing accuracy.
%It has no inputs or outputs but plots an accuracy graph.
function test_ssc()
    %Here, we test hudgin's slope sign changing accuracy.
    load 'ssctruth.mat' Truth; %Load the slope sign change truths
    Test = struct('time', [], 'unit', []);
    thresh = [0.05, 0.15, 0.30, 0.45, 0.60, 0.75 0.9 1];
    noise = [0.2 0.4 0.6 0.8 1];
    %Get a list of the threshold and noise values we're going to test.
    results = zeros(length(thresh),length(noise)); %Preallocate an array.

    for i = 1:length(thresh)
        for j = 1:length(noise)
            [emg] = emg_sim(noise(j), 40);
            %Simulate EMG with noise from array, same time as truth.
            ssc = hudgins_ssc(emg, thresh(i));
            %Find slope changes using hudgin's and using threshold from array.
            ff = find(ssc==1); 
            %Find all samples where there is a slope change and make an array.
            ff = ff./4096; %Get the timestamps of slope change.
            Test.time = ff;
            Test.unit = ones(1, length(ff)); %Create test unit.
            Sp = eaf_compare(Truth, Test, 'Window', 0.1);
            %Compare the two with 100ms windows.
            results(i,j) = Sp.Confuse(1,1)/sum(Sp.Confuse(:));
            %Record the accuracy in the results array.
        end
    end

    %Plot
    figure;
    hold on
    plot(thresh, results, '-o');
    xlabel('Threshold'), ylabel('Accuracy');
    title('Accuracy vs Threshold and Noise for Hudgins Slope Sign Changes');
    legend(...
        {'Noise: 20%', 'Noise: 40%','Noise: 60%', 'Noise: 80%','Noise: 100%'});
end