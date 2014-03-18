function path = RRT_star(map, start, goal, params)
% RRT* is a new variant of the RRT* algorithm that limits the number 
% of nodes in the tree in order to decrease memory utilization. 
% Based on code by Olzhas Adiyatov 05/26/2013.
%
%     map         - occupancy grid of environment
%     start       - [x,y,theta] robot pose
%     goal		  - [x,y] positions specifying goal point

    RAND_SEED = 3;
    MAX_ITER  = 5000;
    MAX_NODES = 4000;

    params.start_pose = start;          % Robot start pose.
    params.goal_point = goal;           % Goal position [x,y]
    params.delta_goal_point = 2;        % Radius of goal position region
    params.delta_near = 20;             % Radius for neighboring nodes
    
    problem = RRT3D(RAND_SEED, MAX_NODES, map, params);
	
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
        
        if (problem.nodes_added == MAX_NODES)
            break;
        end
	end
 
    path = problem.return_path();
    disp(path);
    %problem.plot();
    
end
