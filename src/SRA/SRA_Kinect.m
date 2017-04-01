% fip = fopen('./SensorData/geometric_15_real.bin','rb');
% [real, count] = fread(fip, inf, 'float');
% fclose(fip);
% real_15 = reshape(real,424,512);
% 
% fip = fopen('./SensorData/geometric_80_real.bin','rb');
% [real, count] = fread(fip, inf, 'float');
% fclose(fip);
% real_80 = reshape(real,424,512);
% 
% fip = fopen('./SensorData/geometric_120_real.bin','rb');
% [real, count] = fread(fip, inf, 'float');
% fclose(fip);
% real_120 = reshape(real,424,512);
% 
% fip = fopen('./SensorData/geometric_15_imag.bin','rb');
% [imag, count] = fread(fip, inf, 'float');
% fclose(fip);
% imag_15 = reshape(imag,424,512);
% 
% fip = fopen('./SensorData/geometric_80_imag.bin','rb');
% [imag, count] = fread(fip, inf, 'float');
% fclose(fip);
% imag_80 = reshape(imag,424,512);
% 
% fip = fopen('./SensorData/geometric_120_imag.bin','rb');
% [imag, count] = fread(fip, inf, 'float');
% fclose(fip);
% imag_120 = reshape(imag,424,512);
% 
% fip = fopen('./SensorData/R2Z.bin','rb');
% [R2Z, count] = fread(fip, inf, 'float');
% fclose(fip);
% R2Z = reshape(R2Z,424,512);
% 
% f1 = 15e6;
% f2 = 80e6;
% f3 = 120e6;
% % fip = fopen('./SensorData/R2Z.bin','rb');
% % [R2Z, count] = fread(fip, inf, 'float');%ubit16
% % fclose(fip);
% % R2Z = reshape(R2Z, 424, 512);
% 
% Q = zeros(64, 6);
% i = 1;
% for a = [-1,1]
%     for b = [-1,1]
%         for c = [-1,1]
%             for d = [-1,1]
%                 for e = [-1,1]
%                     for f = [-1,1]
%                         Q(i, :) = [a,b,c,d,e,f];
%                         i = i+1;
%                     end
%                 end
%             end
%         end
%     end
% end
% % C_matrix = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1];
% C_matrix = 1e4 * [2.6460, 0, 0, 0, 0, 0; 0, 2.5604, 0, 0, 0, 0; 0, 0, 2.4522, 0, 0, 0; 0, 0, 0, 0.0032, 0, 0; 0, 0, 0, 0, 0.0897, 0; 0, 0, 0, 0, 0, 0.1992];
% epson = 0.05;
% 
% threshold_max = 0.01;
% 
% distStart = 20;%cm
% distEnd = 450;
% noise_C = C_matrix;
% c = 3e8;
% 
% % i = 50; j = 50;
% depth_map = zeros(424, 512);
% 
% Matrix = zeros(3*2, distEnd-distStart+1);
% for k = distStart : distEnd
%     Matrix(1, k-distStart+1) = cos(2 * pi * k/100 * 2 * f1 / c);
%     Matrix(2, k-distStart+1) = cos(2 * pi * k/100 * 2 * f2 / c);
%     Matrix(3, k-distStart+1) = cos(2 * pi * k/100 * 2 * f3 / c);
%     Matrix(4, k-distStart+1) = sin(2 * pi * k/100 * 2 * f1 / c);
%     Matrix(5, k-distStart+1) = sin(2 * pi * k/100 * 2 * f2 / c);
%     Matrix(6, k-distStart+1) = sin(2 * pi * k/100 * 2 * f3 / c);
% end
% 
% for i = 1:424
%     for j = 1:512
%         v = zeros(3*2, 1);
%         v(1) = real_15(i,j);
%         v(2) = real_80(i,j);
%         v(3) = real_120(i,j);
%         v(4) = imag_15(i,j);
%         v(5) = imag_80(i,j);
%         v(6) = imag_120(i,j);
% 
%         epson_mul_v = epson*(abs(v(1))+abs(v(2))+abs(v(3))+abs(v(4))+abs(v(5))+abs(v(6))); 
%         a = Q * noise_C^(-1/2) * Matrix;
%         b = Q * noise_C^(-1/2) * v + epson_mul_v;
%         f = ones(distEnd-distStart+1, 1);
%         xstart = zeros(distEnd-distStart+1, 1);
% 
%         ansLinprog = linprog(f,a,b,[],[],xstart,[]);
%         
%         maxDepth = max(ansLinprog);
%         for k = 1:size(ansLinprog,1)
%             if ansLinprog(k) > maxDepth * threshold_max
%                 break;
%             end
%         end
%         depth_map(i,j) =  (k + distStart - 1) / R2Z(i,j) / 100;
%         [i,j]
%     end
% end
% save('depth_map', 'depth_map');



figure
load('./colorDevice_right.mat')
load('./depthDevice_right.mat')
load('./depth_map.mat')
fip = fopen('./SensorData/R2Z.bin','rb');
[R2Z, count] = fread(fip, inf, 'float');
fclose(fip);
R2Z = reshape(R2Z,424,512);
depth_map = depth_map .* R2Z;
depth_map = uint16(depth_map*1000);
depth_map = flipud(depth_map);
depth_ptClout = pcfromkinect(depthDevice_right, depth_map);
pcshow(depth_ptClout, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down')
title('Initial world scene')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
drawnow