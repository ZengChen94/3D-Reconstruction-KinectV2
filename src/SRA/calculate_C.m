data1 = load('./SR4000-mat/test1_29MHz.mat');
data2 = load('./SR4000-mat/test1_30MHz.mat');
data3 = load('./SR4000-mat/test1_31MHz.mat');

f1 = 29*1000000;
f2 = 30*1000000;
f3 = 31*1000000;
c = 3e8;

C_matrix = zeros(144,176,6,6);
v1 = zeros(1,size(data1.ptCloudData,1));
v2 = zeros(1,size(data1.ptCloudData,1));
v3 = zeros(1,size(data1.ptCloudData,1));
v4 = zeros(1,size(data1.ptCloudData,1));
v5 = zeros(1,size(data1.ptCloudData,1));
v6 = zeros(1,size(data1.ptCloudData,1));
for i = 1:144
    for j = 1:176
%         v1 = []; v2 = []; v3 = []; v4 = []; v5 = []; v6 = [];
        for num = 1:size(data1.ptCloudData,1)
            img1 = squeeze(data1.ptCloudData(num,:,:,:));
            img2 = squeeze(data2.ptCloudData(num,:,:,:));
            img3 = squeeze(data3.ptCloudData(num,:,:,:));
            v1(num) = img1(i,j,4) * cos(2 * pi * (img1(i,j,1)^2+img1(i,j,2)^2+img1(i,j,3)^2)^(1/2) * 2 * f1 / c);
            v2(num) = img2(i,j,4) * cos(2 * pi * (img2(i,j,1)^2+img2(i,j,2)^2+img2(i,j,3)^2)^(1/2) * 2 * f2 / c);
            v3(num) = img3(i,j,4) * cos(2 * pi * (img3(i,j,1)^2+img3(i,j,2)^2+img3(i,j,3)^2)^(1/2) * 2 * f3 / c);
            v4(num) = img1(i,j,4) * sin(2 * pi * (img1(i,j,1)^2+img1(i,j,2)^2+img1(i,j,3)^2)^(1/2) * 2 * f1 / c);
            v5(num) = img2(i,j,4) * sin(2 * pi * (img2(i,j,1)^2+img2(i,j,2)^2+img2(i,j,3)^2)^(1/2) * 2 * f2 / c);
            v6(num) = img3(i,j,4) * sin(2 * pi * (img3(i,j,1)^2+img3(i,j,2)^2+img3(i,j,3)^2)^(1/2) * 2 * f3 / c);
%             v1 = [v1, img1(i,j,4) * cos(2 * pi * (img1(i,j,1)^2+img1(i,j,2)^2+img1(i,j,3)^2)^(1/2) * 2 * f1 / c)];
%             v2 = [v2, img2(i,j,4) * cos(2 * pi * (img2(i,j,1)^2+img2(i,j,2)^2+img2(i,j,3)^2)^(1/2) * 2 * f2 / c)];
%             v3 = [v3, img3(i,j,4) * cos(2 * pi * (img3(i,j,1)^2+img3(i,j,2)^2+img3(i,j,3)^2)^(1/2) * 2 * f3 / c)];
%             v4 = [v4, img1(i,j,4) * sin(2 * pi * (img1(i,j,1)^2+img1(i,j,2)^2+img1(i,j,3)^2)^(1/2) * 2 * f1 / c)];
%             v5 = [v5, img2(i,j,4) * sin(2 * pi * (img2(i,j,1)^2+img2(i,j,2)^2+img2(i,j,3)^2)^(1/2) * 2 * f2 / c)];
%             v6 = [v6, img3(i,j,4) * sin(2 * pi * (img3(i,j,1)^2+img3(i,j,2)^2+img3(i,j,3)^2)^(1/2) * 2 * f3 / c)];
        end
        C_matrix(i,j,1,1) = var(v1, 1);
        C_matrix(i,j,2,2) = var(v2, 1);
        C_matrix(i,j,3,3) = var(v3, 1);
        C_matrix(i,j,4,4) = var(v4, 1);
        C_matrix(i,j,5,5) = var(v5, 1);
        C_matrix(i,j,6,6) = var(v6, 1);
        [i, j]
    end
end

% var(a,1)