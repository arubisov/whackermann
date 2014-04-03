clear; close all; clc;

initFrame;
initParams;

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

[Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS);
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