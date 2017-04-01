PathRoot = './right/xef2/';  
list = dir(fullfile(PathRoot));
fileNum = size(list,1);
imgMCI_Cancellation = uint64(zeros(424, 512));
count_map = zeros(424, 512);
for k = 3 : fileNum
    if list(k).name(size(list(k).name,2)-2:size(list(k).name,2)) == 'png'
        imgName = [PathRoot,list(k).name]; 
        img = imread(imgName);
        flag_map1 = (1 - (img == 0));
        flag_map2 = img < 2000;
        flag_map = flag_map1 & flag_map2;
        imgMCI_Cancellation = imgMCI_Cancellation + uint64(img) .* uint64(flag_map);
        count_map = count_map + flag_map;
    end
end

% for i = 1:424
%     for j = 1:512
%         if count_map ~= 0
%             imgMCI_Cancellation(i,j) = imgMCI_Cancellation(i,j) / count_map(i,j);
%         end
%     end
% end

% imgMCI_Cancellation2 = imgMCI_Cancellation / (fileNum-3+1);
% imgMCI_Cancellation2 = uint16(imgMCI_Cancellation2);
% imshow(imgMCI_Cancellation2)
% figure

imgMCI_Cancellation = uint64(imgMCI_Cancellation);
count_map = uint64(count_map);
imgMCI_Cancellation = imgMCI_Cancellation ./ count_map;
imgMCI_Cancellation = uint16(imgMCI_Cancellation);
imshow(imgMCI_Cancellation);
imwrite(imgMCI_Cancellation, 'MCI_Cancellation_rightWithLeft.png')