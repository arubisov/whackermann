clear; close all; clc;

initFrame;
initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);

k = 137;
figure;
scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
% scatter(downsample(Y,k),downsample(Z,k),'.')
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal