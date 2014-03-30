% Returns the ground plane of a point cloud. Assumes the points are
% oriented such that z is 'up'. Assumes a ground plane exists.

function [n,v] = getGroundPlane(X,Y,Z,PARAMS)

%% INIT

GROUND_PLANE_DECIMATION_FACTOR = PARAMS.GROUND_PLANE_DECIMATION_FACTOR;
GROUND_PLANE_POINT_THRESHOLD = PARAMS.GROUND_PLANE_POINT_THRESHOLD;

if GROUND_PLANE_DECIMATION_FACTOR ~= 1,
    X = downsample(X,GROUND_PLANE_DECIMATION_FACTOR);
    Y = downsample(Y,GROUND_PLANE_DECIMATION_FACTOR);
    Z = downsample(Z,GROUND_PLANE_DECIMATION_FACTOR);
end

Z_ind = [Z (1:length(Z))'];

%% START

Z_sort = sortrows(Z_ind);

pl_pts_ind = Z_sort(1:GROUND_PLANE_POINT_THRESHOLD,2);

X_pl = X(pl_pts_ind);
Y_pl = Y(pl_pts_ind);
Z_pl = Z(pl_pts_ind);

% 3-D Least squares orthogonal regression
% See math at http://www.geometrictools.com/Documentation/LeastSquaresFitting.pdf

v = mean([X_pl Y_pl Z_pl],1)';

X_pl = X_pl - v(1);
Y_pl = Y_pl - v(2);
Z_pl = Z_pl - v(3);

M = [sum(X_pl.^2) sum(X_pl.*Y_pl) sum(X_pl.*Z_pl);
     0            sum(Y_pl.^2)    sum(Y_pl.*Z_pl);
     0            0               sum(Z_pl.^2)  ];
M = M + triu(M,1)'; % M is symmetric

[V,E] = eig(M); 
ev = diag(E); % Eigenvalues
n = V(:,ev == min(ev)); % Minimum Eigenvector
