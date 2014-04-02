function [Occ,Known,gr_x,gr_y] = drawOccWall(n,v,Oax,Xax,Yax,rgb,gr_x,gr_y,Occ,Known,PARAMS,draw_flag,pt1,pt2)

m1 = round(pt1(2));
n1 = round(pt1(1));
m2 = round(pt2(2));
n2 = round(pt2(1));

MN = getline(m1,n1,m2,n2);
M = MN(:,1);
N = MN(:,2);

% Transform RGB to world

[size_m,size_n] = size(rgb(:,:,1));
% X = zeros(length(MN),1);
% Y = X;
% for i = 1:length(X),
%     [X(i),Y(i)] = privateRGBToWorld(M(i),N(i),n,v,size_m,size_n,Oax,Xax,Yax,PARAMS);
% end
[X,Y] = privateRGBToWorld(M,N,n,v,size_m,size_n,Oax,Xax,Yax,PARAMS);

%% Readjust Occupancy Grid
XY_RESOLUTION = PARAMS.XY_RESOLUTION;
dom = [[floor(min(X)/XY_RESOLUTION) ceil(max(X)/XY_RESOLUTION)] * XY_RESOLUTION  ;
        min(gr_x)                   max(gr_x)                                   ];
rng = [[floor(min(Y)/XY_RESOLUTION) ceil(max(Y)/XY_RESOLUTION)] * XY_RESOLUTION  ;
        min(gr_y)                   max(gr_y)                                   ];

new_dom = [min(dom(:,1)) max(dom(:,2))];
new_rng = [min(rng(:,1)) max(rng(:,2))];

gr_x = new_dom(1):XY_RESOLUTION:new_dom(2);
gr_y = new_rng(1):XY_RESOLUTION:new_rng(2);

newOcc = uint16(zeros(length(gr_y)+1,length(gr_x)+1));
newKnown = newOcc;

[o_m,o_n] = size(Occ);
Occ_x = (dom(2,1) - min(gr_x))/XY_RESOLUTION + 1;
Occ_y = (rng(2,1) - min(gr_y))/XY_RESOLUTION + 1;

newOcc( Occ_x:(o_m+Occ_x-1), Occ_y:(o_n+Occ_y-1) ) = Occ;
newKnown( Occ_x:(o_m+Occ_x-1), Occ_y:(o_n+Occ_y-1) ) = Known;

%% Insert

x = floor( (X - new_dom(1)) / XY_RESOLUTION ) + 1;
y = floor( (Y - new_rng(1)) / XY_RESOLUTION ) + 1;
s = sub2ind(size(newOcc),y,x);

if draw_flag == 1
    newOcc(s) = 100;
else
    newOcc(s) = 0;
end

newKnown(s) = 100;

Occ = newOcc;
Known = newKnown;

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