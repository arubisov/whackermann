clear; close all; clc;

initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
[n,v] = getGroundPlane(X,Y,Z,PARAMS);
[Oax,Xax,Yax] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb);


% [Dx,Dy] = getDiskCentres(n,v,rgb,depth,Oax,Xax,Yax,PARAMS)
testMeasure(n,v,rgb,depth,Oax,Xax,Yax,PARAMS)

% [X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax);
% [Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,PARAMS);

% figure
% subplot(1,3,1)
% k = 137;
% scatter3(decimate(X,k),decimate(Y,k),decimate(Z,k),'.')
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
% % imshow(rgb)
% imshow(cat(3,fliplr(rgb(:,:,1)),fliplr(rgb(:,:,2)),fliplr(rgb(:,:,3))))