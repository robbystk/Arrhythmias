function plotecg(ecg)
% plotecg: plots data from ECG struct with annotations
% marked
%   usage:  plotecg(ecg)
%   input:  the ecg struct to plot
%   output: none

    plot(ecg.time,ecg.signal); 
    title('ECG','Interpreter','Latex');
    xlabel('Time [s]','Interpreter','Latex');
    ylabel('Amplitude','Interpreter','Latex');
    xlim([min(ecg.time), max(ecg.time)]);

    fig = gcf;
    fig.CurrentAxes.TickLabelInterpreter = 'Latex';
    
    hold on;
    ys = ylim();
    ty = ys(2) - (ys(2) - ys(1)) * 0.9;
    for i = 1:ecg.Nann
        hold on;
        x = ecg.time(ecg.ann(i));
        line([x x],ys,'color','green');
    end % for
    hold off;
end % function
