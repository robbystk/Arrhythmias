function excerpt = crop(ecg, beats, varargin)
% crop:     extracts a portion of an ECG signal around the nth marker in
%           the list of annotations
%   usage:  excerpt = crop(ecg, beats);
%       or: excerpt = crop(ecg, beats, before, after);
%   input:  the ECG struct to be cropped
%           the number of the beat to extract
%           time in seconds before beat to begin excerpt (optional)
%           time in seconds after beat to end excerpt (optional)
%   output: an ECG struct with the extracted data, including the beat
%           annotations

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
b_offset = floor(before * ecg.fs);
a_offset = floor(after * ecg.fs);

% start and end index
s_index = max(1,ecg.ann(beats) - b_offset);
e_index = min(ecg.N,ecg.ann(beats) + a_offset);

excerpt = ecg;
excerpt.signal = ecg.signal(s_index:e_index);
excerpt.time = ecg.time(s_index:e_index);
excerpt.N = e_index - s_index + 1;
excerpt.ann = ecg.ann(beats) - s_index + 1;
excerpt.Nann = 1;
end %function