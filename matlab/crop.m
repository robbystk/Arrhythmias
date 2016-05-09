function excerpt = crop(ecg, n, varargin)
% crop:     extracts a portion of an ECG signal around the nth marker in
%           the list of annotations
%   usage:  excerpt = crop(ecg, n);
%       or: excerpt = crop(ecg, n, before, after);
%   input:  the ECG struct to be cropped
%           the number of the beat to extract
%           time in seconds before beat to begin excerpt (optional)
%           time in seconds after beat to end excerpt (optional)
%   output: an ECG struct with the extracted data, including the beat
%           annotation

if n > ecg.Nann
    error('crop: n is too big');
    return
end % if

% offsets
switch nargin
    case 2
        before  = 0.300;    % time before beat to start excerpt in seconds
        after   = 0.500;    % time after beat to start excerpt in seconds
    case 4
        before = varargin{1};
        after = varargin{2};
    otherwise
        error('crop: must supply 2 or 4 arguments');
        return
end % switch

% convert times to indices
b_index = ecg.ann(n) - floor(before * ecg.fs);
a_index = ecg.ann(n) + floor(after * ecg.fs);

% clip indices within bounds
if b_index < 1
    b_index = 1;
end % if

if a_index > ecg.N
    a_index = ecg.N;
end % if

excerpt = ecg;
excerpt.signal = ecg.signal(b_index:a_index);
excerpt.time = ecg.time(b_index:a_index);
excerpt.N = a_index - b_index + 1;
excerpt.ann = ecg.ann(n) - b_index + 1;
excerpt.Nann = 1;
end %function