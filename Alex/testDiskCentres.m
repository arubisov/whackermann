clear; close all; clc;

initFrame;
initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
[n,v] = getGroundPlane(X,Y,Z,PARAMS);
[Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb);
% [X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax);

% [Dx,Dy] = getDiskCentres(n,v,rgb,depth,Oax,Xax,Yax,PARAMS)
privateTestMeasure(n,v,rgb,depth,Oax,Xax,Yax,PARAMS);

% [X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax);
% [Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,PARAMS);

% figure
% subplot(1,3,1)
% k = 137;
% scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% axis equal
% 
% Grid = single(Occ)./single(Known);
% Grid(isnan(Grid)) = -1;
% subplot(1,3,2)
% imagesc(gr_x,gr_y,Grid)
% set(gca,'YDir','normal')
% axis image
% xlabel('X')
% ylabel('Y')
% 
% subplot(1,3,3)
% imshow(rgb)