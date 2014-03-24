function path_follower_sfunc(block)
%PATH_FOLLOWER_SFUNC A MATLAB S-Function for path following.
%
% The setup method is used to setup the basic attributes of the
% S-function such as ports, parameters, etc. Do not add any other
% calls to the main body of the function.  
%   
    setup(block);
  
%endfunction

% Function: setup ===================================================
% Abstract:
%   Set up the S-function block's basic characteristics such as:
%   - Input ports
%   - Output ports
%   - Dialog parameters
%   - Options
% 
%   Required         : Yes
%   C-Mex counterpart: mdlInitializeSizes
%
function setup(block)

    % Register the number of ports.
    block.NumInputPorts  = 3;
    block.NumOutputPorts = 2;

    % Set up the port properties to be inherited or dynamic.
    block.SetPreCompInpPortInfoToDynamic;
    block.SetPreCompOutPortInfoToDynamic;

    % Override the input port properties.
    block.InputPort(1).DatatypeID  = 0;  % double
    block.InputPort(1).Dimensions  = 4;  % 4-dim vector
    block.InputPort(1).Complexity  = 'Real';
    block.InputPort(1).DirectFeedthrough = true;
    
    % Override the input port properties.
    %block.InputPort(2).DatatypeID  = 0;  % double
    %block.InputPort(2).Dimensions = 1;
    %block.InputPort(2).Complexity  = 'Real';
    %block.InputPort(2).DirectFeedthrough = true;
    
    % Override the input port properties.
    block.InputPort(3).DatatypeID  = 0;  % double
    block.InputPort(3).Dimensions  = 1; 
    block.InputPort(3).Complexity  = 'Real';
    block.InputPort(3).DirectFeedthrough = true;

    % Override the output port properties.
    block.OutputPort(1).DatatypeID  = 0; % double
    block.OutputPort(1).Dimensions  = 1; 
    block.OutputPort(1).Complexity  = 'Real';

    % Override the output port properties.
    block.OutputPort(2).DatatypeID  = 0; % double
    block.OutputPort(2).Dimensions  = 1; 
    block.OutputPort(2).Complexity  = 'Real';

    % Number of continuous states (for cross-track error)
    block.NumContStates = 3;
    
    % Register the parameters.
    block.NumDialogPrms     = 3;
    block.DialogPrmsTunable = {'Tunable','Tunable','Tunable'};

    % Register the sample times.
    %  [0 offset]            : Continuous sample time
    %  [positive_num offset] : Discrete sample time
    %
    %  [-1, 0]               : Inherited sample time
    %  [-2, 0]               : Variable sample time
    block.SampleTimes = [0 0];

    % -----------------------------------------------------------------
    % Options
    % -----------------------------------------------------------------
    % Specify if Accelerator should use TLC or call back to the 
    % MATLAB file
    block.SetAccelRunOnTLC(false);

    % Specify the block simStateCompliance. The allowed values are:
    %    'UnknownSimState', < The default setting; warn and assume DefaultSimState
    %    'DefaultSimState', < Same SimState as a built-in block
    %    'HasNoSimState',   < No SimState
    %    'CustomSimState',  < Has GetSimState and SetSimState methods
    %    'DisallowSimState' < Errors out when saving or restoring the SimState
    block.SimStateCompliance = 'DefaultSimState';

    % -----------------------------------------------------------------
    % The MATLAB S-function uses an internal registry for all
    % block methods. You should register all relevant methods
    % (optional and required) as illustrated below. You may choose
    % any suitable name for the methods and implement these methods
    % as local functions within the same file.
    % -----------------------------------------------------------------

    % -----------------------------------------------------------------
    % Register the methods called during update diagram/compilation.
    % -----------------------------------------------------------------

    % 
    % CheckParameters:
    %   Functionality    : Called in order to allow validation of the
    %                      block dialog parameters. You are 
    %                      responsible for calling this method
    %                      explicitly at the start of the setup method.
    %   C-Mex counterpart: mdlCheckParameters
    %
    %block.RegBlockMethod('CheckParameters', @CheckPrms);

    %
    % SetInputPortSamplingMode:
    %   Functionality    : Check and set input and output port 
    %                      attributes and specify whether the port is operating 
    %                      in sample-based or frame-based mode
    %   C-Mex counterpart: mdlSetInputPortFrameData.
    %   (The DSP System Toolbox is required to set a port as frame-based)
    %
    block.RegBlockMethod('SetInputPortSamplingMode', @SetInpPortFrameData);

    %
    % SetInputPortDimensions:
    %   Functionality    : Check and set the input and optionally the output
    %                      port dimensions.
    %   C-Mex counterpart: mdlSetInputPortDimensionInfo
    %
    block.RegBlockMethod('SetInputPortDimensions', @SetInpPortDims);

    %
    % SetOutputPortDimensions:
    %   Functionality    : Check and set the output and optionally the input
    %                      port dimensions.
    %   C-Mex counterpart: mdlSetOutputPortDimensionInfo
    %
    %block.RegBlockMethod('SetOutputPortDimensions', @SetOutPortDims);

    %
    % SetInputPortDatatype:
    %   Functionality    : Check and set the input and optionally the output
    %                      port datatypes.
    %   C-Mex counterpart: mdlSetInputPortDataType
    %
    %block.RegBlockMethod('SetInputPortDataType', @SetInpPortDataType);

    %
    % SetOutputPortDatatype:
    %   Functionality    : Check and set the output and optionally the input
    %                      port datatypes.
    %   C-Mex counterpart: mdlSetOutputPortDataType
    %
    %block.RegBlockMethod('SetOutputPortDataType', @SetOutPortDataType);

    %
    % SetInputPortComplexSignal:
    %   Functionality    : Check and set the input and optionally the output
    %                      port complexity attributes.
    %   C-Mex counterpart: mdlSetInputPortComplexSignal
    %
    %block.RegBlockMethod('SetInputPortComplexSignal', @SetInpPortComplexSig);

    %
    % SetOutputPortComplexSignal:
    %   Functionality    : Check and set the output and optionally the input
    %                      port complexity attributes.
    %   C-Mex counterpart: mdlSetOutputPortComplexSignal
    %
    %block.RegBlockMethod('SetOutputPortComplexSignal', @SetOutPortComplexSig);

    %
    % PostPropagationSetup:
    %   Functionality    : Set up the work areas and the state variables. You can
    %                      also register run-time methods here.
    %   C-Mex counterpart: mdlSetWorkWidths
    %
    block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);

    % -----------------------------------------------------------------
    % Register methods called at run-time
    % -----------------------------------------------------------------

    % 
    % ProcessParameters:
    %   Functionality    : Call to allow an update of run-time parameters.
    %   C-Mex counterpart: mdlProcessParameters
    %  
    %block.RegBlockMethod('ProcessParameters', @ProcessPrms);

    % 
    % InitializeConditions:
    %   Functionality    : Call to initialize the state and the work
    %                      area values.
    %   C-Mex counterpart: mdlInitializeConditions
    % 
    block.RegBlockMethod('InitializeConditions', @InitializeConditions);

    % 
    % Start:
    %   Functionality    : Call to initialize the state and the work
    %                      area values.
    %   C-Mex counterpart: mdlStart
    %
    %block.RegBlockMethod('Start', @Start);

    % 
    % Outputs:
    %   Functionality    : Call to generate the block outputs during a
    %                      simulation step.
    %   C-Mex counterpart: mdlOutputs
    %
    block.RegBlockMethod('Outputs', @Outputs);

    % 
    % Update:
    %   Functionality    : Call to update the discrete states
    %                      during a simulation step.
    %   C-Mex counterpart: mdlUpdate
    %
    %block.RegBlockMethod('Update', @Update);

    % 
    % Derivatives:
    %   Functionality    : Call to update the derivatives of the
    %                      continuous states during a simulation step.
    %   C-Mex counterpart: mdlDerivatives
    %
    block.RegBlockMethod('Derivatives', @Derivatives);

    % 
    % Projection:
    %   Functionality    : Call to update the projections during a
    %                      simulation step.
    %   C-Mex counterpart: mdlProjections
    %
    %block.RegBlockMethod('Projection', @Projection);

    % 
    % SimStatusChange:
    %   Functionality    : Call when simulation enters pause mode
    %                      or leaves pause mode.
    %   C-Mex counterpart: mdlSimStatusChange
    %
    block.RegBlockMethod('SimStatusChange', @SimStatusChange);

    % 
    % Terminate:
    %   Functionality    : Call at the end of a simulation for cleanup.
    %   C-Mex counterpart: mdlTerminate
    %
    %block.RegBlockMethod('Terminate', @Terminate);

    %
    % GetSimState:
    %   Functionality    : Return the SimState of the block.
    %   C-Mex counterpart: mdlGetSimState
    %
    block.RegBlockMethod('GetSimState', @GetSimState);

    %
    % SetSimState:
    %   Functionality    : Set the SimState of the block using a given value.
    %   C-Mex counterpart: mdlSetSimState
    %
    block.RegBlockMethod('SetSimState', @SetSimState);

    % -----------------------------------------------------------------
    % Register the methods called during code generation.
    % -----------------------------------------------------------------

    %
    % WriteRTW:
    %   Functionality    : Write specific information to model.rtw file.
    %   C-Mex counterpart: mdlRTW
    %
    %block.RegBlockMethod('WriteRTW', @WriteRTW);
%endfunction

% -------------------------------------------------------------------
% The local functions below are provided to illustrate how you may implement
% the various block methods listed above.
% -------------------------------------------------------------------
    
function SetInpPortFrameData(block, idx, fd)
    block.InputPort(idx).SamplingMode = fd;
    block.OutputPort(1).SamplingMode = fd;
    block.OutputPort(2).SamplingMode = fd;
%endfunction
 
function SetInpPortDims(block, idx, di)
    block.InputPort(idx).Dimensions = di;
%endfunction

function DoPostPropSetup(block)
    block.NumDworks = 3;

    block.Dwork(1).Name            = 'path_index';
    block.Dwork(1).Dimensions      = 1;
    block.Dwork(1).DatatypeID      = 0;      % double
    block.Dwork(1).Complexity      = 'Real'; % real
    block.Dwork(1).UsedAsDiscState = false;
    
    block.Dwork(2).Name            = 'steering_mode';
    block.Dwork(2).Dimensions      = 1;
    block.Dwork(2).DatatypeID      = 8;      % boolean
    block.Dwork(2).Complexity      = 'Real'; % real
    block.Dwork(2).UsedAsDiscState = false;
    
    block.Dwork(3).Name            = 'dist_to_next';
    block.Dwork(3).Dimensions      = 1;
    block.Dwork(3).DatatypeID      = 0;      % double
    block.Dwork(3).Complexity      = 'Real'; % real
    block.Dwork(3).UsedAsDiscState = false;
    
%endfunction

function InitializeConditions(block)
    block.Dwork(1).Data = 1;    % initial path index
    block.Dwork(2).Data = true; % start in steering mode
    block.Dwork(3).Data = Inf;  % distance to next node at infinity
    
    block.ContStates.Data(1) = 0; % cte at 0
    block.ContStates.Data(2) = 0; % cte derivative at 0
    block.ContStates.Data(3) = 0; % cte integrator at 0
%endfunction

function outSimState = GetSimState(block)
    outSimState = block.Dwork(1).Data;
%endfunction

function SetSimState(block, inSimState)
    block.Dwork(1).Data = inSimState;
%endfunction

function SimStatusChange(block, s)
    if s == 0
        disp('Pause in simulation.');
    elseif s == 1
        disp('Resume simulation.');
    end
%endfunction

function Derivatives(block)
    pose = block.InputPort(1).Data;
    path = block.InputPort(2).Data;    
    exec_path = block.InputPort(3).Data;
    steering = block.Dwork(2).Data;
    
    if exec_path && ~steering
        from_node = path(:,block.Dwork(1).Data);
        to_node = path(:,block.Dwork(1).Data+1);     
        
        prev_cte = block.ContStates.Data(1);
        cte = crosstrackerror(pose, from_node, to_node);
        
        block.ContStates.Data(1) = cte;
        block.Derivatives.Data(1) = 0;
        block.Derivatives.Data(2) = cte - prev_cte;
        block.Derivatives.Data(3) = cte;
    else
        block.Derivatives.Data(1) = 0;
        block.Derivatives.Data(2) = 0;
        block.Derivatives.Data(3) = 0;
    end
%endfunction


function Outputs(block)
% the meat and bones of the operation.

    pose = block.InputPort(1).Data;
    path = block.InputPort(2).Data;
    exec_path = block.InputPort(3).Data;
    steering = block.Dwork(2).Data;
    
    % prune off columns of zeros.
    path(:, all(~path,1)) = [];

    % are we executing?
    if ~exec_path
        speed = 0;
        steer_speed = 0;
        InitializeConditions(block);
    % if we're executing, are we in steering mode?
    elseif (steering)
        speed = 0;
        to_node = path(:,block.Dwork(1).Data+1);    
        
        if abs(to_node(5) - pose(4)) > 0.02 % more than a degree off desired steering angle
            turn_dir = 1 - 2*((to_node(5) - pose(4)) < 0); % +ve means turn left, -ve turn right.
            steer_speed = 5 * turn_dir;
        else                                % otherwise stop steering
            steer_speed = 0;
            block.Dwork(2).Data = false;
            block.Dwork(3).Data = Inf;
        end
        
        fprintf('PATH FOLLOWER: vel=%.2f, steer=%.2f\n', speed, steer_speed);
        
    % otherwise, let's drive outta here.    
    else

        % otherwise execute the fuck out of this path. 
        % we need to keep track of where on the path we are, and read the
        % motor commands from the output path. the PID should

        % assume we start at the first point. keep track of distance to
        % next point; soon as distance starts growing, we know we're
        % switching to the next target. 
        to_node = path(:,block.Dwork(1).Data+1);     
        
        dist = norm(pose(1:2) - to_node(1:2));
        
        % have we passed our target node?
        if dist > block.Dwork(3).Data
            % move to the next path segment
            block.Dwork(1).Data = block.Dwork(1).Data + 1;
            % set steering mode true
            block.Dwork(2).Data = true;
            speed = 0;
            steer_speed = 0;
            % if we've reached the end of the path, stop execution and reset.
            if block.Dwork(1).Data == size(path,2)
                set_param('driver/Path Follower/Exec Path','Value','0');
                set_param('driver/Path Follower/path','Value','zeros(6,20)');
                InitializeConditions(block);
            end
            
        % otherwise life's all good and let's just drive toward the goal.
        else
            block.Dwork(3).Data = dist;
            
            steer_speed = - block.DialogPrm(1).Data * block.ContStates.Data(1) ...
                     - block.DialogPrm(2).Data * block.ContStates.Data(2) ...
                     - block.DialogPrm(3).Data * block.ContStates.Data(3);

            drive_speed = 20;
            direction = 1 - 2*(to_node(4) < 0);

            speed = direction * drive_speed;
            fprintf('PATH FOLLOWER: vel=%.2f, steer=%.2f\n', speed, steer_speed);
        end
    end
    
    block.OutputPort(1).Data = steer_speed;
    block.OutputPort(2).Data = speed;
    
    set_param('driver/Manual Drive/steer_speed','Value',num2str(steer_speed));
    set_param('driver/Manual Drive/drive_speed','Value',num2str(speed));
%endfunction


    


