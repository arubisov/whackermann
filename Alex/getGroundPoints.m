% Returns the indicies of points from the point cloud lying on the ground
% plane.

function [GInd] = getGroundPoints(X,Y,Z,n,v)

MAXIMUM_GROUND_DISTANCE = 120;

X = X - v(1);
Y = Y - v(2);
Z = Z - v(3);

d = n'* [ X' ;
          Y' ;
          Z'];

GInd = d < MAXIMUM_GROUND_DISTANCE;