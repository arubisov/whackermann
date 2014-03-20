function [Dx,Dy] = testMeasure(n,v,rgb,depth,Oax,Xax,Yax,PARAMS)

VERT_RGB_FOV = PARAMS.VERT_RGB_FOV;
HORIZ_RGB_FOV = PARAMS.HORIZ_RGB_FOV;
SENSOR_ANGLE_DEG = PARAMS.SENSOR_ANGLE_DEG;
[depth_m,depth_n] = size(depth);

% focalLengthZ = depth_m/2/tan(VERT_RGB_FOV/2);
% focalLengthX = depth_n/2/tan(HORIZ_RGB_FOV/2);

h = figure('units','normalized','outerposition',[0 0 1 1]);
imshow(rgb)

% % For testing
% hold on
% figure(2)
% k = 137;
% scatter3(decimate(X,k),decimate(Y,k),decimate(Z,k),'.')
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% axis equal

while true
    
    [x,y] = ginput(1);
    if isempty(x) break; end
    md = round(y);
    nd = round(x);

    % Find the line relative to the lens position.

    sens_o = [0; sind(SENSOR_ANGLE_DEG); cosd(SENSOR_ANGLE_DEG)];
    R = privateRotateFromTo(sens_o,n);

    Disk = zeros(length(md),3);
    
    % Ray Tracing
    focalLengthZ = depth_m/2/tan(VERT_RGB_FOV/2);
    focalLengthX = depth_n/2/tan(HORIZ_RGB_FOV/2);
    for i = 1:length(md),

%         vert_rad = pi/2 + (-1/2 + (depth_m-md(i)-1)/(depth_m-1)) * VERT_RGB_FOV;
%         horiz_rad = (1/2 - (depth_n-nd(i)-1)/(depth_n-1)) * HORIZ_RGB_FOV;

        vert_rad = asin((depth_m/2 - md(i))/focalLengthZ);
        horiz_rad = asin((depth_n/2 - nd(i))/focalLengthX);
        
        % Line vector passing through 0, relative to the camera's e1,e2,e3
%         L = R * [sin(vert_rad)*sin(horiz_rad);  ...
%                  cos(horiz_rad)*sin(vert_rad);  ...
%                 -cos(vert_rad)                 ];
            
        L = R * [sin(horiz_rad)
                 1
                 sin(vert_rad) ];

        % Intersection of plane and line
        Disk(i,:) = (( v'*n / (L'*n) ) * L)';

    end

    [Dx,Dy,~] = getWorldPointMap(Disk(:,1),Disk(:,2),Disk(:,3),n,Oax,Xax,Yax);
    
    figure(h)
    title(['x = ' num2str(Dx,3) '; y = ' num2str(Dy,3) ';'])
    
    % For testing
%     figure(2)
%     hold on
%     scatter(Dx,Dy,'red','*')
    
end

close(h)