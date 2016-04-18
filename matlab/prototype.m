%% plot
figure(1); plot(tm,sig); hold on;
ys = ylim();
ty = ys(2) - (ys(2) - ys(1)) * 0.9;
ab = [];
for i = 1:Nann
    hold on;
    x = tm(ann(i));
    t = type(i);
    if t == 'N'
        line([x x],ys,'color','green');
    else
        line([x x],ys,'color','red');
        text(x,ty,t);
        ab = [ab i];
    end % if
end % for

hold off;

%% loop through annotations
for i = ab
    x = tm(ann(i));
    xlim([x-1 x+1]);
    clc;
    sprintf('press any key to go to next abnormal beat')
    pause;
end % for