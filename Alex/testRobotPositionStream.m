clear; close all; clc;

initParams;
cx = privateKinectInit;

try
    
    [rgb,depth] = privateKinectGrab(cx);
    [X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
    [n,v] = getGroundPlane(X,Y,Z,PARAMS);
    [Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS);
    [X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,PARAMS);
    [sOcc,sKnown,sgr_x,sgr_y] = getOccupancyGrid(X,Y,Z,PARAMS);
    [BinOcc] = getBinaryOccupancyGrid(sOcc,sKnown);
    [x,y,th,Im,In] = promptForRobotPosition(rgb,n,v,Oax,Xax,Yax,PARAMS);
    
    figure(1)
    imagesc(sgr_x,sgr_y,(BinOcc == 1) - (sKnown == 0))
    set(gca,'YDir','normal')
    axis image
    xlabel('X')
    ylabel('Y')
    title('p = 1 Occupancy Grid')
    
    hold on
    plot(x,y)
    
    drawnow;
    
    in = input('Press a key to continue...','s');
    
    while isempty(in),
        
        [rgb,depth] = privateKinectGrab(cx);
        [Im,In,x,y,th] = privateUpdateRobotPosition(Im,In,x,y,th,n,v,Oax,Xax,Yax,rgb,PARAMS);
        
        scatter(x,y,'*','red')
        drawnow
        
        in = input('Press a key to continue...','s');
    end

catch exception

    privateKinectStop(cx)
    throw(exception)
    
end

privateKinectStop(cx)