function plotecg(ecg, varargin)
% plotecg: plots data from ECG struct with annotations
% marked
%   usage:  plotecg(ecg) or plotecg(ecg,beats)
%   input:  the ecg struct to plot
%           the beats to show (and annotate) (optional)
%   output: none

    plot(ecg.time,ecg.signal); 
    title('ECG');
    xlabel('Time [s]');
    ylabel('Amplitude');
    
    switch nargin
        case 1
            beats = 1:ecg.Nann;
            limits = [min(ecg.time) max(ecg.time)];
        case 2
            beats = varargin{1};
            t_range = ecg.time(ecg.ann(varargin{1}));
            limits = [min(t_range) - 0.5, max(t_range) + 0.5];
    end % switch

    hold on;
    ys = ylim();
    ty = ys(2) - (ys(2) - ys(1)) * 0.9;
    for i = beats
        hold on;
        x = ecg.time(ecg.ann(i));
        line([x x],ys,'color','green');
    end % for
    
    xlim(limits)
    
    hold off;
end % function
