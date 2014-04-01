function [x,y,th,Im,In] = promptForRobotPosition(rgb,n,v,Oax,Xax,Yax,PARAMS)

imshow(rgb)
title('Get Robot Position')
[x,y] = ginput(1);
if isempty(x), return; end
Im = round(y);
In = round(x);

title('Get Robot Heading')
[x,y] = ginput(1);
if isempty(x), return; end
Imth = round(y);
Inth = round(x);

[size_m,size_n] = size(rgb(:,:,1));

[x,y] = privateRGBToWorld(Im,In,n,v,size_m,size_n,Oax,Xax,Yax,PARAMS);

[xth,yth] = privateRGBToWorld(Imth,Inth,n,v,size_m,size_n,Oax,Xax,Yax,PARAMS);

th = atan2(yth - y, xth - x);