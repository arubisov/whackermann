clear; close all; clc;

initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
[n,v] = getGroundPlane(X,Y,Z,PARAMS);
[Oax,Xax,Yax] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb);

k = 137;
scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal

hold on
AX = [Oax,Xax,Yax];
scatter3(AX(1,:),AX(2,:),AX(3,:),'*','red')