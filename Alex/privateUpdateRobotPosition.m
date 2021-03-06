function [new_m,new_n,x,y,th,update] = privateUpdateRobotPosition(old_m,old_n,old_x,old_y,old_th,n,v,Oax,Xax,Yax,rgb,PARAMS)

[size_m,size_n] = size(rgb(:,:,1));

BW = false(size_m,size_n);
BW(old_m-PARAMS.ROBOT_HEIGHT_PX,old_n) = true;
BW = bwdist(BW) < PARAMS.SEARCH_DIAMETER;

R = rgb(:,:,1);
G = rgb(:,:,2);
B = rgb(:,:,3);

red_t = uint8(255*graythresh(R));
gr_t = uint8(255*graythresh(G));
bl_t = uint8(255*graythresh(B));
bl_t = 120;

% red_t = 135;
R_bin = R > red_t;
G_bin = G > gr_t;
B_bin = B > bl_t;


% RR = imerode( R_bin & ~G_bin & ~B_bin & BW, strel('diamond',1));
% RB = imerode(~R_bin & ~G_bin &  B_bin & BW, strel('diamond',1));

if old_y < 1, sz = 20;
elseif old_y < 2, sz = 10;
elseif old_y < 3, sz = 8;
else sz = 6;
end

RR = bwareaopen( R_bin & ~G_bin & ~B_bin & BW, sz);
RB = bwareaopen(~R_bin & ~G_bin &  B_bin & BW, sz);

% RR =  R_bin & ~G_bin & ~B_bin & BW;
% RB = ~R_bin & ~G_bin &  B_bin & BW;

Rblobs = regionprops(RR, 'Centroid');
Bblobs = regionprops(RB, 'Centroid');

Rn = length(Rblobs);
Rc = uint16(zeros(Rn,2));
for i = 1:Rn,
    Rc(i,:) = Rblobs(i).Centroid;
end
Bn = length(Bblobs);
Bc = uint16(zeros(Bn,2));
for i = 1:Bn,
    Bc(i,:) = Bblobs(i).Centroid;
end

if Bn == 0 || Rn == 0,
    warning('Red or blue balls not found, position not updated.')
    x = old_x;
    y = old_y;
    th = old_th;
    new_m = old_m;
    new_n = old_n;
    update = false;
    return
end

min_dist = Inf;
for pR = 1:Rn
    for pB = 1:Bn
        d = (Bc(pB,1)-Rc(pR,1))^2+(Bc(pB,2)-Rc(pR,2))^2;
        if d < min_dist
            min_Rc = Rc(pR,:);
            min_Bc = Bc(pB,:);
            min_dist = d;
        end
    end
end
new_m = double(min_Rc(2));
new_n = double(min_Rc(1));

bl_m = double(min_Bc(2));
bl_n = double(min_Bc(1));
% new_m = double(round((min_Rc(2) + min_Bc(2)) / 2) + PARAMS.ROBOT_HEIGHT_PX); % Correction factor since we are looking at the top of the robot...
% new_n = double(round((min_Rc(1) + min_Bc(1)) / 2));

[x,y] = privateRGBToWorld(new_m,new_n,n,v,size_m,size_n,Oax,Xax,Yax,PARAMS);
[bl_x,bl_y] = privateRGBToWorld(bl_m,bl_n,n,v,size_m,size_n,Oax,Xax,Yax,PARAMS);

% th = atan2( (y - old_y), (x - old_x) );

th = atan2( bl_y - y, bl_x - x );
update = true;
% 
% imagesc(RR - RB)
% imagesc( (R_bin & ~G_bin & ~B_bin) - (~R_bin & ~G_bin &  B_bin) );