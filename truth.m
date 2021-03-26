clear all;

Truth = struct('time', [], 'unit', []);
Test = struct('time', {}, 'unit', {});

[emg, emgnonoise, noise] = emg_sim(0, 40);
zc = hudgins_zc(emg, 0);
ff = find(zc==1); % Sample locations of the zero crossings.
ff = ff./4096;

Truth.time = ff;
Truth.unit = ones(1, length(ff));

save 'zctruth.mat' Truth

ssc = hudgins_ssc(emg, 0);
ff = find(ssc==1);
ff = ff./4096;

Truth.time = ff;
Truth.unit = ones(1, length(ff));

save 'ssctruth.mat' Truth