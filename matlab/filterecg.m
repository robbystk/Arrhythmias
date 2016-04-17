function filtered = filterecg(ecg, varargin)
%filterecg: filters an ECG with a fourth-order butterworth filter with a
%passband of 1--50 Hz and a notch at 60 Hz unless otherwise specified
%   usage:  filtered = filterecg(ecg);
%       or: filtered = filterecg(ecg,fl,fh,fn);
%   input:  ECG struct to be filtered
%           high & low cutoff and notch frequencies in Hz (optional
%   output: filtered ECG struct

    % get info from ecg
    sig = ecg.signal;
    fs = ecg.fs;
    
    switch nargin
        case 1
            fl = 1;     % low cutoff
            fh = 50;    % high cutoff
            fn = 60;    % notch
        case 4
            fl = varargin(1);   % low cutoff
            fh = varargin(2);   % high cutoff
            fn = varargin(3);   % notch
        otherwise
            error('filterecg: must specify exactly three frequencies');
            return
    end % switch
    
    % normalize frequencies
    fl = fl * 2 / fs;   % low cutoff
    fh = fh * 2 / fs;   % high cutoff
    fn = fn * 2 / fs;   % notch
    bw = 1 * 2 / fs;    % notch -3dB bandwith
    
    % calculate filter coefficients
    [bb,ab] = butter(4,[fl,fh],'bandpass'); % bandpass
    [bn,an] = iirnotch(fn,bw);  % notch
    
    % filter signal
    fsig = filter(bn,an,filter(bb,ab,sig));
    
    % transfer info to output
    filtered = ecg;
    
    % change to filtered signal
    filtered.signal = fsig;
    
end % function