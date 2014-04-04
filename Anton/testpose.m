rto = get_param('driver/Dead Reckoning/Bicycle Model/Pose Integrator','RuntimeObject');
pose = sprintf('[%.2f,%.2f,%.2f]',rto.OutputPort(1).Data(1), rto.OutputPort(1).Data(2), rto.OutputPort(1).Data(3));
disp(pose);