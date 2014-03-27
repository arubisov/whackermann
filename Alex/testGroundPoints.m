clear; close all; clc;

initFrame;
initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
[n,v] = getGroundPlane(X,Y,Z,PARAMS);
[Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS);
[X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,PARAMS);
[GInd,OInd] = getGroundPoints(Z,PARAMS);

gnd_s = ImInd(GInd);

gnd = false(size(depth));
gnd(gnd_s) = true;
XG = X(~GInd & ~OInd);
YG = Y(~GInd & ~OInd);
ZG = Z(~GInd & ~OInd);

XO = X(OInd);
YO = Y(OInd);
ZO = Z(OInd);

figure(1)
k = 13;
scatter3(downsample(XG,k),downsample(YG,k),downsample(ZG,k),'.')
hold on
k = 137;
scatter3(downsample(XO,k),downsample(YO,k),downsample(ZO,k),'.','red')
% scatter(downsample(Y,k),downsample(Z,k),'.')
axis equal
% Find 4 points on the plane.
pts = 0.5 * ...
      [cross(n, [ 1  0  0] ) ;
       cross(n, [-1  0  0] ) ;
       cross(n, [ 0  1  0] ) ;
       cross(n, [ 0 -1  0] )];
fill3(pts(:,1),pts(:,2),pts(:,3),'red');
xlabel('X')
ylabel('Y')
zlabel('Z')

figure(2)
subplot(1,3,1);
imshow(rgb);

subplot(1,3,2);
imagesc(depth)
axis image off

depth(gnd) = uint16(0);
subplot(1,3,3);
imagesc(depth)
axis image off