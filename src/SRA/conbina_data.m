A = dir(fullfile('./SR4000-dat/test1_31MHz','*.dat'));
num = size(A,1);

m = 144;
n = 176;

ptCloudData = zeros(num, m, n, 4);

for k = 1 : num
    combinedStr = strcat('./SR4000-dat/test1_31MHz/', A(k).name);
    data = load(combinedStr);
    ptCloudData(k, : , : , 3) = data(1:144, :);
    ptCloudData(k, : , : , 1) = data(144+1:144*2, :);
    ptCloudData(k, : , : , 2) = data(144*2+1:144*3, :);
    ptCloudData(k, : , : , 4) = data(144*3+1:144*4, :);
end

save('./SR4000-mat/test1_31MHz.mat','ptCloudData')

% loc = zeros(m, n, 3);
% k = 10;
% loc(:, :, 3) = ptCloudData(k, : , : , 3);
% loc(:, :, 1) = ptCloudData(k, : , : , 1);
% loc(:, :, 2) = ptCloudData(k, : , : , 2);
% ptCloud = pointCloud(loc);
% 
% pcshow(ptCloud, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down')
% title('Initial world scene')
% xlabel('X (m)')
% ylabel('Y (m)')
% zlabel('Z (m)')
% drawnow