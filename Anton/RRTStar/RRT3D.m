classdef RRT3D < handle
    properties (SetAccess = private)
        occ_grid            % Occupancy grid of the world
        R                   % Radius of a wheel
        W                   % Width of the robot
        L                   % Length of the robot
        DRIVE_SPEED         % Robot driving speed (for steps in the path)
        MAX_STEER           % Maximum robot steering angle
        tree                % Array stores pose information of tree nodes (x,y,theta)
        parent              % Array stores relations of nodes
        children            % Number of children of each node
        free_nodes          % Indices of free nodes
        free_nodes_ind      % Last element in free_nodes
        cost                % Cost between 2 connected states
        cumcost             % Cost from the root of the tree to the given node
        XY_BOUNDARY         % [min_x max_x min_y max_y]
        goal_point          % Goal position
        delta_goal_point    % Radius of goal position region
        delta_near          % Radius of near neighbor nodes
        nodes_added         % Keeps count of added nodes
        obstacle            % Obstacle information
        best_path_node      % The index of last node of the best path
        goal_reached        % Flag for whether we've reached the goal
        %%% temporary variables
        compare_table
        index
        list
        num_rewired
    end
    methods
        % class constructor
        function rrt = RRT3D(rand_seed, max_nodes, occ_grid, params)
            rng(rand_seed);
            rrt.occ_grid = occ_grid;
            rrt.R = params.ROBOT_R / params.XY_RESOLUTION;
            rrt.W = params.ROBOT_W / params.XY_RESOLUTION;
            rrt.L = params.ROBOT_L / params.XY_RESOLUTION;
            rrt.DRIVE_SPEED = params.DRIVE_SPEED;
            rrt.MAX_STEER = params.MAX_STEER;
            rrt.tree = zeros(6, max_nodes);
            rrt.parent = zeros(1, max_nodes);
            rrt.children = zeros(1, max_nodes);
            rrt.free_nodes = zeros(1, max_nodes);
            rrt.free_nodes_ind = 1;
            rrt.cost = zeros(1, max_nodes);
            rrt.cumcost = zeros(1,max_nodes);
            rrt.XY_BOUNDARY = [1; size(occ_grid,2); 1; size(occ_grid,1)];
            rrt.tree(:, 1) = [params.start_pose, zeros(1,3)]'; % Start position
            rrt.goal_point = params.goal_point;
            rrt.delta_goal_point = params.delta_goal_point;
            rrt.delta_near = params.delta_near;
            rrt.nodes_added = uint32(1);
            rrt.best_path_node = -1;
            rrt.goal_reached = false;
            %%% temp var-s initialization
            rrt.compare_table = zeros(1, max_nodes);
            rrt.index = zeros(1, max_nodes);
            rrt.list = 1:max_nodes;
            rrt.num_rewired = 0;
        end
        
        % ==============================================================
        % RRT FUNCTIONS
        % ==============================================================
        
        % Antonized
        % Generate and return random (x,y,theta) point in the environment.
        function position = sample(rrt)
            xyrand = rand(2,1);
            % pick the goal point with a 10% chance.
            if rand(1,1) < 0.1
                position = rrt.goal_point';
            else
                position = [rrt.XY_BOUNDARY(2); rrt.XY_BOUNDARY(4)] .* xyrand;
            end
        end
        
        % Antonized
        % Find the nearest node to the given node using the (x,y) Euclidian
        % distance, plus a weight on the rotation distance. 
        function node_index = nearest(rrt, new_node)
            rrt.compare_table(1:(rrt.nodes_added)) = sum((rrt.tree(1:2, 1:(rrt.nodes_added)) - repmat(new_node(1:2),1,rrt.nodes_added)).^2);
            [rrt.compare_table(1:(rrt.nodes_added)), rrt.index(1:(rrt.nodes_added))] = sort(rrt.compare_table(1:(rrt.nodes_added)));
            node_index = rrt.index(1);
            return;
        end
        
        % Antonized
        
        % re-write rrt.
        % new idea: choose steering direction (90% forward, 10% reverse)
        % and figure out steering angle required to get from nearest to
        % new. if steering angle is within limits, it's a valid path.
        % then if it's valid, check whether it hits obstacles. if it does,
        % ditch it and try again.
        % update cost as distance traveled (it's an arc), multiplied by a
        % factor (say 10?) if we're moving backwards.
        % we'll need to keep track of steering angle and direction choice.
        
        
        % Generate random steering speed and apply kinematic model to 
        % produce new position given 1s of drive time. Since we're incrementally
        % travelling through the occ_grid, check for collisions at this point.
        function steer_inputs = steer(rrt, nearest_node_ind, new_node)
            curr_pose = rrt.tree(1:3,nearest_node_ind);
            theta = curr_pose(3);                                   
            gamma = atan2(new_node(2) - curr_pose(2), new_node(1) - curr_pose(1));
            
            alpha = rrt.wrap_angle_to_pi(gamma - theta);    % angle b/w vehicle's heading vector and target vector, in range [-pi,pi]
            d = norm(new_node - curr_pose(1:2));        % distance to target point
            dist = alpha*d/sin(alpha);                  % distance traveled on the arc connection to target
            steer = atan(2*rrt.L*sin(alpha)/d);         % steering angle
            speed = rrt.DRIVE_SPEED;                    % driving speed
            
            % if the target is behind the vehicle, with a 20% chance drive
            % backward. otherwise still drive forward. if we're driving
            % backward, change the distance to full circle minus that
            % original distance.
            if alpha < -pi/2 || alpha > pi/2
                if rand(1,1) < 0.2
                    speed = -rrt.DRIVE_SPEED;
                    dist = 2*pi*abs(rrt.L/tan(steer)) - dist;
                end
            end

%             fprintf('new_node: [%.2f %.2f] \n',new_node);
%             fprintf('nearest_node: [%.2f %.2f %.2f] \n',curr_pose);
%             fprintf('theta=%.2f, gamma=%.2f, alpha=%.2f, dist=%.2f, speed=%.2f, steer=%.2f \n',theta,gamma,alpha,dist,speed, steer);

            steer_inputs = [speed, steer, dist];
        end
        
        function [valid, final_node] = validate(rrt, nearest_node_ind, inputs)
            final_node = zeros(3,1);
            valid = true;
            
            if inputs(2) < -rrt.MAX_STEER || inputs(2) > rrt.MAX_STEER
                valid = false;
                return;
            end
            
            pose = rrt.tree(:, nearest_node_ind);   % starting pose
            theta = pose(3);                        % starting orientation
            phi = inputs(2);                        % steering angle
            %beta = inputs(3)*tan(phi)/rrt.L;        % turning angle
            radius = rrt.L/tan(phi);                % turning radius
            
            CX = pose(1) - sin(pose(3)) * radius;   % (CX,CY) is center of the turning circle                     
            CY = pose(2) + cos(pose(3)) * radius;   % (CX,CY) is center of the turning circle
             
            % check for backward driving
            sign = 1 - (inputs(1) < 0)*2;
            
            steps = abs(floor(inputs(3)));          % number of steps over which to check validity = distance traveled
            poses = zeros(steps,3);
            
            if (steps == 0)
                valid = false;
                return;
            end
            
            for i = 1:steps
                beta = (i/steps)*inputs(3)/radius;  % turning angle
                poses(i, 1) = CX + sin(theta + sign*beta)*radius;
                poses(i, 2) = CY - cos(theta + sign*beta)*radius;
                poses(i, 3) = mod(theta + sign*beta, 2*pi);
            end
                      
            final_node = poses(end,:);
            
            % check whether we're off the occ_grid
            mins = round(min(poses,[],1));
            maxs = round(max(poses,[],1));
            
            if mins(1) < rrt.XY_BOUNDARY(1) || maxs(1) > rrt.XY_BOUNDARY(2) || mins(2) < rrt.XY_BOUNDARY(3) || maxs(2) > rrt.XY_BOUNDARY(4)
                valid = false;
                return;
            end
                
            % collision detection by checking a box of size L^2 around the
            % center of the robot.
            % poses: each unique vehicle poses (avoid double-checking)
            poses = unique(round(poses), 'rows');
            % centers: centre of the vehicle at each of the unique poses
            centers = poses(:, 1:2) + [cos(poses(:,3))/(0.5*rrt.L) sin(poses(:,3))/(0.5*rrt.L)];
            % ranges: each row: [xmin xmax ymin ymax]
            ranges = [max(round(centers(:,1)-rrt.L/2), rrt.XY_BOUNDARY(1)), ...
                      min(round(centers(:,1)+rrt.L/2), rrt.XY_BOUNDARY(2)), ...
                      max(round(centers(:,2)-rrt.L/2), rrt.XY_BOUNDARY(3)), ...
                      min(round(centers(:,2)+rrt.L/2), rrt.XY_BOUNDARY(4))];
            
            for i=1:size(ranges,1)
                robot_occ_area = rrt.occ_grid(ranges(i,3):ranges(i,4),ranges(i,1):ranges(i,2));
                if any(any(robot_occ_area))
                    valid = false;
                    return;
                end
            end
        end
        
        % Antonized
        % Insert new node into the tree. 
        function new_node_ind = insert_node(rrt, parent_node_ind, new_node_pose, steer_inputs)
            % method insert new node in the tree
            rrt.nodes_added = rrt.nodes_added + 1;
            rrt.tree(:, rrt.nodes_added) = [new_node_pose, steer_inputs]';                               % adding new node position 
            rrt.parent(rrt.nodes_added) = parent_node_ind;                                              % adding new node parent-children info
            rrt.children(parent_node_ind) = rrt.children(parent_node_ind) + 1;                          % adding new node parent-children info
            rrt.cost(rrt.nodes_added) = (1 + 4*(steer_inputs(1)<0)) * steer_inputs(3);                  % cost-to-come is distance traveled, x5 if moving backward                
            rrt.cumcost(rrt.nodes_added) = rrt.cumcost(parent_node_ind) + rrt.cost(rrt.nodes_added);   	% cummulative cost
            new_node_ind = rrt.nodes_added;
        end
        
        % ==============================================================
        % RRT* FUNCTIONS
        % ==============================================================
        
        % Antonized
        % Return indices of nodes that are within a given radius of the new node.
        function neighbor_nodes = neighbors(rrt, new_node_pose)
            % seeks for neighbors and returns indices of neighboring nodes
            radius = rrt.delta_near;
            rrt.compare_table(1:(rrt.nodes_added)) = sum((rrt.tree(1:2, 1:(rrt.nodes_added)) - repmat(new_node_pose(1:2),1,rrt.nodes_added)).^2);
            [rrt.compare_table(1:(rrt.nodes_added)), rrt.index(1:(rrt.nodes_added))] = sort(rrt.compare_table(1:(rrt.nodes_added)));
            temp = rrt.index((rrt.compare_table(1:(rrt.nodes_added)) <= radius^2) & (rrt.compare_table(1:(rrt.nodes_added)) > 0 ));
            % neighbor_nodes = setdiff(temp, nearest_node_ind);
            neighbor_nodes = temp;
        end
        
        % Antonized
        % Choose which of the neighbor nodes has the minimal cumulative
        % cost from the root of the tree. 
        function [min_node_ind, final_node] = chooseParent(rrt, neighbors, nearest_node_ind, new_node_ind)
            min_node_ind = nearest_node_ind;
            min_cumcost = rrt.cumcost(new_node_ind);
            final_node = zeros(1,3);
            final_steer_inputs = zeros(1,3);
            for ind=1:numel(neighbors)
                
                temp_steer_inputs = rrt.steer(neighbors(ind), rrt.tree(1:2, new_node_ind));
                [valid, temp_node] = rrt.validate(neighbors(ind), temp_steer_inputs);
                
                if (valid)
                    temp_cumcost = rrt.cumcost(neighbors(ind)) + (1 + 4*(temp_steer_inputs(1)<0)) * temp_steer_inputs(3);
                    if temp_cumcost < min_cumcost
                        min_cumcost = temp_cumcost;
                        min_node_ind = neighbors(ind);
                        final_node = temp_node;
                        final_steer_inputs = temp_steer_inputs;
                    end
                end
            end
            
            % if we found a better parent, re-wire now:
            if (min_node_ind ~= nearest_node_ind)
                rrt.cumcost(new_node_ind) = temp_cumcost;
                rrt.tree(:, new_node_ind) = [final_node, final_steer_inputs]';
                rrt.children(nearest_node_ind) = rrt.children(nearest_node_ind) - 1;
                rrt.children(min_node_ind) = rrt.children(min_node_ind) + 1;
                rrt.parent(new_node_ind) = min_node_ind;
                rrt.num_rewired = rrt.num_rewired + 1;
            end
        end
        
        % Antonized
        % Look through all neighbors (excl. the min_node_ind) and rewire
        % if there is now a cheaper path for them. 
        function rewire(rrt, new_node_ind, neighbors, min_node_ind)
            for ind = 1:numel(neighbors)
                % excl. the min_node_ind, and the node itself
                if (neighbors(ind) == min_node_ind || neighbors(ind) == new_node_ind)
                    continue;
                end
                
                % we want to avoid the two-boundary problem...let's only
                % re-wire if the node has no children
                if (rrt.children(neighbors(ind)) > 0)
                    continue;
                end
                
                temp_steer_inputs = rrt.steer(new_node_ind, rrt.tree(1:2, neighbors(ind)));
                [valid, temp_node] = rrt.validate(new_node_ind, temp_steer_inputs);
                
                if (valid)
                    temp_cumcost = rrt.cumcost(new_node_ind) + (1 + 4*(temp_steer_inputs(1)<0)) * temp_steer_inputs(3);
                    if (temp_cumcost < rrt.cumcost(neighbors(ind)))
                        rrt.cumcost(neighbors(ind)) = temp_cumcost;
                        rrt.children(rrt.parent(neighbors(ind))) = rrt.children(rrt.parent(neighbors(ind))) - 1;
                        rrt.parent(neighbors(ind)) = new_node_ind;
                        rrt.children(new_node_ind) = rrt.children(new_node_ind) + 1;
                        rrt.tree(:,neighbors(ind)) = [temp_node, temp_steer_inputs]';
                        rrt.num_rewired = rrt.num_rewired + 1;
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        function path = return_path(rrt)
            distances = zeros(rrt.nodes_added, 2);
            distances(:, 1) = sum((rrt.tree(1:2,1:(rrt.nodes_added)) - repmat(rrt.goal_point', 1, rrt.nodes_added)).^2);
            distances(:, 2) = 1:rrt.nodes_added;
            distances = sortrows(distances, 1);
            distances(:, 1) = distances(:, 1) <= rrt.delta_goal_point ^ 2;
            dist_index = numel(find(distances(:, 1) == 1));
            % find the cheapest path
            if(dist_index ~= 0)
                distances(:, 1) = rrt.cumcost(int32(distances(:, 2)));
                distances = distances(1:dist_index, :);
                distances = sortrows(distances, 1);
                nearest_node_index = distances(1,2);
            else
                disp('NOTICE! Robot cannot reach the goal');
                nearest_node_index = distances(1,2);
            end
            % backtracing the path
            current_index = nearest_node_index;
            path_iter = 1;
            path = zeros(6,1);
            while(current_index ~= 1)
                path(:,path_iter) = rrt.tree(:,current_index);
                path_iter = path_iter + 1;
                current_index = rrt.parent(current_index);
            end
            path(:,path_iter) = rrt.tree(:,current_index);
        end
        
        
        function plot(rrt)
            %%% Find the optimal path to the goal
            % finding all the point which are in the desired region
            distances = zeros(rrt.nodes_added, 2);
            distances(:, 1) = sum((rrt.tree(1:2,1:(rrt.nodes_added)) - repmat(rrt.goal_point', 1, rrt.nodes_added)).^2);
            distances(:, 2) = 1:rrt.nodes_added;
            distances = sortrows(distances, 1);
            distances(:, 1) = distances(:, 1) <= rrt.delta_goal_point ^ 2;
            dist_index = numel(find(distances(:, 1) == 1));
            % find the cheapest path
            if(dist_index ~= 0)
                distances(:, 1) = rrt.cumcost(int32(distances(:, 2)));
                distances = distances(1:dist_index, :);
                distances = sortrows(distances, 1);
                nearest_node_index = distances(1,2);
            else
                disp('NOTICE! Robot cannot reach the goal');
                nearest_node_index = distances(1,2);
            end
            % backtracing the path
            current_index = nearest_node_index;
            path_iter = 1;
            backtrace_path = zeros(1,1);
            while(current_index ~= 1)
                backtrace_path(path_iter) = current_index;
                path_iter = path_iter + 1;
                current_index = rrt.parent(current_index);
            end
            backtrace_path(path_iter) = current_index;
            close all;
            figure;
            %set(gcf(), 'Renderer', 'opengl');
            hold on;
            
            %obstacle drawing
            bin_cmap = [1 1 1; 0 0 0];
            colormap(bin_cmap);
            imagesc(rrt.occ_grid > 0);
            
            
            drawn_nodes = zeros(1, rrt.nodes_added);
            for ind = rrt.nodes_added:-1:1;
                if(sum(rrt.free_nodes(1:rrt.free_nodes_ind) == ind)>0)
                    continue;
                end
                current_index = ind;
                while(current_index ~= 1 && current_index ~= -1)
                    % avoid drawing same nodes twice or more times
                    if(drawn_nodes(current_index) == false || drawn_nodes(rrt.parent(current_index)) == false)
                        if (rrt.tree(4,current_index) < 0)
                            color = 'r-';
                        else
                            color = 'g-';
                        end
                        plot([rrt.tree(1,current_index);rrt.tree(1, rrt.parent(current_index))], ...
                             [rrt.tree(2,current_index);rrt.tree(2, rrt.parent(current_index))],color,'LineWidth', 0.5);
%                         plot([rrt.tree(1,current_index);rrt.tree(1, rrt.parent(current_index))], ...
%                             [rrt.tree(2, current_index);rrt.tree(2, rrt.parent(current_index))],'+k');
                        drawn_nodes(current_index) = true;
                        
                    end
                    current_index = rrt.parent(current_index);
                end
            end
            
%             for ind = rrt.nodes_added:-1:1
%                 rrt.plot_circle(rrt.tree(1,ind),rrt.tree(2,ind),1);
%             end
            
            for ind = numel(backtrace_path):-1:2
                speed = rrt.tree(4,backtrace_path(ind-1));
                dist = rrt.tree(6,backtrace_path(ind-1));
                phi = rrt.tree(5,backtrace_path(ind-1));
                
                beta = dist*tan(phi)/rrt.L;   % turning angle
                radius = dist/beta;           % turning radius
                
                CX = rrt.tree(1,backtrace_path(ind)) - sin(rrt.tree(3,backtrace_path(ind))) * radius;   % (CX,CY) is center of the turning circle                     
                CY = rrt.tree(2,backtrace_path(ind)) + cos(rrt.tree(3,backtrace_path(ind))) * radius;   % (CX,CY) is center of the turning circle

                a = atan2(rrt.tree(2,backtrace_path(ind)) - CY, rrt.tree(1,backtrace_path(ind)) - CX);
                
                switch (speed < 0)
                    case 1
                        color = 'r-';
                        b = a - beta;
                    case 0
                        color = 'b-';
                        b = a + beta;
                end
                rrt.plot_arc(a,b,CX,CY,abs(radius),color)

            end
            
            plot([rrt.tree(1,backtrace_path) + cosd(rrt.tree(3,backtrace_path)*180/pi)*rrt.L + sind(rrt.tree(3,backtrace_path)*180/pi)*rrt.W; ...
                rrt.tree(1,backtrace_path) + cosd(rrt.tree(3,backtrace_path)*180/pi)*rrt.L - sind(rrt.tree(3,backtrace_path)*180/pi)*rrt.W; ...
                rrt.tree(1,backtrace_path) - cosd(rrt.tree(3,backtrace_path)*180/pi)*rrt.L - sind(rrt.tree(3,backtrace_path)*180/pi)*rrt.W; ...
                rrt.tree(1,backtrace_path) - cosd(rrt.tree(3,backtrace_path)*180/pi)*rrt.L + sind(rrt.tree(3,backtrace_path)*180/pi)*rrt.W; ...
                rrt.tree(1,backtrace_path) + cosd(rrt.tree(3,backtrace_path)*180/pi)*rrt.L + sind(rrt.tree(3,backtrace_path)*180/pi)*rrt.W], ...
                [rrt.tree(2,backtrace_path) + sind(rrt.tree(3,backtrace_path)*180/pi)*rrt.L - cosd(rrt.tree(3,backtrace_path)*180/pi)*rrt.W; ...
                rrt.tree(2, backtrace_path) + sind(rrt.tree(3,backtrace_path)*180/pi)*rrt.L + cosd(rrt.tree(3,backtrace_path)*180/pi)*rrt.W; ...
                rrt.tree(2, backtrace_path) - sind(rrt.tree(3,backtrace_path)*180/pi)*rrt.L + cosd(rrt.tree(3,backtrace_path)*180/pi)*rrt.W; ...
                rrt.tree(2, backtrace_path) - sind(rrt.tree(3,backtrace_path)*180/pi)*rrt.L - cosd(rrt.tree(3,backtrace_path)*180/pi)*rrt.W; ...
                rrt.tree(2,backtrace_path) + sind(rrt.tree(3,backtrace_path)*180/pi)*rrt.L - cosd(rrt.tree(3,backtrace_path)*180/pi)*rrt.W], 'm', 'LineWidth', 2);
            
            rrt.plot_circle(rrt.goal_point(1), rrt.goal_point(2), rrt.delta_goal_point);
            axis(rrt.XY_BOUNDARY);
            grid on;
            axis equal;
            disp(num2str(rrt.cumcost(backtrace_path(1))));
        end
        
        function newObj = copyobj(rrtObj)
            % Construct a new object based on a deep copy of the current
            % object of this class by copying properties over.
            props = properties(rrtObj);
            for i = 1:length(props)
                % Use Dynamic Expressions to copy the required property.
                % For more info on usage of Dynamic Expressions, refer to
                % the section "Creating Field Names Dynamically" in:
                % web([docroot '/techdoc/matlab_prog/br04bw6-38.html#br1v5a9-1'])
                newObj.(props{i}) = thisObj.(props{i});
            end
        end
        
        function print_tree(rrt,ind)
            disp(rrt.tree(:,1:ind));
        end
        
        
    end
    methods(Static)
        % takes in two robot poses (x,y,theta,phi) and returns distance
        % between them.
        function dist = Euclidean_dist(src_pos, dest_pos)
            dist = norm(dest_pos(1:3) - src_pos(1:3));
        end
        function plot_circle(x, y, r)
            t = 0:0.001:2*pi;
            cir_x = r*cos(t) + x;
            cir_y = r*sin(t) + y;
            plot(cir_x, cir_y, 'r-', 'LineWidth', 1.5);
        end
        function plot_arc(a,b,h,k,r,color)
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
        end

        
        function theta = wrap_angle_to_pi(theta)
            theta = mod(theta,2*pi); % [0 2pi)

            % shift
            j = theta > pi;
            theta(j) = theta(j) - 2*pi;
            j = theta < - pi;
            theta(j) = theta(j) + 2*pi;
        end
    end
end