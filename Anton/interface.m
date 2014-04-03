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

% Last Modified by GUIDE v2.5 03-Apr-2014 13:41:37

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
% uiwait(handles.fig_int);

initParams;

handles.PARAMS = PARAMS;
handles.path = [];
handles.drawObsOnGrid = false;
binary_cmap = [1 1 1; 0 0 0];
colormap(binary_cmap);

filename = 'pathplanner_memmapfile.dat';
 
% Create the communications file if it is not already there.
if ~exist(filename, 'file')
    [f, msg] = fopen(filename, 'wb');
    if f ~= -1
        fwrite(f, zeros(1,4), 'double');
        fclose(f);
    else
        error('MATLAB:demo:send:cannotOpenFile', ...
              'Cannot open file "%s": %s.', filename, msg);
    end
end

handles.sharedfile = memmapfile(filename, 'Writable', true, 'Format', 'double');

handles.timer = timer(...
    'ExecutionMode', 'fixedRate', ...   % Run timer repeatedly
    'Period', 0.25, ...                    % Initial period is 2 sec.
    'TimerFcn', {@readRobotPoseFromMemMap,hObject}); % Specify callback

guidata(hObject,handles);

% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function redrawOccBinary(hObject, eventdata, handles)
% Helper function for ploting the selected plot type

subplot(handles.axes_occ_binary);
imagesc(handles.gr_x, handles.gr_y, (handles.BinOcc > handles.PARAMS.RRT_OCC_CONF));
set(handles.axes_occ_binary,'YDir','normal')
axis image


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


% --- Executes on button press in push_RRT_send.
function push_RRT_send_Callback(hObject, eventdata, handles)
% hObject    handle to push_RRT_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET INITIAL POSITION
start = get(handles.txt_robot_pose,'String');
start = start(2:end-1);
start = regexp(start, ',', 'split');
start = cellfun(@str2num,start);

dlmwrite('pathplanner_start.txt', start);


% --- Executes on button press in push_clear_path.
function push_clear_path_Callback(hObject, eventdata, handles)
% hObject    handle to push_clear_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.path = [];
guidata(hObject, handles);
set_param('driver/Path Follower/Exec Path','Value','0');

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
%set(handles.txt_steer_speed,'String','0');
set(handles.txt_drive_speed,'String','0');
%set_param('driver/Path Follower/steer_angle','Value','0');
set_param('driver/Path Follower/drive_speed','Value','0');
set_param('driver/Path Follower/Exec Path','Value','0');


% --- Executes on button press in push_beep.
function push_beep_Callback(hObject, eventdata, handles)
% hObject    handle to push_beep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_param('driver/Beeper/trigger','Value','1');
pause(0.5);  % pause for 1000ms
set_param('driver/Beeper/trigger','Value','0');
set(handles.txt_circle_detected,'String','NO');


% --- Executes on button press in push_exec_path.
function push_exec_path_Callback(hObject, eventdata, handles)
% hObject    handle to push_exec_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.path)
	error('No path found.');
else
    num_waypoints = min(size(handles.path, 2), handles.PARAMS.RRT_MAX_WAYPOINTS);
    path = zeros(6, handles.PARAMS.RRT_MAX_WAYPOINTS);
    path(:, 1:num_waypoints) = handles.path;
    
	set_param('driver/Path Follower/path','Value',mat2str(path));
    set_param('driver/Path Follower/Exec Path','Value','1');
end


% --- Executes on key press with focus on fig_int or any of its controls.
function fig_int_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to fig_int (see GCBO)
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
       new_phi = max(min(old_phi-3, 2*handles.PARAMS.MAX_STEER*180/pi), -handles.PARAMS.MAX_STEER*180/pi);
       set(handles.txt_steer_speed,'string',num2str(new_phi));
       set_param('driver/Path Follower/steer_angle','Value',num2str(new_phi));
   elseif strcmp(eventdata.Key, 'space')
       % stop everything
       push_stop_Callback(hObject, eventdata, handles);
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
set_param('driver/Dead Reckoning/to meters','Gain','0.0008128');


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
rto = get_param('driver/Color Detector/Light Sensor','RuntimeObject');
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in push_refresh_occ.
function push_refresh_occ_Callback(hObject, eventdata, handles)
% hObject    handle to push_refresh_occ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.BinOcc = dlmread('pathplanner_occ_grid.txt');
handles.gr_x = dlmread('pathplanner_gr_x.txt');
handles.gr_y = dlmread('pathplanner_gr_y.txt');
handles.PARAMS.gr_x = handles.gr_x;
handles.PARAMS.gr_y = handles.gr_y;
guidata(hObject, handles);

redrawOccBinary(hObject, eventdata, handles);

% --- Executes when user attempts to close fig_int_planner.
function fig_int_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to fig_int_planner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

if strcmp(get(handles.timer, 'Running'), 'on')
    stop(handles.timer);
    delete(handles.timer)
end


function readRobotPoseFromMemMap(hObject, eventdata, hfigure)
handles = guidata(hfigure);

push_check_black_circle_Callback(hObject, eventdata, handles);

% Wait until the first byte is not zero.
if handles.sharedfile.Data(1) == 0, return; end;

% The first byte now contains the length of the message.
% Get it from m.
set_param('driver/Dead Reckoning/Bicycle Model/robot_init_pose','Value',sprintf('[%f,%f,%f]', handles.sharedfile.Data(2), handles.sharedfile.Data(3), handles.sharedfile.Data(4)));

curr_reset = str2double(get_param('driver/Dead Reckoning/Bicycle Model/robot_pose_reset','Value'));
if curr_reset == 1, set_param('driver/Dead Reckoning/Bicycle Model/robot_pose_reset','Value','-1');
else set_param('driver/Dead Reckoning/Bicycle Model/robot_pose_reset','Value','1'); end

handles.sharedfile.Data(1:4) = zeros(1,4);

fprintf('simulink pose updated.\n');


% --- Executes on button press in tog_stream_from_cam.
function tog_stream_from_cam_Callback(hObject, eventdata, handles)
% hObject    handle to tog_stream_from_cam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tog_stream_from_cam
if get(hObject,'Value') == 1
    set(hObject,'String','Pose From Cam: ON');
    set(hObject,'ForegroundColor','red');
    if strcmp(get(handles.timer, 'Running'), 'off'), start(handles.timer); end;
else
    set(hObject,'String','Pose From Cam: OFF');
    set(hObject,'ForegroundColor','black');
    if strcmp(get(handles.timer, 'Running'), 'on'), stop(handles.timer); end;
end
