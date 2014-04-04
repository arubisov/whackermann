% Defines the constants used

PARAMS.PYLON_O = [0.610 -3.619];
PARAMS.PYLON_X = [1.205 -2.213];
PARAMS.PYLON_Y = [-0.745 -2.558];

%;
%;
%;

if exist('3Dax.mat','file'), delete('3Dax.mat'); end

PARAMS.SEARCH_DIAMETER = 50;
PARAMS.ROBOT_HEIGHT_PX = 5;

PARAMS.VERT_RGB_FOV = 43.5 / 360 * 2 * pi; % 43.5 degrees
PARAMS.HORIZ_RGB_FOV = 57.5 / 360 * 2 * pi; % 57.5 degrees

% Estimated Kinect sensor angle
% Better too little than too much!
PARAMS.SENSOR_ANGLE_DEG = 20; % 10 degrees downward

% Factor for correcting the image (arbitrary, increases focal length)
PARAMS.IMAGE_CORRECTION_FACTOR = 0;

% Too high? -> Less accurate result!
% Too low? -> Slow computation.
% Should be an int > 0.
PARAMS.GROUND_PLANE_DECIMATION_FACTOR = 137;

% Too high? -> Obstacles can be considered ground.
% Too low? -> Fit more vulnerable to noise.
% Should be an int > 2. Dependent on GROUND_PLANE_DECIMATION_FACTOR.
PARAMS.GROUND_PLANE_POINT_THRESHOLD = 800;

% Occupancy grid parameters
PARAMS.XY_RESOLUTION = 5/100; % 5 cm
PARAMS.ROBOT_HEIGHT = 20/100; % 20 cm
PARAMS.GROUND_HEIGHT = 10/100; % 10 cm

% Robot Physical Parameters
PARAMS.ROBOT_L = 17/100;                % Wheelbase (length) of robot = 17cm
PARAMS.ROBOT_W = 15.5/100;              % Track (width) of robot = 15.5cm
PARAMS.ROBOT_R = 2.75/100;              % Radius of a wheel = 2.75cm
PARAMS.ROBOT_MIN_TURN_RADIUS = 43/100;  % Minimum turn radius = 43cm
PARAMS.ROBOT_WHEEL_CIRCUM = ...         % Wheel circumference
    2* pi * PARAMS.ROBOT_R;
PARAMS.MAX_STEER = ...                  % Maximum steering angle
    asin(PARAMS.ROBOT_L/(PARAMS.ROBOT_MIN_TURN_RADIUS - PARAMS.ROBOT_W/2));

% RRT* path planning parameters
PARAMS.RRT_RAND_SEED = 1;                   % Seed for random number generator.
PARAMS.RRT_MAX_ITER  = 5000;               % Max number of iterations
PARAMS.RRT_MAX_NODES = 4000;                % Max number of nodes to store.
PARAMS.RRT_DRIVE_SPEED = 5;                 % Assumed driving speed for path planning.
PARAMS.RRT_DELTA_GOAL_POINT = 0.05;         % Radius of goal position region in metres
PARAMS.RRT_DELTA_NEAR = 1;                  % Radius for neighboring nodes in metres
PARAMS.RRT_MAX_WAYPOINTS = 20;              % Maximum number of waypoints that get fed to the path follower.
PARAMS.RRT_OCC_CONF = 0.99;                 % Confidence to use for the occupancy grid.
PARAMS.STRT_LN_THRESH = 0.0001;             % Threshold angle less than which movement is considered to be in a straight line.

% Driving Simulink Model parameters
PARAMS.ROBOT_INIT_POSE = [0 0 0];
PARAMS.ROBOT_MAX_ACCEL = 5;
PARAMS.ROBOT_SPEED_LIM = 20;
PARAMS.ROBOT_POSE_RESET = 0;
PARAMS.COLOR_DETECT_THRESHOLD = 40;
