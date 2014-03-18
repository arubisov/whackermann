function path = rrt_star_fn(map, start, goal)
% RRT* is a new variant of the RRT* algorithm that limits the number 
% of nodes in the tree in order to decrease memory utilization. 
% Based on code by Olzhas Adiyatov 05/26/2013.
%
%     map         - occupancy grid of environment
%     start       - [x,y,theta] robot pose
%     goal		  - [x,y] positions specifying goal point


    RAND_SEED = 1;
    %MAX_ITER = 30e3;
    MAX_ITER  = 10000;

	conf = struct;
	conf.delta_goal_point = 2;          % Radius of goal position region
	conf.delta_near = 20;               % Radius for neighboring nodes
	conf.R = 2.5;						% Radius of a wheel = 2.5cm
	conf.W = 2; 						% Width of robot = 10cm
	conf.L = 5;                         % Length of robot = 17cm
	conf.DRIVE_SPEED = 5;				% Assumed driving speed for path planning.
	conf.MAX_STEER = 0.6; 				% Max steering angle is 35 degrees.
	conf.MAX_STEER_SPEED = 5;			% Max steering speed is 20.
    conf.ROT_PENALTY = 2;               % Distance penalty for rotation.
	conf.start_pose = start;            % Robot start pose.
    conf.goal_point = goal;             % Goal position [x,y]
  	
	problem = RRT3D(RAND_SEED, MAX_NODES, map, conf);
	
	%%% Starting a timer
	tic;
	for ind = 1:MAX_ITER
		
		% Generate a random node
		new_node = problem.sample();

		% Find the nearest existing node to the random node
		nearest_node_ind = problem.nearest(new_node);

		% Get new node via random steering from nearest node
		steer_inputs = problem.steer(nearest_node_ind, new_node);
        [valid, final_node] = problem.validate(nearest_node_ind, steer_inputs);
        
        if(valid)
            % Add a new node to the tree.
            new_node_ind = problem.insert_node(nearest_node_ind, final_node, steer_inputs);
            
            % Find all neighbors in a ball around the new node
			neighbors = problem.neighbors(new_node);
            
            if (numel(neighbors) > 0) 
                % Find the neighbour that has the cheapest cost to come.
                [min_node_ind, final_node] = problem.chooseParent(neighbors, nearest_node_ind, new_node_ind);
                
                % Look through all the neighbors and re-wire if there's a better path.
                problem.rewire(new_node_ind, neighbors, min_node_ind);
            end
        end
		
		% display progress each 100 iterations
		if(mod(ind, 100) == 0)
			disp([num2str(ind) ' iterations ' num2str(problem.nodes_added-1) ' nodes in ' num2str(toc) ' rewired ' num2str(problem.num_rewired)]);
            %problem.print_tree(ind);
		end
	end
 
    path = problem.return_path();
    
    problem.plot();
    
end
