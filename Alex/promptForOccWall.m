function [Occ,Known,gr_x,gr_y] = promptForOccWall(n,v,Oax,Xax,Yax,rgb,gr_x1,gr_y1,Occ1,Known1,PARAMS)

% Prompt for line
h = figure('units','normalized','outerposition',[0 0 1 1]);
imshow(rgb)
[x,y] = ginput(1);
if isempty(x), return; end
m1 = round(y);
n1 = round(x);
[x,y] = ginput(1);
if isempty(x), return; end
m2 = round(y);
n2 = round(x);
close(h);

MN = getline(m1,n1,m2,n2);
M = MN(:,1);
N = MN(:,2);

% Transform RGB to world

[size_m,size_n] = size(rgb(:,:,1));
[X,Y] = privateRGBToWorld(M,N,n,v,size_m,size_n,Oax,Xax,Yax,PARAMS);

%% Readjust Occupancy Grid

XY_RESOLUTION = PARAMS.XY_RESOLUTION;

dom = [floor(min(X)/XY_RESOLUTION) ceil(max(X)/XY_RESOLUTION)] * XY_RESOLUTION;
rng = [floor(min(Y)/XY_RESOLUTION) ceil(max(Y)/XY_RESOLUTION)] * XY_RESOLUTION;

gr_x2 = dom(1):XY_RESOLUTION:dom(2);
gr_y2 = rng(1):XY_RESOLUTION:rng(2);

Occ2 = uint16(zeros(length(gr_y2),length(gr_x2)));
Known2 = Occ2;

x = floor( (X - dom(1)) / XY_RESOLUTION ) + 1;
y = floor( (Y - rng(1)) / XY_RESOLUTION ) + 1;
s = sub2ind(size(Occ2),y,x);

Occ2(s) = 100;
Known2(s) = 100;

% figure(3); imagesc(gr_x1,gr_y1,Occ1)
% figure(4); imagesc(gr_x2,gr_y2,Occ2)

[Occ,Known,gr_x,gr_y] = sumOcc(Occ1,Known1,gr_x1,gr_y1,Occ2,Known2,gr_x2,gr_y2,PARAMS);


end



% Private line-drawing functions

function pts = getline(x1,y1,x2,y2)
pts =  [x1 y1                        ;
        getlineprivate(x1,y1,x2,y2) ];
end

function pts = getlineprivate(x1,y1,x2,y2)
    mid_x = round(mean([x1 x2]));
    mid_y = round(mean([y1 y2]));

    if (mid_x == x1 && mid_y == y1) || (mid_x == x2 && mid_y == y2),
        pts = [];
    else
        pts = [mid_x mid_y];
        pts = [pts                                ;
               getlineprivate(x1,y1,mid_x,mid_y)  ;
               getlineprivate(mid_x,mid_y,x2,y2) ];
    end
end