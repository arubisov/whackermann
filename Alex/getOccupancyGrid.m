function [Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,PARAMS)

XY_RESOLUTION = PARAMS.XY_RESOLUTION; % 5 cm
ROBOT_HEIGHT = PARAMS.ROBOT_HEIGHT; % 40 cm
GROUND_HEIGHT = PARAMS.GROUND_HEIGHT; % 5 cm

dom = [floor(min(X)/XY_RESOLUTION) ceil(max(X)/XY_RESOLUTION)] * XY_RESOLUTION;
rng = [floor(min(Y)/XY_RESOLUTION) ceil(max(Y)/XY_RESOLUTION)] * XY_RESOLUTION;

gr_x = dom(1):XY_RESOLUTION:dom(2);
gr_y = rng(1):XY_RESOLUTION:rng(2);

Occ = int8(zeros(length(gr_y)-1,length(gr_x)-1));
Known = Occ;

for i = 1:length(Z),
    
    if GROUND_HEIGHT < Z(i) && Z(i) < ROBOT_HEIGHT, % Case: Occupied
        
        x = floor( (X(i) - dom(1)) / XY_RESOLUTION ) + 1;
        y = floor( (Y(i) - rng(1)) / XY_RESOLUTION ) + 1;
        Known(y,x) = Known(y,x) + 1;
        Occ(y,x) = Occ(y,x) + 1;
        
    elseif Z(i) < GROUND_HEIGHT, % Case: Not Occupied
        
        x = floor( (X(i) - dom(1)) / XY_RESOLUTION ) + 1;
        y = floor( (Y(i) - rng(1)) / XY_RESOLUTION ) + 1;
        Known(y,x) = Known(y,x) + 1;
        
    end
end