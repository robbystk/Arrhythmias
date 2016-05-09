function T = pca_transform(measurements,means,transform)
%pca_transform: transforms a measurement using principal component matrix 
%       after normalizing to the mean value of each measurement
%   usage:  T = pca_transform(measurements,means,transform)
%   input:  The raw measurements to transform (m rows x n columns)
%           A list of mean values of each measurement for normalization
%               (m rows)
%           The transformation matrix to apply (m rows x d columns)
%   output: The transformed data (n rows x d columns)

    % normalize
    [m,n] = size(measurements);
    X = measurements - means * ones(1,n);

    % transform
    T = X.' * transform;
end % function