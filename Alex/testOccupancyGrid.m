clear; close all; clc;

initFrame;
initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
[n,v] = getGroundPlane(X,Y,Z,PARAMS);
[Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS);
[X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,PARAMS);
[Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,PARAMS);

figure
subplot(2,2,1)
k = 137;
scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal

% subplot(2,2,4)
% imagesc(gr_x,gr_y,Occ./Known)
% set(gca,'YDir','normal')
% axis image
% xlabel('X')
% ylabel('Y')
% title('Occupancy Certainity Grid')
% colorbar;

% Grid = single(Occ)./single(Known);
% Grid(isnan(Grid)) = -1;
subplot(2,2,2)
imshow(rgb)

subplot(2,2,3)
imagesc(gr_x,gr_y,Occ)
set(gca,'YDir','normal')
axis image
xlabel('X')
ylabel('Y')
title('Number of ''Occupied'' Readings')
colorbar;

subplot(2,2,4)
imagesc(gr_x,gr_y,Known)
set(gca,'YDir','normal')
axis image
xlabel('X')
ylabel('Y')
title('Number of Samples')
colorbar;