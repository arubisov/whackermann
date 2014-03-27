% Returns the indicies of points from the point cloud lying on the ground
% plane.

function [GInd,OInd] = getGroundPoints(Z,PARAMS)

% X = X - v(1);
% Y = Y - v(2);
% Z = Z - v(3);

% d = n'* [ X' ;
%           Y' ;
%           Z'];

GInd = Z < PARAMS.GROUND_HEIGHT;
OInd = PARAMS.GROUND_HEIGHT < Z & Z < PARAMS.ROBOT_HEIGHT;