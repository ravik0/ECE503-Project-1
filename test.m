clear all;
% Simulate EMG. Should eliminate filter start-up transient!!
% Seed random number generator to make it repeatable for this example.
[emg, emgnonoise, noise] = emg_sim(0.1);
EMGin = emg;
% Detect zero crossings.
EMGout = hyst_zc(EMGin, 2);
% Plot.
plot(EMGin, 'b'), box('off');
ff = find(EMGout==1); % Sample locations of the zero crossings.
hold on, plot(ff-0.5, 0, 'mo'), hold off
axis([5640 5960 -0.85 0.85])
xlabel('Sample Number'), ylabel('Raw EMG (arbitrary units)')
print -r300 -dtiff fig_zc.tif