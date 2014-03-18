% Transforms a depth image into a 3D point cloud using the pinhole camera
% model.

function [X,Y,Z,ImInd] = getPointCloud(depth,PARAMS)

%% INIT

% Vertical and horizontal field of views
VERT_RGB_FOV = PARAMS.VERT_RGB_FOV;
HORIZ_RGB_FOV = PARAMS.HORIZ_RGB_FOV;

% Estimated Kinect sensor angle
SENSOR_ANGLE_DEG = PARAMS.SENSOR_ANGLE_DEG;

sens_o = [0; sind(SENSOR_ANGLE_DEG); cosd(SENSOR_ANGLE_DEG)]; 
tar_o = [0; 0; 1];
R = privateRotateFromTo(tar_o,sens_o);

[m,n] = size(depth);
X = zeros(nnz(depth),1);
Y = X;
Z = X;
ImInd = X;
distance = zeros(m,n);
%% START

k = 1;
for i = 1:m,
    vert_rad = pi/2 + (-1/2 + (m-i-1)/(m-1)) * VERT_RGB_FOV;
    
    for j = 1:n,
        if depth(i,j) ~= 0,
            
            horiz_rad = (1/2 - (n-j-1)/(n-1)) * HORIZ_RGB_FOV;
            
            % Assumes points are laid out rectangularly
%             minDistance = -10
%             scaleFactor = 0.0021
%             z = depth[i][j]
%             x = (i - 480 / 2) * (z + minDistance) * scaleFactor
%             y = (640 / 2 - j) * (z + minDistance) * scaleFactor
%             my3DPoint = single( R * ...
%                                 [ i - n;
%                                   depth(i,j);
%                                   1];
                                
            
            % Uses ray tracing (spherical coordinates w/ focal point
            my3DPoint = single(depth(i,j)) * R *...
                            [   sin(vert_rad)*sin(horiz_rad);  ...
                                cos(horiz_rad)*sin(vert_rad);  ...
                               -cos(vert_rad)                 ];
                             
            X(k) = my3DPoint(1);
            Y(k) = my3DPoint(2);
            Z(k) = my3DPoint(3);
            ImInd(k) = sub2ind([m n],i,j);
            distance(i,j) = sqrt(sum(my3DPoint.^2));
            k = k + 1;
        end
    end
end

% Testing purposes

imagesc(distance)