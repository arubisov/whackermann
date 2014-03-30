clear; close all; clc;

initParams;
cx = privateKinectInit;

try

    figure(1)

    for i = 1:50,
        [rgb,depth] = privateKinectGrab(cx);
        [X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
        [n,v] = getGroundPlane(X,Y,Z,PARAMS);
        [Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS);
        [X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,PARAMS);
        [Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,PARAMS);
        [BinOcc] = getBinaryOccupancyGrid(Occ,Known);

%         subplot(2,2,1)
%         k = 137;
%         scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
%         xlabel('X')
%         ylabel('Y')
%         zlabel('Z')
%         axis equal
        subplot(2,2,1)
        imagesc(gr_x,gr_y,(BinOcc > 0.9999) - (Known == 0))
        set(gca,'YDir','normal')
        axis image
        xlabel('X')
        ylabel('Y')
        title('p = 0.9999 Occupancy Grid')

        subplot(2,2,2)
        imshow(rgb)

        subplot(2,2,3)
        imagesc(gr_x,gr_y,Occ)
        set(gca,'YDir','normal')
        axis image
        colorbar;
        xlabel('X')
        ylabel('Y')
        title('Number of ''Occupied'' Readings')
        
        subplot(2,2,4)
        imagesc(gr_x,gr_y,Known)
        set(gca,'YDir','normal')
        axis image
        colorbar;
        xlabel('X')
        ylabel('Y')
        title('Number of Samples')

        drawnow
    end

catch exception

    privateKinectStop(cx)
    throw(exception)
    
end

privateKinectStop(cx)