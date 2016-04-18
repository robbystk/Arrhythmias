function peaks = findqrs(ecg)
%findpeaks: finds the location of qrs complexes in an ecg using the
%Pan-Tompkins algorithm
%   usage:  peaks = findqrs(ecg);
%   input:  ECG struct to find peaks in
%   output: a list of indices of the peaks of the QRS complexes

    % filter with passband of 5-11 Hz
    fecg = filterecg(ecg);
    % fecg = ecg;
    % extract signal and sample frequency
    sig = fecg.signal;
    fs = fecg.fs;
    % first difference
    sig = filter([1 -1],1,sig);
    % square 
    sig = sig .* sig;
    % moving average
    T = 0.150;                  % width in seconds
    W = round(T*fs);            % width in samples
    b = ones(1,W) / W;          % W-sample average
    sig = filtfilt(b,1,sig);    % compute moving average
    
    % plot(sig);
    
    % threshold
    % get ranges
    % maximum (magnitude) in each range
    
end % function