load('ptCloud_leftWithRight.mat');
load('ptCloud_middleWithRight.mat');
load('ptCloud_rightWithLeft.mat')
ptCloudLeft = ptCloud_leftWithRight;
ptCloudMiddle = ptCloud_middleWithRight;
ptCloudRight = ptCloud_rightWithLeft;

% load('ptCloud-left.mat');
% ptCloudLeft = ptCloud;
% load('ptCloud-middle.mat');
% ptCloudMiddle = ptCloud;
% load('ptCloud-right.mat')
% ptCloudRight = ptCloud;

% calibration
%infrared
% tForm_left_middle = [0.999731479725430, -0.00355743994510181, -0.0228978834620148, 0; 0.00418499073978047, 0.999615317899917, 0.0274171857117977, 0; 0.0227915400644838, -0.0275056510718115, 0.999361788773518, 0; -507.319268954654/1000, 1.68879589338530/1000, -17.1948731014063/1000, 1];
tForm_middle_left = [0.999731499268385, 0.00418496390960933, 0.0227906877399861, 0; -0.00355740781363948, 0.999615283563679, -0.0275069030527385, 0; -0.0228970351843583, 0.0274184416584999, 0.999361773752021, 0; 506.795202250023/1000, 0.906364011121925/1000, 28.7943462882500/1000, 1];
tForm_middle_right = [0.999342943500039, 0.0124865348138958, -0.0340259860256803, 0; -0.0121156276687899, 0.999865156121485, 0.0110851766043934, 0; 0.0341598132733432, -0.0106656468393017, 0.999359470428249, 0; -503.936415615071/1000, -2.49548585569602/1000, 16.4820244103602/1000, 1];
tForm_right_middle = [0.999343012350319, -0.0121156524884839, 0.0341577902003094, 0; 0.0124864024945006, 0.999865199969679, -0.0106616904072554, 0; -0.0340240123932406, 0.0110811937250969, 0.999359581795407, 0; 504.201099207537/1000, -3.79257714182739/1000, 0.698337454499928/1000, 1];
tForm_left_right = [0.998978358826491, 0.00836573599785470, -0.0444100558155940, 0; -0.00661759627501385, 0.999202957126949, 0.0393656943073766, 0; 0.0447039821030621, -0.0390315888733100, 0.998237491308634, 0; -1010.72111490021/1000, -6.67052746387143/1000, 12.6546361826451/1000, 1];
tForm_right_left = [0.998978836782230, -0.00661770437341760, 0.0446932841716576, 0; 0.00836541543352050, 0.999202965710684, -0.0390314378366770, 0; -0.0443993635747981, 0.0393654582572058, 0.998237976241314, 0; 1010.30518274807/1000, -0.521524638385544/1000, 32.2838000463216/1000, 1];
% %color
tForm_left_middle = [0.999655010239871, -0.0106230574792691, -0.0240210564321293, 0; 0.0111583934709223, 0.999689876322686, 0.0222630059309425, 0; 0.0237771057421099, -0.0225233618211236, 0.999463529807268, 0; -506.579194907722/1000, 5.97978031798834/1000, -18.6257384671033/1000-0.05, 1];
% tForm_middle_left = [0.999655016579278, 0.0111583951532355, 0.0237768384249753, 0; -0.0106230673223970, 0.999689878286164, -0.0225232700303352, 0; -0.0240207882582348, 0.0222629169202920, 0.999463538235214, 0; 506.020566893343/1000, 0.0893156786592492/1000, 30.7958560188725/1000, 1];
% tForm_middle_right = [0.998155885022025, 0.0272096993946727, -0.0542628920603104, 0; -0.0267222188538787, 0.999595939399754, 0.00968921849526246, 0; 0.0545046072861988, -0.00822132558503044, 0.998479673098157, 0; -508.519457280462/1000, -6.02824493600367/1000, 28.2183679580227/1000, 1];
% tForm_right_middle = [0.998156037323135, -0.0267221648109838, 0.0545018445852205, 0; 0.0272095676701232, 0.999595950666738, -0.00822039158833848, 0; -0.0542601564924199, 0.00968820512144843, 0.998479831593479, 0; 509.279733638042/1000, -7.83608458202397/1000, -0.517599279769644/1000, 1];

tForm1 = affine3d(tForm_right_middle);
ptCloudRight = transform(ptCloudRight,tForm1);
tForm2 = affine3d(tForm_left_middle);
ptCloudLeft = transform(ptCloudLeft,tForm2);

mergeSize = 0.005;
ptCloudMiddleRight = pcmerge(ptCloudRight, ptCloudMiddle, mergeSize);
ptCloudLeftMiddle = pcmerge(ptCloudLeft, ptCloudMiddle, mergeSize);
ptCloudScene = pcmerge(ptCloudMiddleRight, ptCloudLeft, mergeSize);

% show image & world scene
figure
% subplot(3,2,1)
% imshow(ptCloudLeft.Color)
% title('First input image')
% drawnow
subplot(2,2,1)
imshow(ptCloudMiddle.Color)
title('First input image')
drawnow
subplot(2,2,3)
imshow(ptCloudRight.Color)
title('Second input image')
drawnow
subplot(2,2,[2,4])
pcshow(ptCloudMiddleRight, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down')
title('Initial world scene')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
drawnow

%% ~~~~~~~~~~ICP-Middle-Right~~~~~~~~~~~~(works well!!!)

%cut redundant points to make two pointCloud more similar
ptCloudMiddle_max_x = max(max(ptCloudMiddle.Location(:,:,1)));
ptCloudMiddle_min_x = min(min(ptCloudMiddle.Location(:,:,1)));
ptCloudRight_max_x = max(max(ptCloudRight.Location(:,:,1)));
ptCloudRight_min_x = min(min(ptCloudRight.Location(:,:,1)));
cut_max_x = min(ptCloudMiddle_max_x, ptCloudRight_max_x);
cut_min_x = max(ptCloudMiddle_min_x, ptCloudRight_min_x);

ptCloudRight_copy = ptCloudRight;
loc = ptCloudRight_copy.Location;
for i = 1 : size(loc,1)
    for j = 1 : size(loc,2)
        if loc(i,j,1) > cut_max_x || loc(i,j,1) < cut_min_x
            loc(i,j,1) = NaN;
            loc(i,j,2) = NaN;
            loc(i,j,3) = NaN;
        end
    end
end
ptCloudRight_copy = pointCloud(loc, 'Color', ptCloudRight_copy.Color);

ptCloudMiddle_copy = ptCloudMiddle;
loc = ptCloudMiddle_copy.Location;
for i = 1 : size(loc,1)
    for j = 1 : size(loc,2)
        if loc(i,j,1) > cut_max_x || loc(i,j,1) < cut_min_x
            loc(i,j,1) = NaN;
            loc(i,j,2) = NaN;
            loc(i,j,3) = NaN;
        end
    end
end
ptCloudMiddle_copy = pointCloud(loc, 'Color', ptCloudMiddle_copy.Color);

% ICP
gridSize = 0.05;
fixed = pcdownsample(ptCloudMiddle_copy, 'gridAverage', gridSize);
moving = pcdownsample(ptCloudRight_copy, 'gridAverage', gridSize);
tform = pcregrigid(moving, fixed, 'Metric','pointToPlane','Extrapolate', true);
ptCloudRight = pctransform(ptCloudRight,tform);

mergeSize = 0.005;
ptCloudMiddleRight = pcmerge(ptCloudRight, ptCloudMiddle, mergeSize);
% pcCloudScene = pcmerge(ptCloudMiddleRight, ptCloudLeft, mergeSize);
figure
subplot(2,2,1)
imshow(ptCloudMiddle.Color)
title('First input image')
drawnow
subplot(2,2,3)
imshow(ptCloudRight.Color)
title('Second input image')
drawnow
subplot(2,2,[2,4])
pcshow(ptCloudMiddleRight, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down')
title('Initial world scene')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')

% %% ~~~~~~~~~~ICP-Left-Middle~~~~~~~~~~~~(doesn't work well)
% 
% %cut redundant points to make two pointCloud more similar
% ptCloudMiddle_max_x = max(max(ptCloudMiddle.Location(:,:,1)));
% ptCloudMiddle_min_x = min(min(ptCloudMiddle.Location(:,:,1)));
% ptCloudLeft_max_x = max(max(ptCloudLeft.Location(:,:,1)));
% ptCloudLeft_min_x = min(min(ptCloudLeft.Location(:,:,1)));
% cut_max_x = min(ptCloudMiddle_max_x, ptCloudLeft_max_x);
% cut_min_x = max(ptCloudMiddle_min_x, ptCloudLeft_min_x);
% 
% ptCloudLeft_copy = ptCloudLeft;
% loc = ptCloudLeft_copy.Location;
% for i = 1 : size(loc,1)
%     for j = 1 : size(loc,2)
%         if loc(i,j,1) > cut_max_x || loc(i,j,1) < cut_min_x
%             loc(i,j,1) = NaN;
%             loc(i,j,2) = NaN;
%             loc(i,j,3) = NaN;
%         end
%     end
% end
% ptCloudLeft_copy = pointCloud(loc, 'Color', ptCloudLeft_copy.Color);
% 
% ptCloudMiddle_copy = ptCloudMiddle;
% loc = ptCloudMiddle_copy.Location;
% for i = 1 : size(loc,1)
%     for j = 1 : size(loc,2)
%         if loc(i,j,1) > cut_max_x || loc(i,j,1) < cut_min_x
%             loc(i,j,1) = NaN;
%             loc(i,j,2) = NaN;
%             loc(i,j,3) = NaN;
%         end
%     end
% end
% ptCloudMiddle_copy = pointCloud(loc, 'Color', ptCloudMiddle_copy.Color);
% 
% % ICP
% gridSize = 0.1;
% fixed = pcdownsample(ptCloudMiddle_copy, 'gridAverage', gridSize);
% moving = pcdownsample(ptCloudLeft_copy, 'gridAverage', gridSize);
% tform = pcregrigid(moving, fixed, 'Metric','pointToPlane','Extrapolate', true);
% ptCloudLeft = pctransform(ptCloudLeft,tform);
% 
% mergeSize = 0.005;
% ptCloudLeftMiddle = pcmerge(ptCloudLeft, ptCloudMiddle, mergeSize);
% figure
% pcshow(ptCloudLeftMiddle, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down')
% title('Initial world scene')
% xlabel('X (m)')
% ylabel('Y (m)')
% zlabel('Z (m)')

