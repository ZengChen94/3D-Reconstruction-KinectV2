load('./left/colorDevice_left.mat')
load('./left/depthDevice_left.mat')

colorImage = imread('./left/KinectScreenshot-Color-03-08-03.png');

depthImage = imread('left-Depth-0000000009.png');
% depthImage = imread('D:\study\courseware\graduation_design\projects\data-20170307-depth2ptCloud-3cameras\middle\xef\Depth-0000000050.png');

ptCloud_leftInterference = pcfromkinect(depthDevice_left, depthImage, colorImage);

pcshow(ptCloud_leftInterference, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down')
title('Initial world scene')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
drawnow
save('./ptCloud_leftInterference', 'ptCloud_leftInterference');

% release(colorDevice);
% release(depthDevice);