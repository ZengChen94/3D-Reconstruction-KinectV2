fip = fopen('./SensorData/geometric_15_real.bin','rb');
[real, count] = fread(fip, inf, 'float');
fclose(fip);
real_15 = reshape(real,424,512);

fip = fopen('./SensorData/geometric_80_real.bin','rb');
[real, count] = fread(fip, inf, 'float');
fclose(fip);
real_80 = reshape(real,424,512);

fip = fopen('./SensorData/geometric_120_real.bin','rb');
[real, count] = fread(fip, inf, 'float');
fclose(fip);
real_120 = reshape(real,424,512);

fip = fopen('./SensorData/geometric_15_imag.bin','rb');
[imag, count] = fread(fip, inf, 'float');
fclose(fip);
imag_15 = reshape(imag,424,512);

fip = fopen('./SensorData/geometric_80_imag.bin','rb');
[imag, count] = fread(fip, inf, 'float');
fclose(fip);
imag_80 = reshape(imag,424,512);

fip = fopen('./SensorData/geometric_120_imag.bin','rb');
[imag, count] = fread(fip, inf, 'float');
fclose(fip);
imag_120 = reshape(imag,424,512);

fip = fopen('./SensorData/R2Z.bin','rb');
[R2Z, count] = fread(fip, inf, 'float');
fclose(fip);
R2Z = reshape(R2Z,424,512);

f1 = 15e6;
f2 = 80e6;
f3 = 120e6;
c = 3e8;

arctan_15 = atan2(imag_15, real_15);
arctan_80 = atan2(imag_80, real_80);
arctan_120 = atan2(imag_120, real_120);
for i = 1:424
    for j = 1:512
        % make the value of arctan to be [0, 2pi]
        if arctan_15(i,j) < 0
            arctan_15(i,j) = arctan_15(i,j) + 2*pi;
        end
        if arctan_80(i,j) < 0
            arctan_80(i,j) = arctan_80(i,j) + 2*pi;
        end
        if arctan_120(i,j) < 0
            arctan_120(i,j) = arctan_120(i,j) + 2*pi;
        end
    end
end

groundTruth_depthMap_15 = arctan_15 ./ R2Z * c / (2*pi*2*f1);
groundTruth_depthMap_80 = arctan_80 ./ R2Z * c / (2*pi*2*f2);
groundTruth_depthMap_120 = arctan_120 ./ R2Z * c / (2*pi*2*f3);

groundTruth_maglitudeMap_15 = (imag_15.*imag_15 + real_15.*real_15).^(1/2);
groundTruth_maglitudeMap_80 = (imag_80.*imag_80 + real_80.*real_80).^(1/2);
groundTruth_maglitudeMap_120 = (imag_120.*imag_120 + real_120.*real_120).^(1/2);

% figure
% subplot(1,3,1);
% imshow(uint8(groundTruth_depthMap_15/(max(max(groundTruth_depthMap_15))-min(min(groundTruth_depthMap_15)))*255))
% subplot(1,3,2);
% imshow(uint8(groundTruth_depthMap_80/(max(max(groundTruth_depthMap_80))-min(min(groundTruth_depthMap_80)))*255))
% subplot(1,3,3);
% imshow(uint8(groundTruth_depthMap_120/(max(max(groundTruth_depthMap_120))-min(min(groundTruth_depthMap_120)))*255))

figure
imshow(uint8(groundTruth_maglitudeMap_15/(max(max(groundTruth_maglitudeMap_15))-min(min(groundTruth_maglitudeMap_15)))*255)+100)

%groundtruth
figure
load('./colorDevice_right.mat')
load('./depthDevice_right.mat')
depthImage_15 = uint16(groundTruth_depthMap_15 * 1000);
depthImage_15 = flipud(depthImage_15);
ptCloud_15 = pcfromkinect(depthDevice_right, depthImage_15);
pcshow(ptCloud_15, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down')
title('Initial world scene')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
drawnow
% save('./ptCloud_leftInterference', 'ptCloud_leftInterference');

%combine groundtruth and SRA-result
figure
load('./depth_map.mat')
depth_map = depth_map .* R2Z;
depth_map = uint16(depth_map*1000);
depthCombine_map = flipud(depthImage_15);
for i = 192:222
    for j = 157:185
        depthCombine_map(i,j) = depth_map(i,j);
    end
end
depthCombine_map = flipud(depthCombine_map);
depthCombine_ptClout = pcfromkinect(depthDevice_right, depthCombine_map);
pcshow(depthCombine_ptClout, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down')
title('Initial world scene')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
drawnow
        

