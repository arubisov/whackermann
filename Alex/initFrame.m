% Load single-frame kinect data

% load('trial_3.mat')
% load('..\Anton\Save\20140318_1.mat')
context = privateKinectInit();
[rgb, depth] = privateKinectGrab(context);
privateKinectStop(context);