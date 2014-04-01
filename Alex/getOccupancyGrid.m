function [Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,PARAMS)

XY_RESOLUTION = PARAMS.XY_RESOLUTION;
ROBOT_HEIGHT = PARAMS.ROBOT_HEIGHT;
GROUND_HEIGHT = PARAMS.GROUND_HEIGHT;

dom = [floor(min(X)/XY_RESOLUTION) ceil(max(X)/XY_RESOLUTION)] * XY_RESOLUTION;
rng = [floor(min(Y)/XY_RESOLUTION) ceil(max(Y)/XY_RESOLUTION)] * XY_RESOLUTION;

gr_x = dom(1):XY_RESOLUTION:dom(2);
gr_y = rng(1):XY_RESOLUTION:rng(2);

Occ = uint16(zeros(length(gr_y)-1,length(gr_x)-1));
Known = Occ;

% This code is a clearer version of the below
% for i = 1:length(Z),
%     
%     if GROUND_HEIGHT < Z(i) && Z(i) < ROBOT_HEIGHT, % Case: Occupied
%         
%         x = floor( (X(i) - dom(1)) / XY_RESOLUTION ) + 1;
%         y = floor( (Y(i) - rng(1)) / XY_RESOLUTION ) + 1;
%         Known(y,x) = Known(y,x) + 1;
%         Occ(y,x) = Occ(y,x) + 1;
%         
%     elseif Z(i) < GROUND_HEIGHT, % Case: Not Occupied
%         
%         x = floor( (X(i) - dom(1)) / XY_RESOLUTION ) + 1;
%         y = floor( (Y(i) - rng(1)) / XY_RESOLUTION ) + 1;
%         Known(y,x) = Known(y,x) + 1;
%         
%     end
% end

AllInd = uint32(1:length(Z));
OccLgc = GROUND_HEIGHT < Z & Z < ROBOT_HEIGHT;
NonOccLgc = Z < GROUND_HEIGHT;
OccInd = AllInd(OccLgc);
NonOccInd = AllInd(NonOccLgc);

x = floor( (X(OccInd) - dom(1)) / XY_RESOLUTION ) + 1;
y = floor( (Y(OccInd) - rng(1)) / XY_RESOLUTION ) + 1;
s = sub2ind(size(Occ),y,x);

for i = 1:length(s), Known(s(i)) = Known(s(i)) + 1; end
for i = 1:length(s), Occ(s(i)) = Occ(s(i)) + 1; end

x = floor( (X(NonOccInd) - dom(1)) / XY_RESOLUTION ) + 1;
y = floor( (Y(NonOccInd) - rng(1)) / XY_RESOLUTION ) + 1;
s = sub2ind(size(Occ),y,x);

for i = 1:length(s), Known(s(i)) = Known(s(i)) + 1; end