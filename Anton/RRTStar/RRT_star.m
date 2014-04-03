function path = RRT_star(map, start, goal, params)
% RRT* is a new variant of the RRT* algorithm that limits the number 
% of nodes in the tree in order to decrease memory utilization. 
% Based on code by Olzhas Adiyatov 05/26/2013.
%
%     map         - occupancy grid of environment
%     start       - [x,y,theta] robot pose
%     goal		  - [x,y] positions specifying goal point

    params.start_pose = start;          % Robot start pose.
    params.goal_point = goal;           % Goal position [x,y]
    
    problem = RRT3D(map, params);
	
    h = waitbar(0, 'RRT planning...');
    
	%%% Starting a timer
	tic;
	for ind = 1:params.RRT_MAX_ITER
		waitbar(ind / params.RRT_MAX_ITER);
        
		% Generate a random node
		new_node = problem.sample(ind);
        %fprintf('new node: [%.2f, %.2f]\n',new_node(1), new_node(2));
        
		% Find the nearest existing node to the random node
		nearest_node_ind = problem.nearest(new_node);
        %fprintf('nearest index: %d\n', nearest_node_ind);

		% Calculate how we would steer from the nearest node to get to the
		% new node.
		steer_inputs = problem.steer(nearest_node_ind, new_node);
        
        % Check whether the steering is a valid trajectory.
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

        if (new_node == goal')
            if valid
                fprintf('goal chosen, valid steering.\n');
            end
        end

        % efficiency shortcut: terminate early if the very first node (goal
        % node) has a valid path to it.
        if (ind == 1 && valid), break; end;
        
        % terminate if we've hit the maximum number of nodes.
        if (problem.nodes_added == params.RRT_MAX_NODES), break; end;
	end
    
    close(h);
 
    path = problem.return_path();
   
%     problem.plot();
    
end
