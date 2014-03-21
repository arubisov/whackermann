clear; close all; clc;

initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);

k = 137;
h = figure;
subplot(1,2,1)
scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal

[n,v] = getGroundPlane(X,Y,Z,PARAMS);
[Oax,Xax,Yax] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb);
[X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax);
 
figure(h)
subplot(1,2,2)
scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal