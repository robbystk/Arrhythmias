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
    fsig = fecg.signal;
    fs = fecg.fs;
    % first difference
    sig = gradient(fsig);
    % square 
    sig = sig .* sig;
    % moving average
    T = 0.150;                  % width in seconds
    W = round(T*fs);            % width in samples
    b = ones(1,W) / W;          % W-sample average
    sig = filtfilt(b,1,sig);    % compute moving average
    
    % threshold
    threshold = 1;
    th = sig > threshold * rms(sig);    
        % 1 if moving average is above threshold, 0 otherwise
    dth = 2*gradient(double(th));   % derivative of threshold signal:
        % 1 at start of range, -1 at end
    
    % get ranges
    starts = find(dth == 1);    % list of range starts
    stops = find(dth == -1);    % list of range ends
    
    Nbeats = min(length(starts), length(stops));    % number of ranges
    
    % maximum (magnitude) in each range
    for i = 1:Nbeats
        excerpt = fsig(starts(i):stops(i));
        [M,peak] = max(excerpt);
        peaks(i) = peak + starts(i) - 1;
    end % for
end % function