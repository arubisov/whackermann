clear; close all; clc;

initFrame;
initParams;

% [X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
% [n,v] = getGroundPlane(X,Y,Z,PARAMS);
[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
    
% Use more than 1 iteration to stabilize the ground plane
X2 = X;
Y2 = Y;
Z2 = Z;
for i = 1:1, % Set to 20 when not using static frames
    if i == 5, PARAMS.GROUND_PLANE_DECIMATION_FACTOR = 23; end
    if i == 10, PARAMS.GROUND_PLANE_DECIMATION_FACTOR = 1; end % Improves results

    [n,v] = getGroundPlane(X2,Y2,Z2,PARAMS);
    [X2,Y2,Z2] = privateRotateAboutVFromTo(X2,Y2,Z2,n,v);
    if i ~= 1,
        n = privateRotateFromTo(old_n,n)*n;
%         v = old_v+v;
    end
    old_n = n;
%     old_v = v;
%     if i ~= 1,
%         v = old_v-v;
%     end
end
[~,v] = getGroundPlane(X,Y,Z,PARAMS);

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