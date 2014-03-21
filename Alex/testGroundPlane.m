clear; close all; clc;

init;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
[n,v] = getGroundPlane(X,Y,Z,PARAMS);

k = 103;
scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
hold on

% Find 4 points on the plane.
pts = repmat(v',4,1) + 3000 * ...
      [cross(n, [ 1  0  0] ) ;
       cross(n, [-1  0  0] ) ;
       cross(n, [ 0  1  0] ) ;
       cross(n, [ 0 -1  0] )];
fill3(pts(:,1),pts(:,2),pts(:,3),'yellow');
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal