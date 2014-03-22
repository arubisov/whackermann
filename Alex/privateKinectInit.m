function context = privateKinectInit()

addpath('./Mex');
context = mxNiCreateContext('Config/SamplesConfig.xml');
option.adjust_view_point = true;
mxNiUpdateContext(context, option);