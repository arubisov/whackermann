% Transforms the point cloud such that:
% -The ground plane is perpendicular to the 'up' direction
% -X,Y,Z are defined in terms of the axes defined by the orange cones.

function [X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax)

X = X - Oax(1);
Y = Y - Oax(2);
Z = Z - Oax(3);

tar_o = [0; 0; 1];
R = privateRotateFromTo(n,tar_o);

XYZ = R * [X'; Y'; Z'];

Xax = R*(Xax-Oax);
Yax = R*(Yax-Oax);

% Ground plane is now n = e3

% Performing a change of basis from X,Y,Z to Xax,Yax,Zsc
A = [Xax, Yax, [0;0;mean([norm(Xax) norm(Yax)])] ]; % For scaling z
XYZ = A\XYZ;

X = XYZ(1,:)';
Y = XYZ(2,:)';
Z = XYZ(3,:)';