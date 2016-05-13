function texify(figure)
%texify: makes latex the interpreter for title and axis labels of the
%current axis of a figure
%   usage:  texify(figure)
%   input:  figure handle to texify
%   output: none
    figure.CurrentAxes.TickLabelInterpreter = 'Latex';
    figure.CurrentAxes.Title.Interpreter = 'Latex';
    figure.CurrentAxes.XLabel.Interpreter = 'Latex';
    figure.CurrentAxes.YLabel.Interpreter = 'Latex';
end % function