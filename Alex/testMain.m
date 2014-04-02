% MAIN sample

clear; close all; clc;

%% INIT Params

initParams;
cx = privateKinectInit;

try
    %% INIT World Frame Data
    
    [rgb,depth] = privateKinectGrab(cx);
%     initFrame
    
    [X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
    
    % Use more than 1 iteration to stabilize the ground plane
    for i = 1:20, % Set to 20 when not using static frames
        if i == 5, PARAMS.GROUND_PLANE_DECIMATION_FACTOR = 23; end
        if i == 10, PARAMS.GROUND_PLANE_DECIMATION_FACTOR = 1; end % Improves results
        
        [n,v] = getGroundPlane(X,Y,Z,PARAMS);
        if i ~= 1, n = privateRotateFromTo(old_n,n)*n; end
        old_n = n;
        [X,Y,Z] = privateRotateAboutVFromTo(X,Y,Z,n,v);
        X = X';
        Y = Y';
        Z = Z';
    end
    
    %% INIT Occupancy Grid Data
    
    % World (rgb to m, depth to m) transformation data
    [Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS); % Note: Prompts user
    [X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,PARAMS);
    [sOcc,sKnown,sgr_x,sgr_y] = getOccupancyGrid(X,Y,Z,PARAMS);
    
    % Occupancy grid loop, accumulate data from multiple frames to generate map...
    figure(1)
    for i = 1:10, % Set to 10 when not using static frames
        [rgb,depth] = privateKinectGrab(cx);
%         initFrame;
        
        [X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
        [Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS); % Note: Does not prompt user, world axes already available
        [X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,PARAMS);
        [Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,PARAMS);
        
        [sOcc,sKnown,sgr_x,sgr_y] = sumOcc(sOcc,sKnown,sgr_x,sgr_y,Occ,Known,gr_x,gr_y,PARAMS);
    end
    
    [BinOcc] = getBinaryOccupancyGrid(sOcc,sKnown);
    
    %% INIT Robot start position
    [x,y,th,Im,In] = promptForRobotPosition(rgb,n,v,Oax,Xax,Yax,PARAMS);
    
    %% START
    in = 'foo';
    while ~isempty(in)
        switch in
            case 'addwall'
                [sOcc,sKnown,sgr_x,sgr_y] = promptForOccWall(n,v,Oax,Xax,Yax,rgb,sgr_x,sgr_y,sOcc,sKnown,PARAMS);% Note: Prompts user
                [BinOcc] = getBinaryOccupancyGrid(sOcc,sKnown);
                in = 'foo';
            case 'manualrobotpos'
                [rgb,depth] = privateKinectGrab(cx);
%                 initFrame;
                [x,y,th,Im,In] = promptForRobotPosition(rgb,n,v,Oax,Xax,Yax,PARAMS); % Note: Prompts user
                in = 'foo';
            case 'autorobotpos'
                [rgb,depth] = privateKinectGrab(cx);
%                 initFrame;
                [Im,In,x,y,th] = privateUpdateRobotPosition(Im,In,x,y,th,n,v,Oax,Xax,Yax,rgb,PARAMS);
                in = 'foo';
            case 'measurepoint'
                privateTestMeasure(n,v,rgb,depth,Oax,Xax,Yax,PARAMS); % Note: Prompts user
                in = 'foo';
            otherwise
                in = input('What would you like to do...','s');
        end
    end

catch exception

    privateKinectStop(cx)
    exception.stack.file
    exception.stack.line
    throw(exception)
end

privateKinectStop(cx)