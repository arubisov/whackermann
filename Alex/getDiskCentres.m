function [Dx,Dy] = getDiskCentres(n,v,rgb,depth,Oax,Xax,Yax,PARAMS)

VERT_RGB_FOV = PARAMS.VERT_RGB_FOV;
HORIZ_RGB_FOV = PARAMS.HORIZ_RGB_FOV;
SENSOR_ANGLE_DEG = PARAMS.SENSOR_ANGLE_DEG;
[depth_m,depth_n] = size(depth);

% Find the centre of the disks manually (Current) or automatically (TODO).
% Circle centre returned with respect to RGB image.
[md,nd] = promptForDiskCentre(rgb);

% For testing
% nd = repmat((1:16:depth_m)',depth_n/16,1);
% md = reshape(repmat((1:16:depth_n),depth_m/16,1),depth_m*depth_n/16/16,1);

% Find the line relative to the lens position.

sens_o = [0; sind(SENSOR_ANGLE_DEG); cosd(SENSOR_ANGLE_DEG)]; 
tar_o = [0; 0; 1];
R = privateRotateFromTo(sens_o,tar_o);

Disk = zeros(length(md),3);

for i = 1:length(md),
    
    vert_rad = pi/2 + (-1/2 + (depth_m-md(i)-1)/(depth_m-1)) * VERT_RGB_FOV;
    horiz_rad = (1/2 - (depth_n-nd(i)-1)/(depth_n-1)) * HORIZ_RGB_FOV;
    
    % Line vector passing through 0, relative to the camera's e1,e2,e3
    L = R * [sin(vert_rad)*sin(horiz_rad);  ...
             cos(horiz_rad)*sin(vert_rad);  ...
            -cos(vert_rad)                 ];
        
    % Intersection of plane and line
    Disk(i,:) = (( v'*n / (L'*n) ) * L)';
       
end

% [Dx,Dy,Dz] = getWorldPointMap(Disk(:,1),Disk(:,2),Disk(:,3),n,Oax,Xax,Yax);
Dx = Disk(:,1);
Dy = Disk(:,2);
Dz = Disk(:,3);

if any(abs(Dz) > 1E-5), error('oops'); end