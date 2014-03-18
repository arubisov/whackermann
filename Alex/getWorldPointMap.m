% Transforms the point cloud such that:
% -The ground plane is perpendicular to the 'up' direction
% -X,Y,Z are defined in terms of the axes defined by the orange cones.

function [X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax)

% Rotation of the ground plane such that it is normal to the direction of g
% http://math.stackexchange.com/questions/180418/calculate-rotation-matrix-to-align-vector-a-to-vector-b-in-3d
tar_o = [0; 0; 1];
p = cross(tar_o,n);
s = norm(p);
c = tar_o'*n;
V = [0   -p(3) p(2) ;
     p(3) 0   -p(1) ;
    -p(2) p(1) 0   ];
% Rotation matix from n to 'up'
R = eye(3) + V + V*V*(1-c)/s^2;

X = X - Oax(1);
Y = Y - Oax(2);
Z = Z - Oax(3);

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