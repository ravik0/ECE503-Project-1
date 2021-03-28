%This function tests hysteresis zero crossing accuracy.
%It has no inputs or outputs but plots an accuracy graph.
function test_hystzc()
    load 'hystzctruth.mat' Truth; %Load the zero crossing truths
    Test = struct('time', [], 'unit', []);
    samples = [1 2 3 4 5 6 7 8];
    noise = [0.2 0.4 0.6 0.8 1];
    %Get a list of the sample thresholds and noise values we're going to test.
    results = zeros(length(samples),length(noise)); %Preallocate an array.

    for i = 1:length(samples)
        for j = 1:length(noise)
            [emg] = emg_sim(noise(j), 40);
            %Simulate EMG with noise from array, same time as truth.
            zc = hyst_zc(emg, samples(i));
            %Find zero crossings using hysteresis and using the sample
            %thresholds from the array.
            ff = find(zc==1); 
            %Find all samples where there is a zero crossing and make an array.
            ff = ff./4096; %Get the timestamps of zero crossing.
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
    plot(samples, results, '-o');
    xlabel('Samples'), ylabel('Accuracy');
    title('Accuracy vs Samples and Noise for Hysteresis Zero Crossing');
    legend(...
        {'Noise: 20%', 'Noise: 40%','Noise: 60%', 'Noise: 80%','Noise: 100%'});
end