load('ptCloud-middle.mat')
loc = ptCloud.Location;
for i = 1:size(loc,1)
    for j = 1:size(loc,2)
        if loc(i,j,3) > 2
            loc(i,j,:) = loc(1063,1761,:);
        end
    end
end
ptCloud = pointCloud(loc, 'Color', ptCloud.Color);
pcshow(ptCloud, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down')
title('Initial world scene')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
drawnow
save('./ptCloud-middle', 'ptCloud');