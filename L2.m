function L2(numOfReturnedImages, queryImageFeatureVector, dataset, metric)

% extract image fname from queryImage and dataset
query_img_name = queryImageFeatureVector(:, end);
dataset_img_names = dataset(:, end);

queryImageFeatureVector(:, end) = [];
dataset(:, end) = [];

euclidean = zeros(size(dataset, 1), 1);

if (metric == 2)
    % euclidean distance
    for k = 1:size(dataset, 1)
        euclidean(k) = sqrt( sum( power( dataset(k, :) - queryImageFeatureVector, 2 ) ) );
    end
elseif (metric == 3)
    % standardized euclidean distance
    weights = nanvar(dataset, [], 1);
    weights = 1./weights;
    for q = 1:size(dataset, 2)
        euclidean = euclidean + weights(q) .* (dataset(:, q) - queryImageFeatureVector(1, q)).^2;
    end
    euclidean = sqrt(euclidean);
elseif (metric == 4) %  mahalanobis distance
    weights = nancov(dataset);
    [T, flag] = chol(weights);
    if (flag ~= 0)
        errordlg('The matrix is not positive semidefinite. Please choose another similarity metric!');
        return;
    end
    weights = T \ eye(size(dataset, 2)); %inv(T)
    del = bsxfun(@minus, dataset, queryImageFeatureVector(1, :));
    dsq = sum((del/T) .^ 2, 2);
    dsq = sqrt(dsq);
    euclidean = dsq;
elseif (metric == 5)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'cityblock');
elseif (metric == 6)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'minkowski');
elseif (metric == 7)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'chebychev');
elseif (metric == 8)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'cosine');
elseif (metric == 9)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'correlation');
elseif (metric == 10)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'spearman');
elseif (metric == 11)
    % compute normalized euclidean distance
    for k = 1:size(dataset, 1)
        euclidean(k) = sqrt( sum( power( dataset(k, :) - queryImageFeatureVector, 2 ) ./ std(queryImageFeatureVector) ) );
    end
end

% adding image fnames to euclidean
euclidean = [euclidean dataset_img_names];

% sorting them according to smallest distance
[sortEuclidDist indxs] = sortrows(euclidean);
sortedEuclidImgs = sortEuclidDist(:, 2);

% clear axes
arrayfun(@cla, findall(0, 'type', 'axes'));

% display query image
str_name = int2str(query_img_name);
query_img = imread( strcat('images\', str_name, '.jpg') );
subplot(3, 7, 1);
imshow(query_img, []);
title('Query Image', 'Color', [1 0 0]);

% dispalying images returned by query
for m = 1:numOfReturnedImages
    img_name = sortedEuclidImgs(m);
    img_name = int2str(img_name);
    str_img_name = strcat('images\', img_name, '.jpg');
    returned_img = imread(str_img_name);
    subplot(3, 7, m+1);
    imshow(returned_img, []);
end

end