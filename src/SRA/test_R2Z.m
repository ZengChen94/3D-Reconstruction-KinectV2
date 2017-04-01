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

f1 = 15e6;
f2 = 80e6;
f3 = 120e6;

fip = fopen('./SensorData/R2Z.bin','rb');
[R2Z, count] = fread(fip, inf, 'float');
fclose(fip);
R2Z = reshape(R2Z,424,512);