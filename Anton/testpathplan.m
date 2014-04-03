initParams;
load('20140325_4.mat')
context = [];

[X,Y,Z,ImInd] = getPointCloud(depth,PARAMS);
[n,v] = getGroundPlane(X,Y,Z,PARAMS);
[Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb,PARAMS);
[X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,PARAMS);
[Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,PARAMS);
[BinOcc] = getBinaryOccupancyGrid(Occ,Known);

PARAMS.gr_x = gr_x;
PARAMS.gr_y = gr_y;

start = [0 2 0];
goal = [0 6];

RRT_star((BinOcc > PARAMS.RRT_OCC_CONF), start, goal, PARAMS)