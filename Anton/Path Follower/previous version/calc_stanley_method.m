% Stanley Method from the DARPA Grand Challenge
%
%   The cross-track error cte(t) measures the lateral distance of the center of
% the vehicle's front wheels from the nearest point on the trajectory. In
% the absence of any lateral errors, the control law points the front
% wheels parallel to the planner trajectory. 
%   The basic steering angle control law is given by 
%         delta(t) = psi(t) + arctan[k*cte(t) / u(t)]
% where psi is the orientation of the nearest path point relative to the
% vehicle's own orientation, k is a gain parameter, and u(t) is the speed
% of the vehicle. The second term adjusts the steering in (nonlinear)
% proportion to the cross-track error cte(t): the larger this error, the
% stronger the steering response toward the trajectory.
%   With this control law, the error converges exponentially to cte(t)=0,
% and the parameter k determines the rate of convergence. 
%%% Thrun et. al. Stanley: The Robot that Won the DARPA Grand Challenge

function [theta_path, cte] = calc_stanley_method(pose, from_node, to_node)
    % Cross-track error is calculated via standard orientation (right-hand
    % rule).
    STRAIGHT_LINE_THRESHOLD = 0.025;
    
    phi = to_node(5);
    dist = to_node(6);
    robot_length = 0.17;

        
    if abs(phi) > STRAIGHT_LINE_THRESHOLD
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calculate heading of the nearest path point.
        % 
        % Instead of actually determining the nearest point, simply get the
        % angle between two vectors: vector between centre and from_node, and
        % between centre and current pose.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        beta = dist*tan(phi)/robot_length;              % turning angle
        radius = dist/beta;                             % turning radius

        CX = from_node(1) - sin(from_node(3)) * radius; % (CX,CY) is center of the turning circle                     
        CY = from_node(2) + cos(from_node(3)) * radius; % (CX,CY) is center of the turning circle

        % a = atan2(path(2,ind) - CY, path(1,ind) - CX);  % orientation of vector between center and from_node

        v_from = [from_node(1)-CX, from_node(2)-CY];    % vector from center to from_node
        v_to = [pose(1)-CX, pose(2)-CY];                % vector from center to pose

        angle = mod(atan2(v_from(1)*v_to(2)-v_to(1)*v_from(2),v_from(1)*v_to(1)+v_from(2)*v_to(2)),2*pi);  % angle between v_from and v_to, counterclockwise from a to b.

        theta_path = mod(from_node(3) + angle, 2*pi);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calculate the cross-track error
        % 
        % Since we're travelling in a circle of fixed radius, the CTE to the
        % nearest point is just equal to the distance from the centre minus the
        % radius of the circle.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cte = norm(v_to) - radius;
        return;
    else
        % Otherwise we're moving virtually straight, so beta will be 0 and
        % radius would be Inf. In this case, the orientation of the path is
        % the same as the orientation of the from_node, and the cross-track
        % error is the perpendicular distance to that line. 
        % http://mathworld.wolfram.com/Point-LineDistance2-Dimensional.html
        theta_path = from_node(3);
        
        pt_from = from_node(1:2);
        pt_to = to_node(1:2);
        cte = det([pt_to - pt_from, pose(1:2) - pt_from])/norm(pt_to - pt_from);
    end
end
