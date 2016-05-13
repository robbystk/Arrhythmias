%% Train classifier

% load data
load('normal_data');
load('abnormal_data');

%% PCA

% combine into one matrix
all_signals = [abnormal_signals normal_signals];

% normalize
[m,n] = size(all_signals);
means = mean(all_signals,2);    % mean of each row (dimension)
save('means','means');

X = all_signals - means * ones(1,n);

[U,S,V] = svd(X.');
%% plot transform
load('ecg_data');
excerpt = crop(ecg(1),12,0.3,0.3);
excerpt.time = excerpt.time - excerpt.time(excerpt.ann);
dim = [0, length(V)];

figure(5);
subplot(3,1,3); plotecg(excerpt,'Latex','NoTitles');
title('ECG'); xlabel('Time to QRS marker [s]');
subplot(3,1,[1,2]);
imagesc(excerpt.time,dim,V.')
title('Transformation Matrix');
% xlabel('Time to QRS marker [s]');
ylabel('Principal Component');
texify(gcf);
%% plot variances
variances = diag(S);
figure(6);
bar(variances(1:30));
xlim([0,31]);
title('Variances of First 30 Principal Components');
xlabel('Principal Component');
ylabel('Variance $\sigma$');
texify(gcf);

%% save transform
save('transform','V');

%% Means

% transform data separately
T_norm = pca_transform(normal_signals,means,V);
T_abnorm = pca_transform(abnormal_signals,means,V);

%% 
% PCA sorts dimensions by variance which is not necessarily what is desired
% for classification.  Instead, use dimensions that give the
% most-significant difference between normal and abnormal beats

% find relative difference in mean values of each dimension normalized by
% the variance of each dimension
norm_means = mean(T_norm);
abnorm_means = mean(T_abnorm);
norm_diff = abs(norm_means - abnorm_means) ./ diag(S).';

figure(7);
bar(norm_diff(1:30));
xlim([0,31]);
title('Difference in Means for First 30 Principal Components');
xlabel('Principal Component');
ylabel('Difference in Means $|\mu_{normal}-\mu_{abnormal}|$');
texify(gcf);
%%
[B,I] = sort(norm_diff, 'descend');

% Plot dimensions and difference in means 
figure(8);
bar(B(1:20)); title('Most Significant Components')
xlabel('Components (sorted)'); ylabel('Difference in Means');
xlim([0 21]);
texify(gcf);

% keep only 10 most-varying dimensions
V_sub = V(:,I(1:20));
save('V_sub','V_sub');
norm_means = norm_means(I(1:10));
save('norm_means','norm_means');
abnorm_means = abnorm_means(I(1:10));
save('abnorm_means','abnorm_means');

%% Train Classifier
T_sub = pca_transform(all_signals,means,V_sub);
X = [T_sub ones(size(T_sub,1),1)]; % add ones
% desired response
d = [ones(size(abnormal_signals,2),1); zeros(size(normal_signals,2),1)];

% solve for classifier weights
w = pinv(X.' * X) * X.' * d;

%% plot decision line
T_norm_sub = pca_transform(normal_signals,means,V_sub);
T_abnorm_sub = pca_transform(abnormal_signals,means,V_sub);

figure(9);
plot(T_norm_sub(:,1),T_norm_sub(:,2),'og',T_abnorm_sub(:,1),T_abnorm_sub(:,2),'sr');
legend({'Normal Beats','Abnormal Beats'},'Interpreter','Latex');
xs = xlim(); ys = ylim();
xx = linspace(xs(1), xs(2), 64);
yy = -w(1)/w(2)*xx - (w(end)-0.5)/w(2);
line(xx,yy,'color','k');
xlim(xs); ylim(ys);
title('First Two Most-Significant Components and Decision Boundary');
xlabel('First Most-Significant Component');
ylabel('Second Most-Significant Component');
texify(gcf);

%% Test Classifier
d_out = X * w > 0.5;
true_negatives = sum(d + d_out == 0) / length(d_out) * 100
false_positives = sum(d - d_out == -1) / length(d_out) * 100
false_negatives = sum(d - d_out == 1) / length(d_out) * 100
true_positives = sum(d + d_out == 2) / length(d_out) * 100

sensitivity = true_positives / (true_positives + false_negatives) * 100
specificity = true_negatives / (true_negatives + false_positives) * 100