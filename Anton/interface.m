function varargout = interface(varargin)
% INTERFACE MATLAB code for interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface

% Last Modified by GUIDE v2.5 01-Apr-2014 14:04:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface (see VARARGIN)

% Choose default command line output for interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);

initParams;
initFrame;

handles.default_cmap = colormap;
handles.context = context;
handles.depth = depth;
handles.rgb = rgb;
handles.PARAMS = PARAMS;
handles.path = zeros(6, handles.PARAMS.RRT_MAX_WAYPOINTS);
handles.reset_robot_xy = false;
handles.drawObsOnGrid = false;
handles.draw_pt1 = [];
handles.draw_flag = 0;

guidata(hObject,handles);

loadOccGrids(hObject, eventdata, handles);
binary_cmap = [1 1 1; 0 0 0];
%handles.default_cmap
colormap([binary_cmap; binary_cmap]);

updateCameraView(hObject, eventdata, handles);

handles.timer = timer(...
    'ExecutionMode', 'fixedRate', ...   % Run timer repeatedly
    'Period', 1, ...                    % Initial period is 1 sec.
    'TimerFcn', {@refreshKinect,hObject}); % Specify callback
start(handles.timer);



% --- Callback for clicking on axes
function axes_camera_ButtonDownFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

handles = guidata(findobj('Tag','figure1'));

point = get(handles.axes_camera,'CurrentPoint');    % button down detected
point = round(point(1,1:2)); 
md = point(2);
nd = point(1);

[depth_m,depth_n] = size(handles.depth);

[Dx,Dy] = privateRGBToWorld(md,nd,handles.n,handles.v,depth_m,depth_n,handles.Oax,handles.Xax,handles.Yax,handles.PARAMS);

if (get(handles.toggle_click_circles,'Value') == 1)
    fileID = fopen('circles.txt','a');
    fprintf(fileID,'(%.2f,%.2f)\n', Dx, Dy);
    fclose(fileID);
    num_detected = str2double(get(handles.lbl_num_circles,'String'));
    set(handles.lbl_num_circles,'String',num2str(num_detected+1));
    return; 
elseif (handles.reset_robot_xy)
    handles.reset_robot_xy = false;
    guidata(hObject,handles);
    
    pose = get(handles.txt_robot_pose,'String');
    pose = pose(2:end-1);
    pose = regexp(pose, ',', 'split');
    
    % pass new coordinates back to Simulink model
    set_param('driver/Dead Reckoning/Bicycle Model/robot_init_pose','Value',sprintf('[%d,%d,%s]', Dx, Dy, pose{3}));
  
    % reset the pose integrator
    curr_reset = str2double(get_param('driver/Dead Reckoning/Bicycle Model/robot_pose_reset','Value'));
    if curr_reset == 1, set_param('driver/Dead Reckoning/Bicycle Model/robot_pose_reset','Value','-1');
    else set_param('driver/Dead Reckoning/Bicycle Model/robot_pose_reset','Value','1'); end;
    push_refresh_pose_Callback(hObject, eventdata, handles);
    
elseif handles.drawObsOnGrid && isempty(handles.draw_pt1)
    handles.draw_pt1 = [point(1,1) point(1,2)];
    guidata(hObject,handles);
    
    redrawOccBinary(hObject, eventdata, handles);
    
elseif handles.drawObsOnGrid && ~isempty(handles.draw_pt1)
    % TODO: draw lines on the Occ grid. 
    pt2 = [point(1,1) point(1,2)];
    [handles.Occ,handles.Known,handles.gr_x,handles.gr_y] = drawOccWall( ...
        handles.n,handles.v, handles.Oax,handles.Xax,handles.Yax,handles.rgb, ...
        handles.gr_x,handles.gr_y, handles.Occ,handles.Known,handles.PARAMS, ...
        handles.draw_flag,handles.draw_pt1,pt2);

    [handles.BinOcc] = getBinaryOccupancyGrid(handles.Occ,handles.Known);

    handles.PARAMS.gr_x = handles.gr_x;
    handles.PARAMS.gr_y = handles.gr_y;
    handles.drawObsOnGrid = false;
    handles.draw_pt1 = [];
    guidata(hObject,handles);
    
    redrawOccBinary(hObject, eventdata, handles);
else
    
    set(handles.txt_goal,'String',sprintf('%.2f,%.2f',Dx, Dy));
end


% % --- Callback for clicking on axes
function axes_occ_binary_ButtonDownFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Get default command line output from handles structure
% point = get(handles.axes_occ_binary,'CurrentPoint');    % button down detected


    




% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in push_astar.
% function push_astar_Callback(hObject, eventdata, handles)
% % hObject    handle to push_astar (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% txt = get(handles.txt_dest, 'String');
% txt2 = regexp(txt, ',', 'split');
% xf = cellfun(@str2num,txt2);
% 
% x_f = xf(1);
% y_f = xf(2);
% 
% handles.world(y_f, x_f) = 3;
% 
% %fprintf('Click detected at x: %d, y: %d\n', x1, y1)
% redrawOccBinary(hObject, eventdata, handles);
% %guidata(hObject,handles);  % commit target position to guidata
% 
% path = Astar(handles.world, [0 0], [y_f x_f]);
% 
% % Display the A* path.
% len = size(path,1);
% for i=len:-1:2
%     handles.world(path(i,1), path(i,2)) = 2;
% end
% redrawOccBinary(hObject, eventdata, handles);


function redrawOccBinary(hObject, eventdata, handles)
% Helper function for ploting the selected plot type

subplot(handles.axes_occ_binary);
imagesc(handles.gr_x, handles.gr_y, (handles.BinOcc > handles.PARAMS.RRT_OCC_CONF));
set(handles.axes_occ_binary,'YDir','normal')
axis image
set(handles.axes_occ_binary, 'ButtonDownFcn', {@axes_occ_binary_ButtonDownFcn, handles});
set(findobj(gca,'type','image'),'hittest','off')

%set(handles.axes_occ_binary, 'Tag', 'axes_occ_binary');
%grid(handles.axes_occ_binary, 'on');



function loadOccGrids(hObject, eventdata, handles)

[X,Y,Z,ImInd] = getPointCloud(handles.depth,handles.PARAMS);
[n,v] = getGroundPlane(X,Y,Z,handles.PARAMS);
[Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,handles.depth,handles.rgb,handles.PARAMS);
[X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,handles.PARAMS);
[Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,handles.PARAMS);
[BinOcc] = getBinaryOccupancyGrid(Occ,Known);

handles.Occ = Occ;
handles.BinOcc = BinOcc;
handles.Known = Known;
handles.X = X;
handles.Y = Y;
handles.Z = Z;
handles.ImInd = ImInd;
handles.n = n;
handles.v = v;
handles.Oax = Oax;
handles.Xax = Xax;
handles.Yax = Yax;
handles.gr_x = gr_x;
handles.gr_y = gr_y;
handles.PARAMS.gr_x = gr_x;
handles.PARAMS.gr_y = gr_y;
guidata(hObject,handles);

redrawOccBinary(hObject, eventdata, handles)

Grid = single(Occ)./single(Known);
Grid(isnan(Grid)) = -1;
subplot(handles.axes_occ_conf);
imagesc(gr_x, gr_y, Grid);
set(gca,'YDir','normal')
axis image
% xlabel('X')
% ylabel('Y')

function plotPathOnOcc(handles, path)

subplot(handles.axes_occ_binary);
hold on

for ind = 1:size(path,2)-1
    speed = path(4,ind+1);
    phi = path(5,ind+1);
    dist = path(6,ind+1);
    robot_length = handles.PARAMS.ROBOT_L;

    beta = dist*tan(phi)/robot_length;              % turning angle
    radius = dist/beta;                             % turning radius

    CX = path(1,ind) - sin(path(3,ind)) * radius;   % (CX,CY) is center of the turning circle                     
    CY = path(2,ind) + cos(path(3,ind)) * radius;   % (CX,CY) is center of the turning circle

    a = atan2(path(2,ind) - CY, path(1,ind) - CX);

    switch (speed < 0)
        case 1
            color = 'r-';
            b = a - beta;
        case 0
            color = 'b-';
            b = a + beta;
    end
    
    plotOccPathArc(a,b,CX,CY,abs(radius),color)
end

plot([path(1,:) + cosd(path(3,:)*180/pi)*handles.PARAMS.ROBOT_L + sind(path(3,:)*180/pi)*handles.PARAMS.ROBOT_W; ...
    path(1,:) + cosd(path(3,:)*180/pi)*handles.PARAMS.ROBOT_L - sind(path(3,:)*180/pi)*handles.PARAMS.ROBOT_W; ...
    path(1,:) - cosd(path(3,:)*180/pi)*handles.PARAMS.ROBOT_L - sind(path(3,:)*180/pi)*handles.PARAMS.ROBOT_W; ...
    path(1,:) - cosd(path(3,:)*180/pi)*handles.PARAMS.ROBOT_L + sind(path(3,:)*180/pi)*handles.PARAMS.ROBOT_W; ...
    path(1,:) + cosd(path(3,:)*180/pi)*handles.PARAMS.ROBOT_L + sind(path(3,:)*180/pi)*handles.PARAMS.ROBOT_W], ...
    [path(2,:) + sind(path(3,:)*180/pi)*handles.PARAMS.ROBOT_L - cosd(path(3,:)*180/pi)*handles.PARAMS.ROBOT_W; ...
    path(2,:) + sind(path(3,:)*180/pi)*handles.PARAMS.ROBOT_L + cosd(path(3,:)*180/pi)*handles.PARAMS.ROBOT_W; ...
    path(2,:) - sind(path(3,:)*180/pi)*handles.PARAMS.ROBOT_L + cosd(path(3,:)*180/pi)*handles.PARAMS.ROBOT_W; ...
    path(2,:) - sind(path(3,:)*180/pi)*handles.PARAMS.ROBOT_L - cosd(path(3,:)*180/pi)*handles.PARAMS.ROBOT_W; ...
    path(2,:) + sind(path(3,:)*180/pi)*handles.PARAMS.ROBOT_L - cosd(path(3,:)*180/pi)*handles.PARAMS.ROBOT_W], 'm', 'LineWidth', 2);

plotOccPathArc(0,2*pi,path(1,end),path(2,end),handles.PARAMS.RRT_DELTA_GOAL_POINT,'r-');
hold off


function plotOccPathArc(a,b,h,k,r,color)
% Plot a circular arc as a pie wedge.
% a is start of arc in radians, 
% b is end of arc in radians, 
% (h,k) is the center of the circle.
% r is the radius.
% Try this:   plot_arc(pi/4,3*pi/4,9,-4,3)
% Author:  Matt Fig
t = linspace(a,b);
x = r*cos(t) + h;
y = r*sin(t) + k;
plot(x,y,color, 'LineWidth', 2);

function startKinect(hObject, eventdata, handles)
handles.context = privateKinectInit();
guidata(hObject, handles);

function refreshKinect(hObject, eventdata, hfigure)
handles = guidata(hfigure);
fprintf('refreshing kinect\n');
if ~isempty(handles.context)
    fprintf('attempting to refresh\n');
    [handles.rgb, ~] = privateKinectGrab(handles.context);
    guidata(hObject, handles);
    
    updateCameraView(hObject, eventdata, handles);
end

function endKinect(hObject, handles)
privateKinectStop(handles.context)


function updateCameraView(hObject, eventdata, handles)
subplot(handles.axes_camera);
handle = imshow(handles.rgb);
set(handle, 'ButtonDownFcn', {@axes_camera_ButtonDownFcn});
axis image;
%set(findobj(gca,'type','image'),'hittest','off')


% --- Executes on button press in push_RRT_send.
function push_RRT_send_Callback(hObject, eventdata, handles)
% hObject    handle to push_RRT_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear old path if it was there.
%push_clear_path_Callback(hObject, eventdata, handles);

% GET GOAL LOCATION
goal = get(handles.txt_goal, 'String');
goal = regexp(goal, ',', 'split');
goal = cellfun(@str2num,goal);

% GET INITIAL POSITION
start = get(handles.txt_robot_pose,'String');
start = start(2:end-1);
start = regexp(start, ',', 'split');
start = cellfun(@str2num,start);

dlmwrite('pathplanner_occ_grid.txt', handles.BinOcc);
dlmwrite('pathplanner_gr_x.txt', handles.gr_x);
dlmwrite('pathplanner_gr_y.txt', handles.gr_y);
dlmwrite('pathplanner_start.txt', start);
dlmwrite('pathplanner_goal.txt', goal);


% --- Executes on button press in push_clear_path.
function push_clear_path_Callback(hObject, eventdata, handles)
% hObject    handle to push_clear_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.push_exec_path, 'Enable', 'off');
handles.path = zeros(6, handles.PARAMS.RRT_MAX_WAYPOINTS);
guidata(hObject, handles);
set_param('driver/Path Follower/Exec Path','Value','0');
set_param('driver/Path Follower/path','Value',mat2str(handles.path));

redrawOccBinary(hObject, eventdata, handles)


% --- Executes on button press in toggle_manual_drive.
function toggle_manual_drive_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_manual_drive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_manual_drive
status = get(hObject,'Value');
set_param('driver/Path Follower/Manual Mode','Value',num2str(status));
if status == 0
    push_stop_Callback(hObject, eventdata, handles)
    set(hObject,'String','DISABLED');
    set(hObject,'ForegroundColor','black');
else
    set(hObject,'String','ENABLED');
    set(hObject,'ForegroundColor','red');
end



function txt_steer_speed_Callback(hObject, eventdata, handles)
% hObject    handle to txt_steer_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_steer_speed as text
%        str2double(get(hObject,'String')) returns contents of txt_steer_speed as a double
set_param('driver/Path Follower/steer_angle','Value',num2str(get(hObject,'string')));


% --- Executes during object creation, after setting all properties.
function txt_steer_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_steer_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txt_drive_speed_Callback(hObject, eventdata, handles)
% hObject    handle to txt_drive_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_drive_speed as text
%        str2double(get(hObject,'String')) returns contents of txt_drive_speed as a double
set_param('driver/Path Follower/drive_speed','Value',num2str(get(hObject,'string')));


% --- Executes during object creation, after setting all properties.
function txt_drive_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_drive_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_stop.
function push_stop_Callback(hObject, eventdata, handles)
% hObject    handle to push_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_steer_speed,'String','0');
set(handles.txt_drive_speed,'String','0');
set_param('driver/Path Follower/steer_angle','Value','0');
set_param('driver/Path Follower/drive_speed','Value','0');



% --- Executes on button press in push_beep.
function push_beep_Callback(hObject, eventdata, handles)
% hObject    handle to push_beep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_param('driver/Beeper/trigger','Value','1');
pause(0.5);  % pause for 1000ms
set_param('driver/Beeper/trigger','Value','0');
set(handles.txt_circle_detected,'String','NO');


function txt_goal_Callback(hObject, eventdata, handles)
% hObject    handle to txt_goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_goal as text
%        str2double(get(hObject,'String')) returns contents of txt_goal as a double


% --- Executes during object creation, after setting all properties.
function txt_goal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_exec_path.
function push_exec_path_Callback(hObject, eventdata, handles)
% hObject    handle to push_exec_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~handles.path) 
	error('No path found.');
else
    num_waypoints = min(size(handles.path, 2), handles.PARAMS.RRT_MAX_WAYPOINTS);
    path = zeros(6, handles.PARAMS.RRT_MAX_WAYPOINTS);
    path(:, 1:num_waypoints) = handles.path;
    
	set_param('driver/Path Follower/path','Value',mat2str(path));
    set_param('driver/Path Follower/Exec Path','Value','1');
end



% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if get(handles.toggle_manual_drive,'Value') == 1
   if strcmp(eventdata.Key, 'uparrow')
       % increase forward speed
       old_speed = str2double(get(handles.txt_drive_speed,'string'));
       set(handles.txt_drive_speed,'String',num2str(old_speed + 1));
       set_param('driver/Path Follower/drive_speed','Value',num2str(old_speed + 1));
   elseif strcmp(eventdata.Key, 'downarrow')
       % decrease forward speed
       old_speed = str2double(get(handles.txt_drive_speed,'string'));
       set(handles.txt_drive_speed,'string',num2str(old_speed - 1));
       set_param('driver/Path Follower/drive_speed','Value',num2str(old_speed - 1));
   elseif strcmp(eventdata.Key, 'leftarrow')
       % turn left, ie increase motor position
       old_phi = str2double(get(handles.txt_steer_speed,'string'));
       new_phi = max(min(old_phi+3, handles.PARAMS.MAX_STEER*180/pi), -handles.PARAMS.MAX_STEER*180/pi);
       set(handles.txt_steer_speed,'string',num2str(new_phi));
       set_param('driver/Path Follower/steer_angle','Value',num2str(new_phi));
   elseif strcmp(eventdata.Key, 'rightarrow')
       % turn right, ie decrease motor position
       old_phi = str2double(get(handles.txt_steer_speed,'string'));
       new_phi = max(min(old_phi-3, handles.PARAMS.MAX_STEER*180/pi), -handles.PARAMS.MAX_STEER*180/pi);
       set(handles.txt_steer_speed,'string',num2str(new_phi));
       set_param('driver/Path Follower/steer_angle','Value',num2str(new_phi));
   elseif strcmp(eventdata.Key, 'space')
       % stop everything
       push_stop_Callback(hObject, eventdata, handles);
   end
else
    if strcmp(eventdata.Key, 'd')
        handles.drawObsOnGrid = true;
        handles.draw_flag = 1;
        guidata(hObject,handles);
    elseif strcmp(eventdata.Key, 'a')
        handles.draw_flag = 1;
        guidata(hObject,handles);
    elseif strcmp(eventdata.Key, 'c')
        handles.draw_flag = 0;
        guidata(hObject,handles);
    end
end


% --- Executes on button press in toggle_connect_simulink.
function toggle_connect_simulink_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_connect_simulink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_connect_simulink
set_param('driver/Dead Reckoning/Bicycle Model/robot_L','Value',num2str(handles.PARAMS.ROBOT_L));
set_param('driver/Dead Reckoning/Bicycle Model/robot_init_pose','Value',mat2str(handles.PARAMS.ROBOT_INIT_POSE));
set_param('driver/Dead Reckoning/Bicycle Model/robot_pose_reset','Value','1');
set_param('driver/Path Follower/Manual Mode','Value','0');
set_param('driver/Path Follower/drive_speed','Value','0');
set_param('driver/Path Follower/steer_angle','Value','0');
set_param('driver/Color Detector/color_detect_threshold','Value',num2str(handles.PARAMS.COLOR_DETECT_THRESHOLD));
set_param('driver/Path Follower/Exec Path','Value','0');
set_param('driver/Path Follower/path','Value',mat2str(zeros(6, handles.PARAMS.RRT_MAX_WAYPOINTS)));
set_param('driver/Path Follower/Rate Limiter Speed','risingSlewLimit',num2str(handles.PARAMS.ROBOT_MAX_ACCEL));
set_param('driver/Path Follower/Rate Limiter Speed','fallingSlewLimit',num2str(-handles.PARAMS.ROBOT_MAX_ACCEL));
set_param('driver/Dead Reckoning/Speed Subsystem/to meters','Gain',num2str(handles.PARAMS.ROBOT_WHEEL_CIRCUM/360));



% --- Executes on button press in push_setrobotxy.
function push_setrobotxy_Callback(hObject, eventdata, handles)
% hObject    handle to push_setrobotxy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.reset_robot_xy = true;
guidata(hObject,handles);


% --- Executes on button press in push_setrobottheta.
function push_setrobottheta_Callback(hObject, eventdata, handles)
% hObject    handle to push_setrobottheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x = get(handles.txt_override_x, 'String');
y = get(handles.txt_override_y, 'String');
theta = get(handles.txt_override_theta, 'String');

% pass new coordinates back to Simulink model
set_param('driver/Dead Reckoning/Bicycle Model/robot_init_pose','Value',sprintf('[%s,%s,%s]', x, y, theta));

curr_reset = str2double(get_param('driver/Dead Reckoning/Bicycle Model/robot_pose_reset','Value'));

if curr_reset == 1, set_param('driver/Dead Reckoning/Bicycle Model/robot_pose_reset','Value','-1');
else set_param('driver/Dead Reckoning/Bicycle Model/robot_pose_reset','Value','1'); end

push_refresh_pose_Callback(hObject, eventdata, handles);


% --- Executes on button press in push_selfimplode.
function push_selfimplode_Callback(hObject, eventdata, handles)
% hObject    handle to push_selfimplode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in toggle_click_circles.
function toggle_click_circles_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_click_circles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_click_circles
if get(hObject,'Value') == 1
    set(hObject,'String','Circle Location Logging: ON');
    set(hObject,'ForegroundColor','red');
else
    set(hObject,'String','Circle Location Logging: OFF');
    set(hObject,'ForegroundColor','black');
end

    


% --- Executes on button press in push_refresh_pose.
function push_refresh_pose_Callback(hObject, eventdata, handles)
% hObject    handle to push_refresh_pose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%create a run time object that can return the value of the block's
%output and then put the value in a string.
rto = get_param('driver/Dead Reckoning/Bicycle Model/Discrete-Time Integrator','RuntimeObject');
pose = sprintf('[%.2f,%.2f,%.2f]',rto.OutputPort(1).Data(1), rto.OutputPort(1).Data(2), rto.OutputPort(1).Data(3));
set(handles.txt_robot_pose,'String',pose);
set(handles.txt_override_x, 'String', sprintf('%.2f',rto.OutputPort(1).Data(1)));
set(handles.txt_override_y, 'String', sprintf('%.2f',rto.OutputPort(1).Data(2)));
set(handles.txt_override_theta, 'String', sprintf('%.2f',rto.OutputPort(1).Data(3)));



% --- Executes on button press in push_rrt_load.
function push_rrt_load_Callback(hObject, eventdata, handles)
% hObject    handle to push_rrt_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.path = dlmread('pathplanner_path.txt');
guidata(hObject, handles);
plotPathOnOcc(handles, handles.path);


% --- Executes on button press in push_check_black_circle.
function push_check_black_circle_Callback(hObject, eventdata, handles)
% hObject    handle to push_check_black_circle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%create a run time object that can return the value of the block's
%output and then put the value in a string.
rto = get_param('driver/Color Detector/detector','RuntimeObject');
str = num2str(rto.OutputPort(1).Data);

%update the gui
set(handles.txt_circle_detected,'String',str);



function txt_override_x_Callback(hObject, eventdata, handles)
% hObject    handle to txt_override_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_override_x as text
%        str2double(get(hObject,'String')) returns contents of txt_override_x as a double


% --- Executes during object creation, after setting all properties.
function txt_override_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_override_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_override_y_Callback(hObject, eventdata, handles)
% hObject    handle to txt_override_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_override_y as text
%        str2double(get(hObject,'String')) returns contents of txt_override_y as a double


% --- Executes during object creation, after setting all properties.
function txt_override_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_override_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_override_theta_Callback(hObject, eventdata, handles)
% hObject    handle to txt_override_theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_override_theta as text
%        str2double(get(hObject,'String')) returns contents of txt_override_theta as a double


% --- Executes during object creation, after setting all properties.
function txt_override_theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_override_theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_reset_PID_steering.
function push_reset_PID_steering_Callback(hObject, eventdata, handles)
% hObject    handle to push_reset_PID_steering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curr_reset = str2double(get_param('driver/Path Follower/reset PID','Value'));

if curr_reset == 1, set_param('driver/Path Follower/reset PID','Value','-1');
else set_param('driver/Path Follower/reset PID','Value','1'); end