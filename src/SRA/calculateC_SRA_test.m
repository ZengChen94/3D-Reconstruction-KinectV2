%%calculate C_matrix
data1 = load('./SR4000-mat/test1_29MHz.mat');
data2 = load('./SR4000-mat/test1_30MHz.mat');
data3 = load('./SR4000-mat/test1_31MHz.mat');

f1 = 29*1000000;
f2 = 30*1000000;
f3 = 31*1000000;


C_matrix = zeros(6,6);
v1 = zeros(1,size(data1.ptCloudData,1));
v2 = zeros(1,size(data1.ptCloudData,1));
v3 = zeros(1,size(data1.ptCloudData,1));
v4 = zeros(1,size(data1.ptCloudData,1));
v5 = zeros(1,size(data1.ptCloudData,1));
v6 = zeros(1,size(data1.ptCloudData,1));

i = 118;
j = 71;
c = 3e8;


for num = 1:size(data1.ptCloudData,1)
    img1 = squeeze(data1.ptCloudData(num,:,:,:));
    img2 = squeeze(data2.ptCloudData(num,:,:,:));
    img3 = squeeze(data3.ptCloudData(num,:,:,:));
    v1(num) = img1(i,j,4) * cos(2 * pi * img1(i,j,3) * 2 * f1 / c);
    v2(num) = img2(i,j,4) * cos(2 * pi * img2(i,j,3) * 2 * f2 / c);
    v3(num) = img3(i,j,4) * cos(2 * pi * img3(i,j,3) * 2 * f3 / c);
    v4(num) = img1(i,j,4) * sin(2 * pi * img1(i,j,3) * 2 * f1 / c);
    v5(num) = img2(i,j,4) * sin(2 * pi * img2(i,j,3) * 2 * f2 / c);
    v6(num) = img3(i,j,4) * sin(2 * pi * img3(i,j,3) * 2 * f3 / c);
end
C_matrix(1,1) = var(v1, 1);
C_matrix(2,2) = var(v2, 1);
C_matrix(3,3) = var(v3, 1);
C_matrix(4,4) = var(v4, 1);
C_matrix(5,5) = var(v5, 1);
C_matrix(6,6) = var(v6, 1);

% C_matrix = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1];

%%calculate x
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

epson = 0.05;
distStart = 10;%cm
distEnd = 300;
noise_C = C_matrix;
c = 3e8;

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
v(1) = img1(i,j,4) * cos(2 * pi * img1(i,j,3) * 2 * f1 / c);
v(2) = img2(i,j,4) * cos(2 * pi * img2(i,j,3) * 2 * f2 / c);
v(3) = img3(i,j,4) * cos(2 * pi * img3(i,j,3) * 2 * f3 / c);
v(4) = img1(i,j,4) * sin(2 * pi * img1(i,j,3) * 2 * f1 / c);
v(5) = img2(i,j,4) * sin(2 * pi * img2(i,j,3) * 2 * f2 / c);
v(6) = img3(i,j,4) * sin(2 * pi * img3(i,j,3) * 2 * f3 / c);

epson_mul_v = epson*(abs(v(1))+abs(v(2))+abs(v(3))+abs(v(4))+abs(v(5))+abs(v(6))); 
a = Q * noise_C^(-1/2) * Matrix;
b = Q * noise_C^(-1/2) * v + epson_mul_v;
f = ones(distEnd-distStart+1, 1);
xstart = zeros(distEnd-distStart+1, 1);

ansLinprog = linprog(f,a,b,[],[],xstart,[]);
% ansLinprog = linprog(f,[],[],a,b,xstart,[]); %result distribution will be reverse
