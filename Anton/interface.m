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

% Last Modified by GUIDE v2.5 15-Mar-2014 14:50:31

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
% initialize the axes plot with the world:

world = zeros(100,100);

handles.world = world;
handles.default_cmap = colormap;
handles.depth = depth;
handles.rgb = rgb;
handles.PARAMS = PARAMS;
guidata(hObject,handles);

loadOccGrids(hObject, eventdata, handles);
updateCameraView(hObject, eventdata, handles);


% --- Callback for clicking on axes
function axes_occ_binary_ButtonDownFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
point = get(handles.axes_occ_binary,'CurrentPoint');    % button down detected
point = round(point(1,1:2));                            % extract x and y

x1 = max(1, point(1));
y1 = max(1, point(2));

%handles.world(y1:y1, x1:x1) = 1;
set(findobj('Tag','txt_goal'),'string',sprintf('%d,%d',x1, y1));
guidata(hObject,handles);

%fprintf('Click detected at x: %d, y: %d\n', x1, y1)
updateOccBinary(hObject, eventdata, handles);

% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in push_astar.
function push_astar_Callback(hObject, eventdata, handles)
% hObject    handle to push_astar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

txt = get(handles.txt_dest, 'String');
txt2 = regexp(txt, ',', 'split');
xf = cellfun(@str2num,txt2);

x_f = xf(1);
y_f = xf(2);

handles.world(y_f, x_f) = 3;

%fprintf('Click detected at x: %d, y: %d\n', x1, y1)
updateOccBinary(hObject, eventdata, handles);
%guidata(hObject,handles);  % commit target position to guidata

path = Astar(handles.world, [0 0], [y_f x_f]);

% Display the A* path.
len = size(path,1);
for i=len:-1:2
    handles.world(path(i,1), path(i,2)) = 2;
end
updateOccBinary(hObject, eventdata, handles);


%set_param('modelName','SimulationCommand','stop');

function updateOccBinary(hObject, eventdata, handles)
% Helper function for ploting the selected plot type

%set(handles.axes_occ_binary, 'Tag', 'axes_occ_binary');
%set(handles.axes_occ_binary, 'XLim', [0,101], 'YLim', [0,101]);
set(handles.axes_occ_binary, 'ButtonDownFcn', {@axes_occ_binary_ButtonDownFcn, handles});
%set(handles.axes_occ_binary, 'Ydir', 'normal');
%grid(handles.axes_occ_binary, 'on');
set(findobj(gca,'type','image'),'hittest','off')

binary_cmap = [1 1 1; 0 0 0];
%handles.default_cmap
colormap([binary_cmap; binary_cmap]);

function loadOccGrids(hObject, eventdata, handles)

[X,Y,Z,ImInd] = getPointCloud(handles.depth,handles.PARAMS);
[n,v] = getGroundPlane(X,Y,Z,handles.PARAMS);
[Oax,Xax,Yax] = getWorldFrame(X,Y,Z,ImInd,n,v,handles.depth,handles.rgb);
[X,Y,Z] = getWorldPointMap(X,Y,Z,n,Oax,Xax,Yax);
[Occ,Known,gr_x,gr_y] = getOccupancyGrid(X,Y,Z,handles.PARAMS);

handles.occ_binary = Occ;
handles.occ_conf = Known;
guidata(hObject,handles);

subplot(handles.axes_occ_binary);
%imagesc(gr_x, gr_y, Occ);
imagesc(handles.occ_binary > 0);
set(gca,'YDir','normal')
%axis image
xlabel('X')
ylabel('Y')
updateOccBinary(hObject, eventdata, handles)

Grid = single(Occ)./single(Known);
Grid(isnan(Grid)) = -1;
subplot(handles.axes_occ_conf);
imagesc(gr_x, gr_y, Grid);
set(gca,'YDir','normal')
%axis image
xlabel('X')
ylabel('Y')

function plotPathOnOcc(handles, path)

subplot(handles.axes_occ_binary);
hold on

for ind = size(path,2):-1:2
    disp(path(:,ind));
    speed = path(4,ind-1);
    phi = path(5,ind-1);
    dist = path(6,ind-1);
    robot_length = handles.PARAMS.ROBOT_L / handles.PARAMS.XY_RESOLUTION;

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

plotOccPathArc(0,2*pi,path(1,1),path(2,1),2,'r-');
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

function updateCameraView(hObject, eventdata, handles)
% Helper function for ploting the selected plot type
subplot(handles.axes_camera);
imshow(handles.rgb);

% --- Executes on button press in push_RRT.
function push_RRT_Callback(hObject, eventdata, handles)
% hObject    handle to push_RRT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET GOAL LOCATION
goal = get(handles.txt_goal, 'String');
goal2 = regexp(goal, ',', 'split');
goal3 = cellfun(@str2num,goal2);

% GET INITIAL POSITION
start = get(handles.txt_robot_pose,'String');
start = start(2:end-1);
start2 = regexp(start, ',', 'split');
start3 = cellfun(@str2num,start2);

%fprintf('Click detected at x: %d, y: %d\n', x1, y1)
%guidata(hObject,handles);  % commit target position to guidata

path = RRT_star(handles.occ_binary, [start3(1) start3(2) start3(3)], [goal3(1) goal3(2)], handles.PARAMS);

plotPathOnOcc(handles, path);

%handles.world(y_f, x_f) = 3;
updateOccBinary(hObject, eventdata, handles);


% --- Executes on button press in push_clear_path.
function push_clear_path_Callback(hObject, eventdata, handles)
% hObject    handle to push_clear_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subplot(handles.axes_occ_binary);
imagesc(handles.occ_binary > 0);
set(gca,'YDir','normal')
%axis image
xlabel('X')
ylabel('Y')
updateOccBinary(hObject, eventdata, handles)


% --- Executes on button press in toggle_manual_drive.
function toggle_manual_drive_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_manual_drive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_manual_drive
status = get(hObject,'Value');
set_param('driver/Manual Drive/Manual Mode','Value',num2str(status));
if status == 0
    push_stop_Callback(hObject, eventdata, handles)
    set(hObject,'String','DISABLED');
    set(hObject,'ForegroundColor','black');
    set(findobj('Tag','lbl_current_angle'),'visible','off');
    set(findobj('Tag','txt_current_angle'),'visible','off');
else
    set(hObject,'String','ENABLED');
    set(hObject,'ForegroundColor','red');
    set(findobj('Tag','lbl_current_angle'),'visible','on');
    set(findobj('Tag','txt_current_angle'),'visible','on');
end



function txt_steer_speed_Callback(hObject, eventdata, handles)
% hObject    handle to txt_steer_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_steer_speed as text
%        str2double(get(hObject,'String')) returns contents of txt_steer_speed as a double
set_param('driver/Manual Drive/steer_speed','Value',num2str(get(hObject,'string')));


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
set_param('driver/Manual Drive/drive_speed','Value',num2str(get(hObject,'string')));

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
set(findobj('Tag','txt_steer_speed'),'string','0');
set(findobj('Tag','txt_drive_speed'),'string','0');
set_param('driver/Manual Drive/steer_speed','Value','0');
set_param('driver/Manual Drive/drive_speed','Value','0');



% --- Executes on button press in push_beep.
function push_beep_Callback(hObject, eventdata, handles)
% hObject    handle to push_beep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_param('driver/Beeper/trigger','Value','1');
pause(0.1);  % pause for 100ms
set_param('driver/Beeper/trigger','Value','0');


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


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if get(findobj('Tag','toggle_manual_drive'),'Value') == 1
   if strcmp(eventdata.Key, 'uparrow')
       % increase forward speed
       txt_speed = findobj('Tag','txt_drive_speed');
       old_speed = str2double(get(txt_speed,'string'));
       set(txt_speed,'string',num2str(old_speed + 1));
       set_param('driver/Manual Drive/drive_speed','Value',num2str(old_speed + 1));
   elseif strcmp(eventdata.Key, 'downarrow')
       % decrease forward speed
       txt_speed = findobj('Tag','txt_drive_speed');
       old_speed = str2double(get(txt_speed,'string'));
       set(txt_speed,'string',num2str(old_speed - 1));
       set_param('driver/Manual Drive/drive_speed','Value',num2str(old_speed - 1));
   elseif strcmp(eventdata.Key, 'leftarrow')
       % turn left, ie increase motor speed
       txt_speed = findobj('Tag','txt_steer_speed');
       old_speed = str2double(get(txt_speed,'string'));
       set(txt_speed,'string',num2str(old_speed + 1));
       set_param('driver/Manual Drive/steer_speed','Value',num2str(old_speed + 1));
   elseif strcmp(eventdata.Key, 'rightarrow')
       % turn right, ie decrease motor speed 
       txt_speed = findobj('Tag','txt_steer_speed');
       old_speed = str2double(get(txt_speed,'string'));
       set(txt_speed,'string',num2str(old_speed - 1));
       set_param('driver/Manual Drive/steer_speed','Value',num2str(old_speed - 1));
   end
end


% --- Executes on button press in toggle_connect_simulink.
function toggle_connect_simulink_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_connect_simulink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_connect_simulink
status = get(hObject,'Value');
if status == 1
    set(hObject,'String','CONNECTED');
    set(hObject,'ForegroundColor','red');
    sim('driver');
else
    set_param(gcs, 'SimulationCommand', 'stop');
end
