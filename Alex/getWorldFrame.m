% Returns the 3D Points representing the axes which define the world frame.

function [Oax,Xax,Yax,Oax3,Xax3,Yax3] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS)

if exist('3Dax.mat','file')
    load('3Dax.mat')
else


%     % Find the tip of the cones manually (Current) or automatically (TODO). Tip
%     % of cones returned with respect to 2D images.
%     [Od,Xd,Yd] = promptFor3DAxes(depth,rgb);
% 
%     % Find the 3D points associated with the cone tops
%     for i = 1:3,
%         switch i
%             case 1,
%                 ind = find(ImInd == Od);
%                 Oax3 = [X(ind); Y(ind); Z(ind)];
%             case 2,
%                 ind = find(ImInd == Xd);
%                 Xax3 = [X(ind); Y(ind); Z(ind)];
%             case 3,
%                 ind = find(ImInd == Yd);
%                 Yax3 = [X(ind); Y(ind); Z(ind)];
%             otherwise,
%                 error('switch error')
%         end
%         if length(ind) ~= 1, error('find index error'); end
%     end
    [depth_m,depth_n] = size(rgb(:,:,1));
    focalLengthZ = depth_m/2/tan(PARAMS.VERT_RGB_FOV/2);
    focalLengthX = depth_n/2/tan(PARAMS.HORIZ_RGB_FOV/2);
    
    h = figure;
    imshow(rgb)
    title('Get Cone Centre of O, X, and Y')
    [x,y] = ginput(3);
    close(h)
    md = round(y);
    nd = round(x);

    % Find the line relative to the lens position.
    tar_o = [0; 0; 1];
    sens_o = [0; sind(PARAMS.SENSOR_ANGLE_DEG); cosd(PARAMS.SENSOR_ANGLE_DEG)];
    R = privateRotateFromTo(sens_o,tar_o);

    Disk = zeros(3,3);
    
    % Ray Tracing
    for i = 1:3,

%         vert_rad = pi/2 + (-1/2 + (depth_m-md(i)-1)/(depth_m-1)) * VERT_RGB_FOV;
%         horiz_rad = (1/2 - (depth_n-nd(i)-1)/(depth_n-1)) * HORIZ_RGB_FOV;

        sin_vert_rad = (depth_m/2 - md(i))/focalLengthZ;
        sin_horiz_rad = (-depth_n/2 + nd(i))/focalLengthX;
            
        L = R * [sin_horiz_rad ;
                 1             ;
                 sin_vert_rad ];

        % Intersection of plane and line
        Disk(i,:) = (( v'*n / (L'*n) ) * L)';

    end
    
    Oax3 = Disk(1,:)';
    Xax3 = Disk(2,:)';
    Yax3 = Disk(3,:)';
    
    % Project 3D Points onto the ground plane
    Oax = (Oax3 - v) - ((Oax3 - v)'*n)/(n'*n)*n + v;
    Xax = (Xax3 - v) - ((Xax3 - v)'*n)/(n'*n)*n + v;
    Yax = (Yax3 - v) - ((Yax3 - v)'*n)/(n'*n)*n + v;

    save('3Dax.mat','Oax','Xax','Yax','Oax3','Xax3','Yax3')
end