function ecg = fetch(url)
%fetch: gets ECG data from physionet
%   usage:  ecg = fetch(url);
%   input:  the physionet url of the physionetdb record to download, 
%           e.g. 'mitdb/100'
%   output: an ECG struct containing the 1st signal and annotations if
%           present

    % add WFDB toolbox to path
    addpath('U:\classes\ece\480\wfdb-app-toolbox-0-9-9\mcode');

    % pull data from physionet
    [tm,sig] = rdsamp(url,1);
    [ann,type,subtype,chan,num,comments] = rdann(url,'atr');
    
    % bundle into struct
    ret.signal = sig;
    ret.time = tm;
    ret.N = length(sig);
    ret.ann = ann(type ~= '+');
    ret.Nann = length(ann);
    ret.fs = (ret.N - 1) / (tm(ret.N) - tm(1));
    
    % return ECG struct
    ecg = ret;
end % function