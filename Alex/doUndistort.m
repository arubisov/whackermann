function [rgb,depth] = doUndistort(rgb,depth)

if exist('../Alex/CameraCalib/Calib_Results.mat','file'),
    load('../Alex/CameraCalib/Calib_Results.mat','fc','cc','kc','alpha_c')
else
    warning('Camera distortion model not found! No undistort applied.')
    return
end

addpath('../Alex/TOOLBOX_calib')

KK = [fc(1) alpha_c*fc(1) cc(1);0 fc(2) cc(2) ; 0 0 1];

rgb = double(rgb);
depth = double(depth);

[rgb1] = rect(rgb(:,:,1),eye(3),fc,cc,kc,alpha_c,KK);
[rgb2] = rect(rgb(:,:,2),eye(3),fc,cc,kc,alpha_c,KK);
[rgb3] = rect(rgb(:,:,3),eye(3),fc,cc,kc,alpha_c,KK);

rgb = uint8(cat(3,rgb1,rgb2,rgb3));

depth = uint16(privateRectNoInterp(depth,eye(3),fc,cc,kc,alpha_c,KK));
