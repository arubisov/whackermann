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
h1 = figure;
k = 137;
scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal

h2 = figure('units','normalized','outerposition',[0 0 1 1]);
imshow(rgb)
hold on;
M_s = [];
N_s = [];
while true,
    [x,y] = ginput(1);
    if isempty(x), break; end
    md = round(y);
    nd = round(x);
    M_s = [M_s; md]; %#ok<AGROW>
    N_s = [N_s; nd]; %#ok<AGROW>
    scatter(nd,md,'red','*')
end

[Dx,Dy] = privateRGBToWorld(M_s,N_s,n,v,depth_m,depth_n,Oax,Xax,Yax,PARAMS);

% For testing
figure(h1)
hold on
scatter(Dx,Dy,'red','*')

dlmwrite('targets_2.txt',[Dx Dy],'newline','pc')