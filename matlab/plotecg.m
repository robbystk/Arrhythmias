function plotecg(ecg, varargin)
% plotecg: plots data from ECG struct with annotations
% marked
%   usage:  plotecg(ecg,options)
%   input:  the ecg struct to plot
%       options:
%           'Annotate': adds text labels if present
%           'Latex':    uses Latex interpreter for all text
%           'NoTitles': omits title and axis labels
%           'NoMarks':  omits beat annotation location markers
%   output: none

    plot(ecg.time,ecg.signal); 
    xlim([min(ecg.time), max(ecg.time)]);
    ys = ylim();

    if nargin > 1 && ismember('Latex',varargin)
        texify(gcf);
    end %latex if
    if ismember('Annotate',varargin) && isfield(ecg,'type')
        ty = ys(2) - (ys(2) - ys(1)) * 0.1;
        x = ecg.time(ecg.ann) + 0.05;
        y = ty * ones(ecg.Nann,1);
        strings = cellstr(ecg.type);
        if ismember('Latex',varargin)
            text(x,y,strings,'Interpreter','Latex');
        else
            text(x,y,strings)
        end %latex if
    end %annotation if
    if ~(nargin == 0 || ismember('NoTitles',varargin))
        title('ECG');
        xlabel('Time [s]');
        ylabel('Amplitude');
    end %title if
    if ~(nargin == 0 || ismember('NoMarks',varargin))
        hold on;
        for i = 1:ecg.Nann
            hold on;
            x = ecg.time(ecg.ann(i));
            line([x x],ys,'color','green');
        end % for
        ylim(ys);
        hold off;
end % function
