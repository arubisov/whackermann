function [rgb, depth] = privateKinectGrab(context)

[rgb, depth] = mxNiImage(context);