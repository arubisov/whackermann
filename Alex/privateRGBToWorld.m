function [x,y] = privateRGBToWorld(M,N,n,v,size_m,size_n,Oax,Xax,Yax,PARAMS)

% Find the line relative to the lens position.
tar_o = [0; 0; 1];
sens_o = [0; sind(PARAMS.SENSOR_ANGLE_DEG); cosd(PARAMS.SENSOR_ANGLE_DEG)];
R = privateRotateFromTo(sens_o,tar_o);

focalLengthZ = size_m/2/tan(PARAMS.VERT_RGB_FOV/2);
focalLengthX = size_n/2/tan(PARAMS.HORIZ_RGB_FOV/2);
PlaneLineIsct = zeros(length(M),3);

% Ray Tracing

sin_vert_rad = (size_m/2 - M)/focalLengthZ;
sin_horiz_rad = (-size_n/2 + N)/focalLengthX;

for i = 1:length(M),

%         vert_rad = pi/2 + (-1/2 + (size_m-M(i)-1)/(size_m-1)) * VERT_RGB_FOV;
%         horiz_rad = (1/2 - (size_n-N(i)-1)/(size_n-1)) * HORIZ_RGB_FOV;

%     sin_vert_rad = (size_m/2 - M(i))/focalLengthZ;
%     sin_horiz_rad = (-size_n/2 + N(i))/focalLengthX;

    L = R * [sin_horiz_rad(i) ;
             1                ;
             sin_vert_rad(i) ];

    % Intersection of plane and line
    PlaneLineIsct(i,:) = (( v'*n / (L'*n) ) * L)';

end

[x,y,~] = getWorldPointMap(PlaneLineIsct(:,1),PlaneLineIsct(:,2),PlaneLineIsct(:,3),n,Oax,Xax,Yax,PARAMS);
