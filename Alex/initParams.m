% Defines the constants used

load('trial_3.mat')
% load('..\Anton\Save\20140318_1.mat')
% [rgb, depth] = myGrabKinect();
rgb = flipdim(rgb,2);
depth = fliplr(depth);

if ~(size(rgb,1) == size(depth,1) && size(rgb,2) == size(depth,2))
    error('depth and RGB do not match');
end

% Vertical and horizontal field of views
PARAMS.VERT_RGB_FOV = 43.5 / 360 * 2 * pi; % 43.5 degrees
PARAMS.HORIZ_RGB_FOV = 57.5 / 360 * 2 * pi; % 57.5 degrees

% Estimated Kinect sensor angle
PARAMS.SENSOR_ANGLE_DEG = 15; % 15 degrees downward

% Too high? -> Less accurate result!
% Too low? -> Slow computation.
% Should be an int > 0.
PARAMS.GROUND_PLANE_DECIMATION_FACTOR = 103;

% Too high? -> Obstacles can be considered ground.
% Too low? -> Fit more vulnerable to noise.
% Should be an int > 2. Dependent on GROUND_PLANE_DECIMATION_FACTOR.
PARAMS.GROUND_PLANE_POINT_THRESHOLD = 1000;

% Occupancy grid parameters
PARAMS.XY_RESOLUTION = 5/100; % 5 cm
PARAMS.ROBOT_HEIGHT = 20/100; % 20 cm
PARAMS.GROUND_HEIGHT = 5/100; % 5 cm

% Robot Physical Parameters
PARAMS.ROBOT_L = 17/100;                % Wheelbase (length) of robot = 17cm
PARAMS.ROBOT_W = 15.5/100;              % Track (width) of robot = 15.5cm
PARAMS.ROBOT_R = 2.75/100;              % Radius of a wheel = 2.75cm
PARAMS.ROBOT_MIN_TURN_RADIUS = 43/100;  % Minimum turn radius
PARAMS.ROBOT_WHEEL_CIRCUM = ...         % Wheel circumference
    2* pi * PARAMS.ROBOT_R;
PARAMS.MAX_STEER = ...                  % Maximum steering angle
    asin(PARAMS.ROBOT_L/(PARAMS.ROBOT_MIN_TURN_RADIUS - PARAMS.ROBOT_W/2));

% RRT* path planning parameters
PARAMS.DRIVE_SPEED = 5;                 % Assumed driving speed for path planning.

% Driving Simulink Model parameters
PARAMS.ROBOT_INIT_POSE = [72 22 pi/2];
PARAMS.ROBOT_MAX_ACCEL = 5;
PARAMS.ROBOT_SPEED_LIM = 20;
PARAMS.ROBOT_POSE_RESET = 0;