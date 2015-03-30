function hsvColorHistogram = hsvHistogram(image)
% input: image to be quantized in hsv color space into 8x2x2 equal bins

[rows, cols, numOfBands] = size(image);
% totalPixelsOfImage = rows*cols*numOfBands;
image = rgb2hsv(image);

% split image into h, s & v planes
h = image(:, :, 1);
s = image(:, :, 2);
v = image(:, :, 3);

numberOfLevelsForH = 8;
numberOfLevelsForS = 2;
numberOfLevelsForV = 2;

% Find the max.
maxValueForH = max(h(:));
maxValueForS = max(s(:));
maxValueForV = max(v(:));

% final histogram matrix of size 8x2x2
hsvColorHistogram = zeros(8, 2, 2);

% col vector of indexes for later reference
index = zeros(rows*cols, 3);

count = 1;
for row = 1:size(h, 1)
    for col = 1 : size(h, 2)
        quantizedValueForH(row, col) = ceil(numberOfLevelsForH * h(row, col)/maxValueForH);
        quantizedValueForS(row, col) = ceil(numberOfLevelsForS * s(row, col)/maxValueForS);
        quantizedValueForV(row, col) = ceil(numberOfLevelsForV * v(row, col)/maxValueForV);
        
        % indexes where 1 should be put in matrix hsvHist
        index(count, 1) = quantizedValueForH(row, col);
        index(count, 2) = quantizedValueForS(row, col);
        index(count, 3) = quantizedValueForV(row, col);
        count = count+1;
    end
end

for row = 1:size(index, 1)
    if (index(row, 1) == 0 || index(row, 2) == 0 || index(row, 3) == 0)
        continue;
    end
    hsvColorHistogram(index(row, 1), index(row, 2), index(row, 3)) = ... 
        hsvColorHistogram(index(row, 1), index(row, 2), index(row, 3)) + 1;
end

hsvColorHistogram = hsvColorHistogram(:)';
hsvColorHistogram = hsvColorHistogram/sum(hsvColorHistogram);

clear('row', 'col', 'count', 'numberOfLevelsForH', 'numberOfLevelsForS', ...
    'numberOfLevelsForV', 'maxValueForH', 'maxValueForS', 'maxValueForV', ...
    'index', 'rows', 'cols', 'h', 's', 'v', 'image', 'quantizedValueForH', ...
    'quantizedValueForS', 'quantizedValueForV');

% figure('Name', 'Quantized leves for H, S & V');
% subplot(2, 3, 1);
% imshow(seg_h, []);
% subplot(2, 3, 2);
% imshow(seg_s, []);
% title('Quatized H,S & V by matlab function imquantize');
% subplot(2, 3, 3);
% imshow(seg_v, []);
% subplot(2, 3, 4);
% imshow(quantizedValueForH, []);
% subplot(2, 3, 5);
% imshow(quantizedValueForS, []);
% title('Quatized H,S & V by my function');
% subplot(2, 3, 6);
% imshow(quantizedValueForV, []);

end