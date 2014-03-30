clear; close all; clc;

cx = privateKinectInit;

try
    i = 10;
    while i < 15,
        [rgb,depth] = privateKinectGrab(cx);
        
        h = figure;
        imshow(rgb);
        drawnow;
        
        in = input('Keep image? <Enter> to discard, any key + <Enter> to keep','s');
        figure(h)
        
        if ~isempty(in),
            save(['./CameraCalib/depth_' num2str(i)],'depth');
            imwrite(rgb2gray(rgb),['./CameraCalib/rgb_' num2str(i) '.bmp'],'bmp');
            i = i + 1;
        else
            
        end
        close(h)
        
    end

catch exception

    privateKinectStop(cx)
    throw(exception)
    
end

privateKinectStop(cx)