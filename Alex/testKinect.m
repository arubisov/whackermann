clear; clc; close all;

cx = privateKinectInit;

figure(1)

for i = 1:200,
    [rgb,depth] = privateKinectGrab(cx);
    subplot(1,2,1)
    imshow(rgb)
    subplot(1,2,2)
    imagesc(depth)
    axis image off
    drawnow
end

privateKinectStop(cx)