function varargout = update_gui_steer_angle(varargin)

%create a run time object that can return the value of the block's
%output and then put the value in a string.
rto = get_param('driver/Dead Reckoning/Steering Subsystem/Encoder1','RuntimeObject');
str = num2str(rto.OutputPort(1).Data);
str = strcat(str, ' deg');

%get a handle to the GUI's 'current state' window
statestxt = findobj('Tag','txt_current_angle');

%update the gui
set(statestxt,'string',str);

end