function peaks = findqrs(ecg)
%findpeaks: finds the location of qrs complexes in an ecg using the
%Pan-Tompkins algorithm
%   usage:  peaks = findqrs(ecg);
%   input:  ECG struct to find peaks in
%   output: a list of indices of the peaks of the QRS complexes

    % extract signal
    sig = ecg.signal;
    % filter
    % first difference
    filter([1 -1],1,sig);
    % square 
    % moving average
    % threshold
    % get ranges
    % maximum (magnitude) in each range
    
end % function