function [rgb, depth] = privateKinectGrab(context)

option.adjust_view_point = true;
mxNiUpdateContext(context, option);
[rgb, depth] = mxNiImage(context);

[rgb,depth] = doUndistort(rgb,depth);