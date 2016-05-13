%% Create figures

%% Load data
load('ecg_data');
ecg = ecg(1);

%% Raw ECG
figure(1); 
subplot(2,1,1); plotecg(crop(ecg,1906:1907),'Latex','Annotate');
title('Raw ECG Showing a Normal Beat and a Premature Ventricular Contraction');
subplot(2,1,2); plotecg(crop(ecg,1603:1604),'Latex','Annotate');
title('Raw ECG Showing a Normal Beat and an Atrial Premature Beat');

%% Filtered ECG
figure(2); 
subplot(2,1,1); plotecg(crop(ecg,126:127),'Latex');
title('Raw ECG');
fecg = filterecg(ecg);
subplot(2,1,2); plotecg(crop(fecg,126:127),'Latex');
title('Filtered ECG');

%% findqrs Stages
figure(3);
% filtered
subplot(2,3,1); plotecg(crop(fecg,457),'Latex','NoTitles','NoMarks');
title('Filtered ECG');
% difference
qrs = fecg;
qrs.signal = gradient(qrs.signal);
subplot(2,3,2); plotecg(crop(qrs,457),'Latex','NoTitles','NoMarks');
title('Differentiated Signal');
% square
qrs.signal = qrs.signal .^ 2;
subplot(2,3,3); plotecg(crop(qrs,457),'Latex','NoTitles','NoMarks');
title('Squared Signal');
% moving average
T = 0.150;                  % width in seconds
W = round(T*qrs.fs);        % width in samples
b = ones(1,W) / W;          % W-sample average
qrs.signal = filtfilt(b,1,qrs.signal);    % compute moving average
subplot(2,3,4); plotecg(crop(qrs,457),'Latex','NoTitles','NoMarks');
title('Moving Average');
th = rms(qrs.signal);
xs = xlim();
hold on;
line(xs,[th, th],'Color','Black');
hold off;
% max
qrs.signal = (qrs.signal > th) .* fecg.signal;
subplot(2,3,5); plotecg(crop(qrs,457),'Latex','NoTitles','NoMarks');
title('Max In Range');
qrs.ann = findqrs(ecg);
hold on;
x = fecg.time(qrs.ann(457));
y = fecg.signal(qrs.ann(457));
plot(x,y,'r*');
hold off;
% final result
fecg.ann = findqrs(ecg);
fecg.Nann = length(fecg.ann);
subplot(2,3,6); plotecg(crop(fecg,457),'Latex','NoTitles');
title('Final Result');

%% findqrs Performance
figure(4)
subplot(2,1,1); plotecg(crop(fecg,457,0.05,0.05),'Latex');
title('A Closer Look at \verb`findqrs`''s Precision');
load('ecg_data')
qrs = filterecg(ecg(2));
qrs.ann = findqrs(ecg(2));
qrs.Nann = length(qrs.ann);

subplot(2,1,2); plotecg(crop(qrs,2002:2006),'Latex');
title('Extra Beats Erroneously Detected by \verb`findqrs`');
