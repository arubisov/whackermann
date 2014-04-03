% % Load single-frame kinect data

load('trial_5.mat')
% load('..\Anton\Save\20140318_1.mat')
% load('..\Anton\Save\20140325_4.mat')
% load('..\Anton\Save\20140325_4.mat')
context = [];

% For old distorted data
% [rgb,depth] = doUndistort(rgb,depth);
% depth(depth > 6000) = uint16(0); % Remove 'unreliable' pixels.

% context = privateKinectInit();
% [rgb, depth] = privateKinectGrab(context);
% privateKinectStop(context);
