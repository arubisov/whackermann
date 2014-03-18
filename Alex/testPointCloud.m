clear; close all; clc;

initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);

k = 137;
figure;
scatter3(decimate(X,k),decimate(Y,k),decimate(Z,k),'.')
% scatter(decimate(Y,k),decimate(Z,k),'.')
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal