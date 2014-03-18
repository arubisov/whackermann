function [rgb, depth] = myGrabKinect()

addpath('./Mex');
context = mxNiCreateContext('Config/SamplesConfig.xml');
option.adjust_view_point = false;
mxNiUpdateContext(context, option);
[rgb, depth] = mxNiImage(context);
mxNiDeleteContext(context);