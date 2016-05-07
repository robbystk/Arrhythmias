function plotecg(ecg)
% plotecg: plots data from ECG struct with annotations
% marked
%   usage:  plotecg(ecg)
%   input:  the ecg struct to plot
%   output: none

    plot(ecg.tm,ecg.signal); hold on;
    ys = ylim();
    ty = ys(2) - (ys(2) - ys(1)) * 0.9;
    abnormal = [];
    for i = 1:Nann
        hold on;
        x = tm(ann(i));
        t = type(i);
        if t == 'N'
            line([x x],ys,'color','green');
        else
            line([x x],ys,'color','red');
            text(x,ty,t);
            abnormal = [abnormal i];
        end % if
    end % for
    hold off;
end % function
