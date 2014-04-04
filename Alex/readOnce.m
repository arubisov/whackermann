clear; close all; clc;

initFrame;
initParams;

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
    
% Use more than 1 iteration to stabilize the ground plane
X2 = X;
Y2 = Y;
Z2 = Z;
for i = 1:20, % Set to 20 when not using static frames
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
[X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,PARAMS);

[depth_m,depth_n] = size(depth);

% For testing
hold on
figure(2)
k = 137;
scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal

h = figure('units','normalized','outerposition',[0 0 1 1]);
imshow(rgb)
[x,y] = ginput(Inf);
md = round(y);
nd = round(x);

[Dx,Dy] = privateRGBToWorld(md,nd,n,v,depth_m,depth_n,Oax,Xax,Yax,PARAMS);

% For testing
figure(2)
hold on
scatter(Dx,Dy,'red','*')

dlmwrite('targets_2.txt',[Dx Dy])
    

close(h)