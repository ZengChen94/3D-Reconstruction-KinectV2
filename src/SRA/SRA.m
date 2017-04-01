data1 = load('./SR4000-mat/test1_29MHz.mat');
data2 = load('./SR4000-mat/test1_30MHz.mat');
data3 = load('./SR4000-mat/test1_31MHz.mat');
f1 = 29*1000000;
f2 = 30*1000000;
f3 = 31*1000000;
img1 = squeeze(data1.ptCloudData(1,:,:,:));
img2 = squeeze(data2.ptCloudData(1,:,:,:));
img3 = squeeze(data3.ptCloudData(1,:,:,:));

Q = zeros(64, 6);
i = 1;
for a = [-1,1]
    for b = [-1,1]
        for c = [-1,1]
            for d = [-1,1]
                for e = [-1,1]
                    for f = [-1,1]
                        Q(i, :) = [a,b,c,d,e,f];
                        i = i+1;
                    end
                end
            end
        end
    end
end

c = 3e8;
epson = 0.05;
noise_C = zeros(6, 6); %How to determine noice_C

distStart = 20;%cm
distEnd = 450;

for i = 1:size(img1,1)
    for j = 1:size(im1,2)
        Matrix = zeros(3*2, distEnd-distStart+1);
        for k = distStart : distEnd
            Matrix(1, k-distStart+1) = cos(2 * pi * k/100 * 2 * f1 / c);
            Matrix(2, k-distStart+1) = cos(2 * pi * k/100 * 2 * f2 / c);
            Matrix(3, k-distStart+1) = cos(2 * pi * k/100 * 2 * f3 / c);
            Matrix(4, k-distStart+1) = sin(2 * pi * k/100 * 2 * f1 / c);
            Matrix(5, k-distStart+1) = sin(2 * pi * k/100 * 2 * f2 / c);
            Matrix(6, k-distStart+1) = sin(2 * pi * k/100 * 2 * f3 / c);
        end
        
        v = zeros(3*2, 1);
        v(1) = img1(i,j,4) * cos(2 * pi * (img1(i,j,1)^2+img1(i,j,2)^2+img1(i,j,3)^2)^(1/2) * 2 * f1 / c);
        v(2) = img2(i,j,4) * cos(2 * pi * (img2(i,j,1)^2+img2(i,j,2)^2+img2(i,j,3)^2)^(1/2) * 2 * f2 / c);
        v(3) = img3(i,j,4) * cos(2 * pi * (img3(i,j,1)^2+img3(i,j,2)^2+img3(i,j,3)^2)^(1/2) * 2 * f3 / c);
        v(4) = img1(i,j,4) * sin(2 * pi * (img1(i,j,1)^2+img1(i,j,2)^2+img1(i,j,3)^2)^(1/2) * 2 * f1 / c);
        v(5) = img2(i,j,4) * sin(2 * pi * (img2(i,j,1)^2+img2(i,j,2)^2+img2(i,j,3)^2)^(1/2) * 2 * f2 / c);
        v(6) = img3(i,j,4) * sin(2 * pi * (img3(i,j,1)^2+img3(i,j,2)^2+img3(i,j,3)^2)^(1/2) * 2 * f3 / c);
        
        epson_mul_v = epson*(abs(v(1))+abs(v(2))+abs(v(3))+abs(v(4))+abs(v(5))+abs(v(6))); 
        a = Q * noise_C^(-1/2) * Matrix;
        b = Q * noise_C^(-1/2) * v + epson_mul_v;
        f = ones(distEnd-distStart+1, 1);
        x = zeros(distEnd-distStart+1, 1);
        ansLinprog = linprog(f,a,b,[],[],x,[]);
    end
end
