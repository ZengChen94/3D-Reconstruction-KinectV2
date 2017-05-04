colorDevice = imaq.VideoDevice('kinect',1);
depthDevice = imaq.VideoDevice('kinect',2);
% step(colorDevice);
% step(depthDevice);
% colorImage = step(colorDevice);
% depthImage = step(depthDevice);
% 
% ptCloud = pcfromkinect(depthDevice, depthImage, colorImage);

% Initialize a player to visualize 3-D point cloud data. The axis is
% set appropriately to visualize the point cloud from Kinect.
% player = pcplayer(ptCloud.XLimits, ptCloud.YLimits, ptCloud.ZLimits,...
%   'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
% 
% xlabel(player.Axes, 'X (m)');
% ylabel(player.Axes, 'Y (m)');
% zlabel(player.Axes, 'Z (m)');

% Acquire and view Kinect point cloud data.

% while isOpen(player)
colorImage = step(colorDevice);
depthImage = step(depthDevice);

ptCloud = pcfromkinect(depthDevice, depthImage, colorImage);
% 
%     view(player, ptCloud);
save('./data-20170307-depth2ptCloud/ptCloud-left', 'ptCloud');
save('./data-20170307-depth2ptCloud/depthImage-left', 'depthImage');
% end

release(colorDevice);
release(depthDevice);