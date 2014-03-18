% For rotating the 3D points to the camera's frame of reference
% http://math.stackexchange.com/questions/180418/calculate-rotation-matrix-to-align-vector-a-to-vector-b-in-3d

function R = privateRotateFromTo(target_orientation,source_orientation)

p = cross(target_orientation,source_orientation);
s = norm(p);
c = target_orientation'*source_orientation;
V = [0   -p(3) p(2) ;
     p(3) 0   -p(1) ;
    -p(2) p(1) 0   ];
R = eye(3) + V + V*V*(1-c)/s^2;