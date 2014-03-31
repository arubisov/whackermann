clear; close all; clc;

initFrame;
initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
[n,v] = getGroundPlane(X,Y,Z,PARAMS);
[Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS);
[X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,PARAMS);
[Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,PARAMS);

[Occ,Known,gr_x,gr_y] = promptForOccWall(n,v,Oax,Xax,Yax,rgb,gr_x,gr_y,Occ,Known,PARAMS);

[BinOcc] = getBinaryOccupancyGrid(Occ,Known);

figure
subplot(2,2,1)
imagesc(gr_x,gr_y,(BinOcc > 0.9999) - (Known == 0))
set(gca,'YDir','normal')
axis image
xlabel('X')
ylabel('Y')
title('p = 0.9999 Occupancy Grid')

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

figure(2)
subplot(2,2,1)
imagesc(gr_x,gr_y,BinOcc)
set(gca,'YDir','normal')
axis image
xlabel('X')
ylabel('Y')
title('Occupancy Probability Grid')

subplot(2,2,2)
imagesc(gr_x,gr_y,BinOcc > 0.99)
set(gca,'YDir','normal')
axis image
xlabel('X')
ylabel('Y')
title('p = 0.99 Occupancy Grid')

subplot(2,2,3)
imagesc(gr_x,gr_y,BinOcc > 0.999)
set(gca,'YDir','normal')
axis image
xlabel('X')
ylabel('Y')
title('p = 0.999 Occupancy Grid')

subplot(2,2,4)
imagesc(gr_x,gr_y,BinOcc > 0.9999)
set(gca,'YDir','normal')
axis image
xlabel('X')
ylabel('Y')
title('p = 0.9999 Occupancy Grid')
colormap gray
