%% gather many ECG signals to perform principal component analysis on

records = {'mitdb/100'; 'mitdb/118'; 'mitdb/209'; ...
    'mitdb/222'; 'mitdb/232'};

for i = 1:length(records)
    ecg(i) = fetch(records{i});
end % for

save('ecg_data','ecg');

%% Extract abnormal beats
abnormal_signals = [];
normal_signals = [];
for i = 1:length(ecg)
    abnormal_beats = find(ecg(i).type == 'A');
    normal_beats = find(ismember(ecg(i).type,'NLRB'));
    N_abnorm = length(abnormal_beats);  % number of abnormal beats
    N_norm = length(normal_beats);      % number of normal beats
    N_beats = min(N_norm,N_abnorm);     % total number of beats to analyze
    % select an an equal number of normal beats as abnormal beats
    normal_beats = normal_beats(randperm(N_norm,N_beats));
    abnormal_beats = abnormal_beats(randperm(N_abnorm,N_beats));
    
    % find qrs complexes and filter
    qrs = ecg(i);
    qrs.ann = findqrs(ecg(i));
    qrs.Nann = length(qrs.ann);
    qrs = filterecg(qrs);
    for j = 1:N_beats
        % find the qrs complex closest to the abnormal beat marker
        beat_no = find(abs(qrs.ann - ecg(i).ann(abnormal_beats(j))) < 108);
        % leave off the first and last beats of the signal
        if beat_no ~= 1 | beat_no ~= qrs.Nann
            beat = crop(qrs,beat_no,0.3,0.3);
            abnormal_signals = [abnormal_signals beat.signal];
        end % if
        
        % repeat for normal beats
        % find the qrs complex closest to the abnormal beat marker
        beat_no = find(abs(qrs.ann - ecg(i).ann(normal_beats(j))) < 108);
        % leave off the first and last beats of the signal
        if all(beat_no ~= 1 | beat_no ~= qrs.Nann)
            beat = crop(qrs,beat_no,0.3,0.3);
            normal_signals = [normal_signals beat.signal];
        end % if
    end % for
end % for

%%

% save data
save('normal_data','normal_signals');
save('abnormal_data','abnormal_signals');