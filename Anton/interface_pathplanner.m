function varargout = interface_pathplanner(varargin)
% INTERFACE_PATHPLANNER MATLAB code for interface_pathplanner.fig
%      INTERFACE_PATHPLANNER, by itself, creates a new INTERFACE_PATHPLANNER or raises the existing
%      singleton*.
%
%      H = INTERFACE_PATHPLANNER returns the handle to a new INTERFACE_PATHPLANNER or the handle to
%      the existing singleton*.
%
%      INTERFACE_PATHPLANNER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_PATHPLANNER.M with the given input arguments.
%
%      INTERFACE_PATHPLANNER('Property','Value',...) creates a new INTERFACE_PATHPLANNER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_pathplanner_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_pathplanner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface_pathplanner

% Last Modified by GUIDE v2.5 02-Apr-2014 20:36:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_pathplanner_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_pathplanner_OutputFcn, ...
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


% --- Executes just before interface_pathplanner is made visible.
function interface_pathplanner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface_pathplanner (see VARARGIN)

% Choose default command line output for interface_pathplanner
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface_pathplanner wait for user response (see UIRESUME)
% uiwait(handles.fig_int_planner);

initParams;
initFrame;

handles.default_cmap = colormap;
handles.context = context;
handles.depth = depth;
handles.rgb = rgb;
handles.PARAMS = PARAMS;
handles.path = [];
handles.reset_robot_xy = false;
handles.drawObsOnGrid = false;
handles.draw_pt1 = [];
handles.draw_flag = 0;

filename = 'pathplanner_memmapfile.dat';
 
% Create the communications file if it is not already there.
if ~exist(filename, 'file')
    [f, msg] = fopen(filename, 'wb');
    if f ~= -1
        fwrite(f, zeros(1,3), 'double');
        fclose(f);
    else
        error('MATLAB:demo:send:cannotOpenFile', ...
              'Cannot open file "%s": %s.', filename, msg);
    end
end

handles.sharedfile = memmapfile(filename, 'Writable', true, 'Format', 'double');

guidata(hObject,handles);

loadOccGrids(hObject, eventdata, handles);
binary_cmap = [1 1 1; 0 0 0];
%handles.default_cmap
colormap([binary_cmap; binary_cmap]);



% --- Outputs from this function are returned to the command line.
function varargout = interface_pathplanner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_rrt.
function push_rrt_Callback(hObject, eventdata, handles)
% hObject    handle to push_rrt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET GOAL LOCATION
goal = get(handles.txt_pp_goal, 'String');
goal = regexp(goal, ',', 'split');
goal = cellfun(@str2num,goal);

% GET INITIAL POSITION
start = get(handles.txt_robot_pose,'String');
start = regexp(start, ',', 'split');
start = cellfun(@str2num,start);

%fprintf('Click detected at x: %d, y: %d\n', x1, y1)
%guidata(hObject,handles);  % commit target position to guidata

path = RRT_star((handles.BinOcc > handles.PARAMS.RRT_OCC_CONF), [start(1) start(2) start(3)], [goal(1) goal(2)], handles.PARAMS);
disp(path);
handles.path = path;
guidata(hObject, handles);

plotPathOnOcc(handles, path);


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


function txt_pp_goal_Callback(hObject, eventdata, handles)
% hObject    handle to txt_pp_goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_pp_goal as text
%        str2double(get(hObject,'String')) returns contents of txt_pp_goal as a double


% --- Executes during object creation, after setting all properties.
function txt_pp_goal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_pp_goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_save_to_file.
function push_save_to_file_Callback(hObject, eventdata, handles)
% hObject    handle to push_save_to_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dlmwrite('pathplanner_occ_grid.txt',handles.BinOcc);
dlmwrite('pathplanner_gr_x.txt',handles.gr_x);
dlmwrite('pathplanner_gr_y.txt',handles.gr_y);
dlmwrite('pathplanner_path.txt',handles.path);


% --- Executes on button press in push_load_from_file.
function push_load_from_file_Callback(hObject, eventdata, handles)
% hObject    handle to push_load_from_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start = dlmread('pathplanner_start.txt');
% goal = dlmread('pathplanner_goal.txt');

set(handles.txt_robot_pose, 'String', sprintf('%.2f,%.2f,%.2f', start(1), start(2), start(3)));
% set(handles.txt_pp_goal, 'String', sprintf('%.2f,%.2f', goal(1), goal(2)));


function txt_robot_pose_Callback(hObject, eventdata, handles)
% hObject    handle to txt_robot_pose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_robot_pose as text
%        str2double(get(hObject,'String')) returns contents of txt_robot_pose as a double


% --- Executes during object creation, after setting all properties.
function txt_robot_pose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_robot_pose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Callback for clicking on axes
function axes_camera_ButtonDownFcn(hObject, eventdata, hfigure)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

handles = guidata(hfigure);

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
        1,handles.draw_pt1,pt2);

    [handles.BinOcc] = getBinaryOccupancyGrid(handles.Occ,handles.Known);

    handles.PARAMS.gr_x = handles.gr_x;
    handles.PARAMS.gr_y = handles.gr_y;
    handles.drawObsOnGrid = false;
    handles.draw_pt1 = [];
    guidata(hObject,handles);
    
    redrawOccBinary(hObject, eventdata, handles);
else
    
    set(handles.txt_pp_goal,'String',sprintf('%.2f,%.2f',Dx, Dy));
end


% % --- Callback for clicking on axes
function axes_occ_binary_ButtonDownFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Get default command line output from handles structure
point = get(handles.axes_occ_binary,'CurrentPoint');    % button down detected
point = point(1,1:2); 

[~, x_ind] = min(abs(handles.gr_x - point(1)));
[~, y_ind] = min(abs(handles.gr_y - point(2)));
occ_ind = [x_ind, y_ind];
                
[handles.Occ,handles.Known,handles.BinOcc] = undrawOccWall(handles.Occ,handles.Known,occ_ind);
guidata(hObject, handles);
redrawOccBinary(hObject, eventdata, handles);


function redrawOccBinary(hObject, eventdata, handles)
% Helper function for ploting the selected plot type

subplot(handles.axes_occ_binary);
imagesc(handles.gr_x, handles.gr_y, (handles.BinOcc > handles.PARAMS.RRT_OCC_CONF));
set(handles.axes_occ_binary,'YDir','normal');
axis image
set(handles.axes_occ_binary, 'ButtonDownFcn', {@axes_occ_binary_ButtonDownFcn, handles});
set(findobj(gca,'type','image'),'hittest','off')


function loadOccGrids(hObject, eventdata, handles)

[X,Y,Z,ImInd] = getPointCloud(handles.depth,handles.PARAMS);
[n,v] = getGroundPlane(X,Y,Z,handles.PARAMS);
[Oax,Xax,Yax,~,~,~] = getWorldFrame(X,Y,Z,ImInd,n,v,handles.depth,handles.rgb,handles.PARAMS);
[X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax,handles.PARAMS);
[Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,handles.PARAMS);
[BinOcc] = getBinaryOccupancyGrid(Occ,Known);
[x,y,th,Im,In] = promptForRobotPosition(handles.rgb,n,v,Oax,Xax,Yax,handles.PARAMS);

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
handles.x = x;
handles.y = y;
handles.th = th;
handles.Im = Im;
handles.In = In;

axes(handles.axes_camera);
camHandle = imshow(handles.rgb);
set(camHandle, 'ButtonDownFcn', {@axes_camera_ButtonDownFcn, hObject});
axis image;
handles.camHandle = camHandle;

guidata(hObject,handles);

redrawOccBinary(hObject, eventdata, handles)


function refreshKinect(hObject, eventdata, hfigure)
handles = guidata(hfigure);
if ~isempty(handles.context)
    % update the Kinect image and update robot position.    
    try
%         fprintf('trying to grab\n');
        [handles.rgb, handles.depth] = privateKinectGrab(handles.context);
        guidata(hfigure, handles);
%         fprintf('grabbed. trying to update robot pos...\n');
        [handles.Im,handles.In,handles.x,handles.y,handles.th,update] = ...
            privateUpdateRobotPosition(handles.Im,handles.In, ...
            handles.x,handles.y,handles.th,handles.n,handles.v, ...
            handles.Oax,handles.Xax,handles.Yax,handles.rgb,handles.PARAMS);
        guidata(hfigure, handles);
        
        fprintf('[%.2f,%.2f,%.2f]\n',handles.x, handles.y, handles.th);
        % Update the file via the memory map.
        if update
            handles.sharedfile.Data(1) = 1;
            handles.sharedfile.Data(2:4) = [handles.x, handles.y, handles.th];
            fprintf('file updated to [%.2f,%.2f,%.2f]\n',handles.sharedfile.Data(2),handles.sharedfile.Data(3),handles.sharedfile.Data(4));
        end
        
        guidata(hfigure, handles);
        updateCameraView(handles);
    catch
        fprintf('streaming caught exception. terminating.\n');
        privateKinectStop(handles.context);
    end
end


function updateCameraView(handles)
set(handles.camHandle, 'CData',handles.rgb);


% --- Executes on button press in push_pp_clear_path.
function push_pp_clear_path_Callback(hObject, eventdata, handles)
% hObject    handle to push_pp_clear_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.path = [];
guidata(hObject, handles);
redrawOccBinary(hObject, eventdata, handles)


% --- Executes on key press with focus on fig_int_planner or any of its controls.
function fig_int_planner_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to fig_int_planner (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key, 'd')
    handles.drawObsOnGrid = true;
    guidata(hObject,handles);
end


% --- Executes on button press in push_setrobotxy.
function push_setrobotxy_Callback(hObject, eventdata, handles)
% hObject    handle to push_setrobotxy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.reset_robot_xy = true;
guidata(hObject,handles);


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


% --- Executes when user attempts to close fig_int_planner.
function fig_int_planner_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to fig_int_planner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ~isempty(handles.context)
   privateKinectStop(handles.context);
end

if strcmp(get(handles.timer, 'Running'), 'on')
    stop(handles.timer);
    delete(handles.timer)
end

delete(hObject);


% --- Executes on button press in toggle_stream_kinect.
function toggle_stream_kinect_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_stream_kinect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_stream_kinect

handles.timer = timer(...
    'ExecutionMode', 'fixedRate', ...   % Run timer repeatedly
    'Period', 2, ...                    % Initial period is 2 sec.
    'TimerFcn', {@refreshKinect,hObject}); % Specify callback

guidata(hObject,handles);

start(handles.timer);

set(hObject, 'Enable', 'off');
