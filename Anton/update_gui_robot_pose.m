function varargout = update_gui_robot_pose(varargin)

%create a run time object that can return the value of the block's
%output and then put the value in a string.
rto = get_param('driver/Dead Reckoning/Bicycle Model/Pose Integrator','RuntimeObject');
rto2 = get_param('driver/Dead Reckoning/Steering Subsystem/Switch','RuntimeObject');
pose = sprintf('[%.2f,%.2f,%.2f,%.2f]',rto.OutputPort(1).Data(1), ... 
   rto.OutputPort(1).Data(2), rto.OutputPort(1).Data(3), rto2.OutputPort(1).Data);

%get a handle to the GUI's 'current state' window
txt_pose = findobj('Tag','txt_robot_pose');

%update the gui
set(txt_pose,'String',pose);

end