classdef RRT3D < handle
    properties (SetAccess = private)
        map                 % Map of the world
        R                   % Radius of a wheel
        W                   % Width of the robot
        L                   % Length of the robot
        DRIVE_SPEED         % Robot driving speed (for steps in the path)
        MAX_STEER           % Maximum robot steering angle
        MAX_STEER_SPEED     % Maximum robot steering speed
        ROT_PENALTY         % Distance penalty for rotation
        reach_cloud         % Stores reachable positions and orientations of the robot
        tree                % Array stores pose information of tree nodes (x,y,theta,phi)
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
        function this = RRT3D(rand_seed, max_nodes, map, conf)
            rng(rand_seed);
            this.map = map;
            this.R = conf.R;
            this.W = conf.W;
            this.L = conf.L;
            this.DRIVE_SPEED = conf.DRIVE_SPEED;
            this.MAX_STEER = conf.MAX_STEER;
            this.MAX_STEER_SPEED = conf.MAX_STEER_SPEED;
            this.ROT_PENALTY = conf.ROT_PENALTY;
            this.reach_cloud = zeros(3, 6561);
            this.tree = zeros(4, max_nodes);
            this.parent = zeros(1, max_nodes);
            this.children = zeros(1, max_nodes);
            this.free_nodes = zeros(1, max_nodes);
            this.free_nodes_ind = 1;
            this.cost = zeros(1, max_nodes);
            this.cumcost = zeros(1,max_nodes);
            this.XY_BOUNDARY = [0; size(map,1); 0; size(map,2)];
            this.tree(:, 1) = conf.start_pose; % Start position
            this.goal_point = conf.goal_point;
            this.delta_goal_point = conf.delta_goal_point;
            this.delta_near = conf.delta_near;
            this.nodes_added = uint32(1);
            this.best_path_node = -1;
            this.goal_reached = false;
            %%% temp var-s initialization
            this.compare_table = zeros(1, max_nodes);
            this.index = zeros(1, max_nodes);
            this.list = 1:max_nodes;
            this.num_rewired = 0;
        end
        
        % ==============================================================
        % RRT FUNCTIONS
        % ==============================================================
        
        % Antonized
        % Generate and return random (x,y,theta) point in the environment.
        function position = sample(this)
            position = [this.XY_BOUNDARY(2); this.XY_BOUNDARY(4); 2*pi] .* rand(3,1);
        end
        
        % Antonized
        % Find the nearest node to the given node using the (x,y) Euclidian
        % distance, plus a weight on the rotation distance. 
        function node_index = nearest(this, new_node)
            this.compare_table(1:(this.nodes_added)) = sum((this.tree(1:2, 1:(this.nodes_added)) - repmat(new_node(1:2),1,this.nodes_added)).^2) ...
                                                        + (this.ROT_PENALTY*(this.tree(3, 1:this.nodes_added) - new_node(3))).^2;
            [this.compare_table(1:(this.nodes_added)), this.index(1:(this.nodes_added))] = sort(this.compare_table(1:(this.nodes_added)));
            node_index = this.index(1);
            return;
        end
        
        % Antonized
        % Generate random steering speed and apply kinematic model to 
        % produce new position given 1s of drive time. Since we're incrementally
        % travelling through the map, check for collisions at this point.
        function [collision_free, pose] = steer(this, nearest_node_ind)
        
			v_phi = -this.MAX_STEER_SPEED + (2*this.MAX_STEER_SPEED) * rand(1,1);
			pose = this.tree(:, nearest_node_ind);
			input = [this.DRIVE_SPEED; v_phi];
			hit_max_angle = false;
			collision_free = true;
			
			% Runge-Kutta integration:
			dt = 0.5;    % timestep for integration
            time = 5;    % seconds to drive
			for i = 1:(time/dt)
				% check for collisions first. Check for a box of size (L+W)^2 around
				% the centre of the robot.
				Cx = round(pose(1) + cos(pose(3))/(0.5*this.L));
				Cy = round(pose(2) + sin(pose(3))/(0.5*this.L));
                xmin = max(round(Cx-this.L-this.W), 1);
                xmax = min(round(Cx+this.L+this.W), this.XY_BOUNDARY(2));
                ymin = max(round(Cy-this.L-this.W), 1);
                ymax = min(round(Cy+this.L+this.W), this.XY_BOUNDARY(4));
				robot = this.map(xmin:xmax, ymin:ymax);
				if any(any(robot))
					collision_free = false;
					return;
				end
			
				% stop steering if we've hit maximum steering angle
				if (~hit_max_angle && (pose(4) > this.MAX_STEER || pose(4) < -this.MAX_STEER))
				    input = [this.DRIVE_SPEED; 0];
				    hit_max_angle = true;
                end
				
				w1 = this.calc_q_dot(pose, input);
				w2 = this.calc_q_dot(pose + dt/2*w1, input);
				w3 = this.calc_q_dot(pose + dt/2*w2, input);
				w4 = this.calc_q_dot(pose + dt*w3, input);
				
				pose = pose + dt/6 * (w1 + w2 + w3 + w4);
                pose(4) = min(pose(4),this.MAX_STEER);
                pose(4) = max(pose(4),-this.MAX_STEER);
                
                if pose(1) < 0 || pose(1) > this.XY_BOUNDARY(2) || pose(2) < 0 || pose(2) > this.XY_BOUNDARY(4)
                    collision_free = false;
                    return;
                end
            end
            
			pose(1:2) = round(pose(1:2));
            pose(3) = mod(pose(3) + 2*pi, 2*pi);
        end
        
        % Antonized
        % Bicycle Model kinematics, straight from Barfoot's lecture
        function q_dot = calc_q_dot(this, q, p)
			Gq = [cos(q(3)) 0; sin(q(3)) 0; tan(q(4))/this.L 0; 0 1];
			q_dot = Gq * p;
        end
        
        % Antonized
        % Insert new node into the tree. 
        function new_node_ind = insert_node(this, parent_node_ind, new_node_pose)
            % method insert new node in the tree
            this.nodes_added = this.nodes_added + 1;
            this.tree(:, this.nodes_added) = new_node_pose;         % adding new node position 
            this.parent(this.nodes_added) = parent_node_ind;        % adding new node parent-children info
            this.children(parent_node_ind) = this.children(parent_node_ind) + 1;
            this.cost(this.nodes_added) = this.Euclidean_dist(this.tree(:, parent_node_ind), new_node_pose);    % not that important
            this.cumcost(this.nodes_added) = this.cumcost(parent_node_ind) + this.cost(this.nodes_added);   			% cummulative cost
            new_node_ind = this.nodes_added;
        end
        
        % ==============================================================
        % RRT* FUNCTIONS
        % ==============================================================
        
        % Antonized
        % Return indices of nodes that are within a given radius of the new node.
        function neighbor_nodes = neighbors(this, new_node_pose)
            % seeks for neighbors and returns indices of neighboring nodes
            radius = this.delta_near;
            this.compare_table(1:(this.nodes_added)) = sum((this.tree(1:2, 1:(this.nodes_added)) - repmat(new_node_pose(1:2),1,this.nodes_added)).^2);
            [this.compare_table(1:(this.nodes_added)), this.index(1:(this.nodes_added))] = sort(this.compare_table(1:(this.nodes_added)));
            temp = this.index((this.compare_table(1:(this.nodes_added)) <= radius^2) & (this.compare_table(1:(this.nodes_added)) > 0 ));
            % neighbor_nodes = setdiff(temp, nearest_node_ind);
            neighbor_nodes = temp;
        end
        
        % Antonized
        % Choose which of the neighbor nodes has the minimal cumulative
        % cost from the root of the tree. 
        function min_node_ind = chooseParent(this, neighbors, nearest_node_ind, new_node_position)
            min_node_ind = nearest_node_ind;
            min_cumcost = this.cumcost(nearest_node_ind) + this.Euclidean_dist(this.tree(:, nearest_node_ind), new_node_position);
            for ind=1:numel(neighbors)
                temp_cumcost = this.cumcost(neighbors(ind)) + this.Euclidean_dist(this.tree(:, neighbors(ind)), new_node_position);
                if temp_cumcost < min_cumcost
                    min_cumcost = temp_cumcost;
                    min_node_ind = neighbors(ind);
                end
            end
        end
        
        % Antonized
        % Look through all neighbors (excl. the min_node_ind) and rewire
        % if there is now a cheaper path for them. 
        function rewire(this, new_node_ind, neighbors, min_node_ind)
            for ind = 1:numel(neighbors)
                % excl. the min_node_ind
                if (neighbors(ind) == min_node_ind)
                    continue;
                end
                temp_cost = this.cumcost(new_node_ind) + this.Euclidean_dist(this.tree(:, neighbors(ind)), this.tree(:, new_node_ind));
                if (temp_cost < this.cumcost(neighbors(ind)))
                    this.cumcost(neighbors(ind)) = temp_cost;
                    this.children(this.parent(neighbors(ind))) = this.children(this.parent(neighbors(ind))) - 1;
                    this.parent(neighbors(ind)) = new_node_ind;
                    this.children(new_node_ind) = this.children(new_node_ind) + 1;
                    this.num_rewired = this.num_rewired + 1;
                end
            end
        end
        
        % ==============================================================
        % RRT*FN FUNCTIONS
        % ==============================================================
        
        % Antonized
        % Find the current best path to the goal.
        function best_path_evaluate(this)
            % finding all the point which are in the desired region
            distances = zeros(this.nodes_added, 2);
            distances(:, 1) = sum((this.tree(1:2,1:(this.nodes_added)) - repmat(this.goal_point', 1, this.nodes_added)).^2);
            distances(:, 2) = 1:this.nodes_added;
            distances = sortrows(distances, 1);
            distances(:, 1) = distances(:, 1) <= (this.delta_goal_point ^ 2);
            dist_index = numel(find(distances(:, 1) == 1));
            % find the cheapest path
            if(dist_index ~= 0)
                distances(:, 1) = this.cumcost(int32(distances(:, 2)));
                distances = distances(1:dist_index, :);
                distances = sortrows(distances, 1);
                nearest_node_index = distances(1,2);
                this.goal_reached = true;
            else
                nearest_node_index = distances(1,2);
                if this.goal_reached
                    disp('VERY BAD THING HAS HAPPENED');
                end
                this.goal_reached = false;
            end
            this.best_path_node = nearest_node_index;
        end
        
        % Antonized
        % Remove a node because we've hit our max. Choose one at random 
        % that has no children (and therefore isn't useful).
        function forced_removal(this)
            candidate = this.list(this.children(1:(this.nodes_added)) == 0);
            node_to_remove = candidate(randi(numel(candidate)));
            while node_to_remove == this.best_path_node
                node_to_remove = candidate(randi(numel(candidate)));
            end
            this.children(this.parent(node_to_remove)) = this.children(this.parent(node_to_remove)) - 1;
            this.parent(node_to_remove) = -1;
            this.tree(:, node_to_remove) = [intmax; intmax; intmax; intmax];
            this.free_nodes(this.free_nodes_ind) = node_to_remove;
            this.free_nodes_ind = this.free_nodes_ind + 1;
        end
        
        % Antonized
        % Replace an existing 'free' node with the new pose. 
        function reused_node_ind = reuse_node(this, nearest_node, new_node_pose)
            % method inserts new node instead of the removed one.
            if(this.free_nodes_ind == 1)
                disp('ERROR: Cannot find any free node!!!');
                return;
            end
            this.free_nodes_ind = this.free_nodes_ind - 1;
            reused_node_ind = this.free_nodes(this.free_nodes_ind);
            this.tree(:, reused_node_ind) = new_node_pose;
            this.parent(reused_node_ind) = nearest_node;
            this.children(nearest_node) = this.children(nearest_node) + 1;
            this.cost(reused_node_ind) = this.Euclidean_dist(this.tree(:, nearest_node), new_node_pose);
            this.cumcost(reused_node_ind) = this.cumcost(nearest_node) + this.cost(reused_node_ind);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        function path = return_path(this)
            distances = zeros(this.nodes_added, 2);
            distances(:, 1) = sum((this.tree(1:2,1:(this.nodes_added)) - repmat(this.goal_point', 1, this.nodes_added)).^2);
            distances(:, 2) = 1:this.nodes_added;
            distances = sortrows(distances, 1);
            distances(:, 1) = distances(:, 1) <= this.delta_goal_point ^ 2;
            dist_index = numel(find(distances(:, 1) == 1));
            % find the cheapest path
            if(dist_index ~= 0)
                distances(:, 1) = this.cumcost(int32(distances(:, 2)));
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
            path = zeros(4,1);
            while(current_index ~= 1)
                path(:,path_iter) = this.tree(:,current_index);
                path_iter = path_iter + 1;
                current_index = this.parent(current_index);
            end
            path(:,path_iter) = this.tree(:,current_index);
        end
        
        
        function plot(this)
            %%% Find the optimal path to the goal
            % finding all the point which are in the desired region
            distances = zeros(this.nodes_added, 2);
            distances(:, 1) = sum((this.tree(1:2,1:(this.nodes_added)) - repmat(this.goal_point', 1, this.nodes_added)).^2);
            distances(:, 2) = 1:this.nodes_added;
            distances = sortrows(distances, 1);
            distances(:, 1) = distances(:, 1) <= this.delta_goal_point ^ 2;
            dist_index = numel(find(distances(:, 1) == 1));
            % find the cheapest path
            if(dist_index ~= 0)
                distances(:, 1) = this.cumcost(int32(distances(:, 2)));
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
                current_index = this.parent(current_index);
            end
            backtrace_path(path_iter) = current_index;
            close all;
            figure;
            set(gcf(), 'Renderer', 'opengl');
            hold on;
            % obstacle drawing
            %for k = 1:this.obstacle.num
            %    p2 = fill(this.obstacle.output{k}(1:end, 1), this.obstacle.output{k}(1:end, 2), 'r');
            %    set(p2,'HandleVisibility','off','EdgeAlpha',0);
            %end
            
            drawn_nodes = zeros(1, this.nodes_added);
            for ind = this.nodes_added:-1:1;
                if(sum(this.free_nodes(1:this.free_nodes_ind) == ind)>0)
                    continue;
                end
                current_index = ind;
                while(current_index ~= 1 && current_index ~= -1)
                    % avoid drawing same nodes twice or more times
                    if(drawn_nodes(current_index) == false || drawn_nodes(this.parent(current_index)) == false)
                        plot([this.tree(1,current_index);this.tree(1, this.parent(current_index))], ...
                            [this.tree(2, current_index);this.tree(2, this.parent(current_index))],'g-','LineWidth', 0.5);
%                         plot([this.tree(1,current_index);this.tree(1, this.parent(current_index))], ...
%                             [this.tree(2, current_index);this.tree(2, this.parent(current_index))],'+k');
                        drawn_nodes(current_index) = true;
                        
                    end
                    current_index = this.parent(current_index);
                end
            end
            
%             for ind = this.nodes_added:-1:1
%                 this.plot_circle(this.tree(1,ind),this.tree(2,ind),1);
%             end
            
            plot(this.tree(1,backtrace_path), this.tree(2,backtrace_path),'*b-','LineWidth', 2);
            
            plot([this.tree(1,backtrace_path) + cosd(this.tree(3,backtrace_path)*360/pi)*this.L + sind(this.tree(3,backtrace_path)*360/pi)*this.W; this.tree(1,backtrace_path) + cosd(this.tree(3,backtrace_path)*360/pi)*this.L - sind(this.tree(3,backtrace_path)*360/pi)*this.W; ...
                this.tree(1,backtrace_path) - cosd(this.tree(3,backtrace_path)*360/pi)*this.L - sind(this.tree(3,backtrace_path)*360/pi)*this.W;  this.tree(1,backtrace_path) - cosd(this.tree(3,backtrace_path)*360/pi)*this.L + sind(this.tree(3,backtrace_path)*360/pi)*this.W; ...
                this.tree(1,backtrace_path) + cosd(this.tree(3,backtrace_path)*360/pi)*this.L + sind(this.tree(3,backtrace_path)*360/pi)*this.W], ...
                [this.tree(2,backtrace_path) + sind(this.tree(3,backtrace_path)*360/pi)*this.L - cosd(this.tree(3,backtrace_path)*360/pi)*this.W; this.tree(2, backtrace_path) + sind(this.tree(3,backtrace_path)*360/pi)*this.L + cosd(this.tree(3,backtrace_path)*360/pi)*this.W; ...
                this.tree(2, backtrace_path) - sind(this.tree(3,backtrace_path)*360/pi)*this.L + cosd(this.tree(3,backtrace_path)*360/pi)*this.W; this.tree(2, backtrace_path) - sind(this.tree(3,backtrace_path)*360/pi)*this.L - cosd(this.tree(3,backtrace_path)*360/pi)*this.W; ...
                this.tree(2,backtrace_path) + sind(this.tree(3,backtrace_path)*360/pi)*this.L - cosd(this.tree(3,backtrace_path)*360/pi)*this.W], 'm', 'LineWidth', 2);
            
            this.plot_circle(this.goal_point(1), this.goal_point(2), this.delta_goal_point);
            axis(this.XY_BOUNDARY);
            grid on;
            axis equal;
            disp(num2str(this.cumcost(backtrace_path(1))));
        end
        
        function newObj = copyobj(thisObj)
            % Construct a new object based on a deep copy of the current
            % object of this class by copying properties over.
            props = properties(thisObj);
            for i = 1:length(props)
                % Use Dynamic Expressions to copy the required property.
                % For more info on usage of Dynamic Expressions, refer to
                % the section "Creating Field Names Dynamically" in:
                % web([docroot '/techdoc/matlab_prog/br04bw6-38.html#br1v5a9-1'])
                newObj.(props{i}) = thisObj.(props{i});
            end
        end
        
        function print_tree(this,ind)
            disp(this.tree(:,1:ind));
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
    end
end