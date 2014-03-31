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

% Last Modified by GUIDE v2.5 30-Mar-2014 15:42:08

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
% uiwait(handles.figure1);

initParams;
handles.PARAMS = PARAMS;
handles.path = [];
guidata(hObject,handles);

binary_cmap = [1 1 1; 0 0 0];
colormap(binary_cmap);



% --- Outputs from this function are returned to the command line.
function varargout = interface_pathplanner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_refresh_occ.
function push_refresh_occ_Callback(hObject, eventdata, handles)
% hObject    handle to push_refresh_occ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.occ = dlmread('pathplanner_occ_grid.txt');
handles.gr_x = dlmread('pathplanner_gr_x.txt');
handles.gr_y = dlmread('pathplanner_gr_y.txt');
handles.PARAMS.gr_x = handles.gr_x;
handles.PARAMS.gr_y = handles.gr_y;
guidata(hObject, handles);

subplot(handles.axes_occ);
imagesc(handles.gr_x, handles.gr_y, (handles.occ > handles.PARAMS.RRT_OCC_CONF));
set(gca,'YDir','normal')
axis image

updateOccBinary(hObject, eventdata, handles)


function updateOccBinary(hObject, eventdata, handles)
% Helper function for ploting the selected plot type

set(handles.axes_occ, 'ButtonDownFcn', {@axes_occ_ButtonDownFcn, handles});
set(findobj(gca,'type','image'),'hittest','off')


% --- Executes on button press in push_rrt.
function push_rrt_Callback(hObject, eventdata, handles)
% hObject    handle to push_rrt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET GOAL LOCATION
goal = get(handles.txt_goal, 'String');
goal = regexp(goal, ',', 'split');
goal = cellfun(@str2num,goal);

% GET INITIAL POSITION
start = get(handles.txt_start,'String');
start = regexp(start, ',', 'split');
start = cellfun(@str2num,start);

%fprintf('Click detected at x: %d, y: %d\n', x1, y1)
%guidata(hObject,handles);  % commit target position to guidata

path = RRT_star((handles.occ > handles.PARAMS.RRT_OCC_CONF), [start(1) start(2) start(3)], [goal(1) goal(2)], handles.PARAMS);
disp(path);
handles.path = path;
guidata(hObject, handles);

plotPathOnOcc(handles, path);

updateOccBinary(hObject, eventdata, handles);


function plotPathOnOcc(handles, path)

subplot(handles.axes_occ);
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


% --- Executes on button press in push_clear_path.
function push_clear_path_Callback(hObject, eventdata, handles)
% hObject    handle to push_clear_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.path = [];
guidata(hObject, handles);

subplot(handles.axes_occ);
imagesc(handles.gr_x, handles.gr_y, (handles.occ > handles.PARAMS.RRT_OCC_CONF));
set(gca,'YDir','normal')
axis image

updateOccBinary(hObject, eventdata, handles)



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


% --- Executes on button press in push_save_to_file.
function push_save_to_file_Callback(hObject, eventdata, handles)
% hObject    handle to push_save_to_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dlmwrite('pathplanner_path.txt',handles.path);
h = msgbox('Path saved to file.');


% --- Executes on button press in push_load_from_file.
function push_load_from_file_Callback(hObject, eventdata, handles)
% hObject    handle to push_load_from_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start = dlmread('pathplanner_start.txt');
goal = dlmread('pathplanner_goal.txt');

set(handles.txt_start, 'String', sprintf('%.2f,%.2f,%.2f', start(1), start(2), start(3)));
set(handles.txt_goal, 'String', sprintf('%.2f,%.2f', goal(1), goal(2)));



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txt_start_Callback(hObject, eventdata, handles)
% hObject    handle to txt_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_start as text
%        str2double(get(hObject,'String')) returns contents of txt_start as a double


% --- Executes during object creation, after setting all properties.
function txt_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
