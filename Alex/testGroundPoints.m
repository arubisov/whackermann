clear; close all; clc;

initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
[n,v] = getGroundPlane(X,Y,Z,PARAMS);
GInd = getGroundPoints(X,Y,Z,n,v);

gnd_s = ImInd(GInd);

gnd = false(size(depth));
gnd(gnd_s) = true;
X = X(~GInd);
Y = Y(~GInd);
Z = Z(~GInd);

figure(1)
k = 137;
scatter3(decimate(X,k),decimate(Y,k),decimate(Z,k),'.')
% scatter(decimate(Y,k),decimate(Z,k),'.')
hold on
axis equal
% Find 4 points on the plane.
pts = repmat(v',4,1) + 1000 * ...
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