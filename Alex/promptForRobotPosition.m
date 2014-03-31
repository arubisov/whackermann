function [x,y,Im,In] = promptForRobotPosition(rgb,n,v,Oax,Xax,Yax,PARAMS)

[Im,In] = promptForDiskCentre(rgb);

[size_m,size_n] = size(rgb(:,:,1));

[x,y] = privateRGBToWorld(Im,In,n,v,size_m,size_n,Oax,Xax,Yax,PARAMS);