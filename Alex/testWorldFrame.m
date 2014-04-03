clear; close all; clc;

initFrame;
initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
[n,v] = getGroundPlane(X,Y,Z,PARAMS);
[Oax,Xax,Yax,Oax3,Xax3,Yax3] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS);

k = 137;
scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
hold on
line([Oax(1);0],[Oax(2);0],[Oax(3);0],'color','red');
line([Xax(1);0],[Xax(2);0],[Xax(3);0],'color','red');
line([Yax(1);0],[Yax(2);0],[Yax(3);0],'color','red');
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal

hold on
AX = [Oax,Xax,Yax];
scatter3(AX(1,:),AX(2,:),AX(3,:),'*','red')

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
scatter3(Oax3(1),Oax3(2),Oax3(3),'o','red')
scatter3(Xax3(1),Xax3(2),Xax3(3),'o','red')
scatter3(Yax3(1),Yax3(2),Yax3(3),'o','red')