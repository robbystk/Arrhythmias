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

save('transform','V');

%% Classification

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

[B,I] = sort(norm_diff, 'descend');

% Plot dimensions and difference in means 
bar(B(1:20)); title('Dimensions with Largest Difference in Means')
xlabel('Dimension (sorted)'); ylabel('Difference in Means');
xlim([0 21]);

% keep only 10 most-varying dimensions
V_sub = V(I(1:10));
save('V_sub','V_sub');
norm_means = norm_means(I(1:10));
save('norm_means','norm_means');
abnorm_means = abnorm_means(I(1:10));
save('abnorm_means','abnorm_means');