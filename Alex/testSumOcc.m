clear; close all; clc;

initFrame;
initParams;

Occ1 = uint16(eye(3));
Known1 = Occ1;
Occ2 = uint16(ones(1,40));
Known2 = Occ2;

gr_x1 = 1:PARAMS.XY_RESOLUTION:1.10;
gr_y1 = 1:PARAMS.XY_RESOLUTION:1.10;
gr_x2 = 0:PARAMS.XY_RESOLUTION:1.95;
gr_y2 = 0;

[newOcc,newKnown,new_gr_x,new_gr_y] = sumOcc(Occ1,Known1,gr_x1,gr_y1,Occ2,Known2,gr_x2,gr_y2,PARAMS);



[BinOcc] = getBinaryOccupancyGrid(newOcc,newKnown);