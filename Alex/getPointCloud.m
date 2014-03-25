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
% sens_o = [sind(SENSOR_ANGLE_DEG); 0; cosd(SENSOR_ANGLE_DEG)]; 
tar_o = [0; 0; 1];
R = privateRotateFromTo(sens_o,tar_o);
[m,n] = size(depth);
% X = zeros(nnz(depth),1);
% Y = X;
% Z = X;
% ImInd = X;

%% START

focalLengthZ = m/2/tan(VERT_RGB_FOV/2);
focalLengthX = n/2/tan(HORIZ_RGB_FOV/2);

sin_vert_rad = (-1*(1:m)+m/2)/focalLengthZ;
sin_horiz_rad = (-1*(1:n)+n/2)/focalLengthX;

% k = 1;
% for i = 1:m,
%     for j = 1:n,
%         
%         if depth(i,j), % depth nonzero
%             
%             my3DPoint = double(depth(i,j)) * R * ...
%                             [   sin_horiz_rad(j) ;
%                                 1                ;
%                                 sin_vert_rad(i) ];
%                              
%             X(k) = my3DPoint(1);
%             Y(k) = my3DPoint(2);
%             Z(k) = my3DPoint(3);
%             ImInd(k) = (j-1)*m + i; %sub2ind
%             k = k + 1;
%         end
%     end
% end

AllInd = 1:(m*n);
ImLgc = depth ~= 0;
ImInd = AllInd(ImLgc(:));
i = mod(ImInd-1,m)+1;
j = floor((ImInd-1)/m)+1;
% [i,j] = ind2sub([m n],DepthPosInd);
XYZ = repmat(double(depth(ImLgc)+PARAMS.IMAGE_CORRECTION_FACTOR)',3,1) .* (R * ...
        [ sin_horiz_rad(j) ;
          ones(1,length(j));
          sin_vert_rad(i) ]);
X = XYZ(1,:)';
Y = XYZ(2,:)';
Z = XYZ(3,:)';
