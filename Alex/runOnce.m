


context = privateKinectInit();
[rgb, depth] = privateKinectGrab(context);
privateKinectStop(context);

save('run_2.mat')