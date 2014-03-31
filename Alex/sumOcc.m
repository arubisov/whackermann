function [newOcc,newKnown,new_gr_x,new_gr_y] = sumOcc(Occ1,Known1,gr_x1,gr_y1,Occ2,Known2,gr_x2,gr_y2,PARAMS)

%% Readjust Occupancy Grid Bounds

XY_RESOLUTION = PARAMS.XY_RESOLUTION;

dom = [ min(gr_x1) max(gr_x1)  ;
        min(gr_x2) max(gr_x2) ];
rng = [ min(gr_y1) max(gr_y1);
        min(gr_y2) max(gr_y2)];

new_dom = [min(dom(:,1)) max(dom(:,2))];
new_rng = [min(rng(:,1)) max(rng(:,2))];

new_gr_x = new_dom(1):XY_RESOLUTION:new_dom(2);
new_gr_y = new_rng(1):XY_RESOLUTION:new_rng(2);

newOcc = uint16(zeros(length(new_gr_y)+1,length(new_gr_x)+1));
newKnown = newOcc;

%% Do the sum

Occ1_x = uint16((dom(1,1) - min(new_gr_x))/XY_RESOLUTION + 1);
Occ1_y = uint16((rng(1,1) - min(new_gr_y))/XY_RESOLUTION + 1);

[o1_m,o1_n] = size(Occ1);
newOcc( Occ1_x:(o1_m+Occ1_x-1), Occ1_y:(o1_n+Occ1_y-1) ) = Occ1;
newKnown( Occ1_x:(o1_m+Occ1_x-1), Occ1_y:(o1_n+Occ1_y-1) ) = Known1;

Occ2_x = uint16((dom(2,1) - min(new_gr_x))/XY_RESOLUTION + 1);
Occ2_y = uint16((rng(2,1) - min(new_gr_y))/XY_RESOLUTION + 1);

[o2_m,o2_n] = size(Occ2);
newOcc( Occ2_x:(o2_m+Occ2_x-1), Occ2_y:(o2_n+Occ2_y-1) ) = ...
newOcc( Occ2_x:(o2_m+Occ2_x-1), Occ2_y:(o2_n+Occ2_y-1) ) + Occ2;

newKnown( Occ2_x:(o2_m+Occ2_x-1), Occ2_y:(o2_n+Occ2_y-1) ) = ...
newKnown( Occ2_x:(o2_m+Occ2_x-1), Occ2_y:(o2_n+Occ2_y-1) ) + Known2;

