function problem = rrt_star_fn(map, start, goal)
% RRT*FN is a new variant of the RRT* algorithm that limits the number 
% of nodes in the tree in order to decrease memory utilization. 
% Based on code by Olzhas Adiyatov 05/26/2013.
%
%     map         - occupancy grid of environment
%     start       - [x,y,theta,phi] robot pose
%     goal		  - [x,y] positions specifying goal point


	clear all;
    close all;
    clc;
    
    RAND_SEED    = 1;
    MAX_ITER     = 30e3;
    MAX_NODES    = 4001;
    MAP          = map; 

	conf = struct;
	conf.delta_goal_point = 10;         % Radius of around goal that we consider acceptable.
	conf.delta_near = 5;                % Radius for neighboring nodes
	conf.R = 2.5;						% Radius of a wheel = 2.5cm
	conf.W = 10; 						% Width of robot = 10cm
	conf.L = 17;						% Length of robot = 17cm
	conf.DRIVE_SPEED = 20;				% Assumed driving speed for path planning.
	conf.MAX_STEER = 0.6; 				% Max steering angle is 35 degrees.
	conf.MAX_STEER_SPEED = 20;			% Max steering speed is 20.
	conf.start_pose = start;            % Robot start pose.
	
	problem = RRT3D(RAND_SEED, MAX_NODES, map, conf);
	
	%%% Starting a timer
	tic;
	for ind = 1:MAX_ITER
		
		% Generate a random node
		new_node = problem.sample();
		% Find the nearest existing node to the random node
		nearest_node_ind = problem.nearest(new_node);
		% Get new node via random steering from nearest node
		[collision_free, new_node] = problem.steer(nearest_node_ind);
		if(collision_free)
			% Find all neighbors in a ball around the new node
			neighbors = problem.neighbors(new_node);
			if (numel(neighbors) == 0) 
				%this expression will show us that something is completely wrong
				%disp([' no neighbors detected at ' num2str(ind)]);
			end
			% Find the neighbour that has the cheapest cost to come.
			min_node = problem.chooseParent(neighbors, nearest_node_ind, new_node);
			if (problem.nodes_added == MAX_NODES)
				% If at node capacity, reuse an existing node.
				new_node_ind = problem.reuse_node(min_node, new_node);
			else
				% Otherwise, add a new node to the tree.
				new_node_ind = problem.insert_node(min_node, new_node);
			end
			% Look through all the neighbors and re-wire if there's a better path.
			problem.rewire(new_node_ind, neighbors, min_node);
			% If we were at capacity, remove one node from the tree.
			if (problem.nodes_added == MAX_NODES)
				problem.best_path_evaluate();
				problem.forced_removal();
			end
		end
		
		% display progress each 100 iterations
		if(mod(ind, 100) == 0)
			disp([num2str(ind) ' iterations ' num2str(problem.nodes_added-1) ' nodes in ' num2str(toc) ' rewired ' num2str(problem.num_rewired)]);
		end
	end

	problem.plot();
end
