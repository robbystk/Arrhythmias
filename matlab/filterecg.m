function filtered = filterecg(ecg, varargin)
%filterecg: filters an ECG with a fourth-order butterworth filter with a
%passband of 1--50 Hz unless otherwise specified
%   usage:  filtered = filterecg(ecg);
%       or: filtered = filterecg(ecg,fl,fh);
%   input:  ECG struct to be filtered
%           high and low cutoff frequencies in Hz (optional
%   output: filtered ECG struct

    % get info from ecg
    sig = ecg.signal;
    fs = ecg.fs;
    fn = fs / 2;    % nyquist frequency for normalization
    
    switch nargin
        case 1
            fl = 1 / fn;    % normalize
            fh = 50 / fn;
        case 3
            fl = varargin(1) / fn;
            fh = varargin(2) / fn;
        otherwise
            error('filterecg: must specify exactly two frequencies');
            return
    end % switch
    
    % calculate filter coefficients
    [b,a] = butter(4,[fl,fh],'bandpass');
    
    % filter signal
    fsig = filter(b,a,sig);
    
    % transfer info to output
    filtered = ecg;
    
    % change to filtered signal
    filtered.signal = fsig;
    
end % function