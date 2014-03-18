%The last effort to create a proper RRT class.
classdef RRT_final < handle

    properties
        % RRT properties
        npoints           % number of points to find
        graph             % graph Object representing random nodes
        sim_time          % path simulation time
        delta_goal_point
        delta_near
        
        % map properties
        map               % occupancy grid
        start             % start point
        goal              % goal point
        xrange            % range of map in x coordinate: [xmin xmax]
        yrange            % range of map in y coordinate: [ymin ymax]
        
        % vehicle properties
        speed
        steermax
        vehicle
        R
        W
        L
    end

    methods

        function rrt = RRT_final(map, varargin)
        %RRT.RRT Create a RRT navigation object
        %
        % R = RRT.RRT(MAP, VEH, OPTIONS) is a rapidly exploring tree navigation
        % object for a region with obstacles defined by the map object MAP.
        %
        % Options::
        % 'npoints',N    Number of nodes in the tree
        % 'time',T       Period to simulate dynamic model toward random point
        % 'range',R      Specify rectangular bounds
        %                - R scalar; X: -R to +R, Y: -R to +R
        %                - R (1x2); X: -R(1) to +R(1), Y: -R(2) to +R(2)
        %                - R (1x4); X: R(1) to R(2), Y: R(3) to R(4)
        % 'goal',P       Goal position (1x2) or pose (1x3) in workspace
        % 'speed',S      Speed of vehicle [m/s] (default 1)
        % 'steermax',S   Maximum steer angle of vehicle [rad] (default 1.2)
        %
        % Notes::
        % - 'steermax' selects the range of steering angles that the vehicle will
        %   be asked to track.  If not given the steering angle range of the vehicle
        %   will be used.
        % - There is no check that the steering range or speed is within the limits
        %   of the vehicle object.
        %
        % Reference::
        % - Robotics, Vision & Control
        %   Peter Corke, Springer 2011.  p102.
        %
        % See also Vehicle.

            % invoke the superclass constructor
            % rrt = rrt@Navigation(varargin{:});
            
            rrt.map = map;

            rrt.graph = PGraph(3, 'distance', 'SE2');  % graph of points in SE(2)

            opt.npoints = 4000;
            opt.time = 0.5;
            opt.range = 5;
            opt.start = [1, 1, 1];
            opt.goal = [50, 50, 0];
            opt.steermax = 0.5032;
            opt.speed = 20;
            opt.delta_goal_point = 2;       % Radius of goal position region
            opt.delta_near = 5;             % Radius for neighboring nodes
            opt.R = 2.5;                    % Radius of a wheel = 2.5cm
            opt.W = 2; 						% Width of robot = 10cm
            opt.L = 5;						% Length of robot = 17cm
            
            [opt,args] = tb_optparse(opt, varargin);
            
            rrt.npoints = opt.npoints;
            rrt.sim_time = opt.time;
            rrt.xrange = [1 size(map,1)];
            rrt.yrange = [1 size(map,2)];
            rrt.steermax = opt.steermax;
            rrt.speed = opt.speed;
            rrt.start = opt.start;
            rrt.goal = opt.goal;
            rrt.delta_goal_point = opt.delta_goal_point;
            rrt.delta_near = opt.delta_near;
            rrt.R = opt.R;
            rrt.W = opt.W;
            rrt.L = opt.L;
        end

        function plan(rrt, varargin)
        %RRT.plan Create a rapidly exploring tree
        %
        % R.plan(OPTIONS) creates the tree roadmap by driving the vehicle
        % model toward random goal points.  The resulting graph is kept
        % within the object.
        %
        % Options::
        % 'goal',P        Goal pose (1x3)
        % 'progress'      If false, don't show the progress bar
        % 'samples'       Show samples
        %                 - '.' for each random point x_rand
        %                 - 'o' for the nearest point which is added to the tree
        %                 - red line for the best path

            opt.progress = true;
            opt.samples = false;
            opt.goal = [];
            
            opt = tb_optparse(opt, varargin);

            % build a graph over the free space
            rrt.graph.clear();

            % add the goal point as the first node
            rrt.graph.add_node(rrt.start);

            % graphics setup
            if opt.progress
                h = waitbar(0, 'RRT planning...');
            end

            for j=1:rrt.npoints       % build the tree
                if opt.progress
                    waitbar(j / rrt.npoints);
                end
                
                % Step 3
                % find random state x,y

                % pick a point not in obstacle
                while true
                    xy = rrt.randxy();  % get random coordinate (x,y)
                    try
                        if rrt.map(xy(1),xy(2)) == 0
                            break;
                        end
                    catch
                        continue
                    end
                end
                
                theta = rand(1,1)*2*pi;
                xrand = [xy, theta]';

                % Step 4
                % find the existing node closest in state space
                vnear = rrt.graph.closest(xrand);   % nearest vertex
                xnear = rrt.graph.coord(vnear);     % coord of nearest vertex

                % Step 5
                % figure how to drive the robot from xnear to xrand
                
                ntrials = 20;
                [best, collision_free] = rrt.bestpath(xnear, xrand, ntrials);
                
                if collision_free
                    xnew = best.path(:,best.k);

                    % Step 7,8
                    % add xnew to the graph, with an edge from xnear
                    v = rrt.graph.add_node(xnew);
                    rrt.graph.add_edge(vnear, v);
                    rrt.graph.setdata(v, best);
                end
            end

            if opt.progress
                close(h)
            end
        end

        function p_ = path(rrt, xstart, xgoal)
        %PRM.path Find a path between two points
        %
        % X = R.path(START, GOAL) finds a path (Nx3) from state START (1x3) 
        % to the GOAL (1x3).
        %
        % P.path(START, GOAL) as above but plots the path in 3D.  The nodes
        % are shown as circles and the line segments are blue for forward motion
        % and red for backward motion.
        %
        % Notes::
        % - The path starts at the vertex closest to the START state, and ends
        %   at the vertex closest to the GOAL state.  If the tree is sparse this
        %   might be a poor approximation to the desired start and end.

            g = rrt.graph;
            vstart = g.closest(xstart);
            vgoal = g.closest(xgoal);

            % find path through the graph using A* search
            path = g.Astar(vstart, vgoal);
            
            % concatenate the vehicle motion segments
            cpath = [];
            for i = 1:length(path)
                p = path(i);
                data = g.data(p);
                if ~isempty(data)
                    if i >= length(path) || g.edgedir(p, path(i+1)) > 0
                        cpath = [cpath data.path];
                    else
                        cpath = [cpath data.path(:,end:-1:1)];

                    end
                end
            end

            if nargout == 0
                % plot the path
                clf; hold on

                plot2(g.coord(path)', 'o');     % plot the node coordinates
                
                for i = 1:length(path)
                    p = path(i);
                    b = g.data(p);            % get path data for segment
                    
                    % draw segment with direction dependent color
                    if ~isempty(b)
                        % if the vertex has a path leading to it
                        
                        if i >= length(path) || g.edgedir(p, path(i+1)) > 0
                            % positive edge
                            %  draw from prev vertex to end of path
                            seg = [g.coord(path(i-1)) b.path]';
                        else
                            % negative edge
                            %  draw reverse path to next next vertex
                            seg = [  b.path(:,end:-1:1)  g.coord(path(i+1))]';
                        end
                        
                        if b.vel > 0
                            plot2(seg, 'b');
                        else
                            plot2(seg, 'r');
                        end
                    end
                end

                xlabel('x'); ylabel('y'); zlabel('\theta');
                grid
            else
                p_ = cpath';
            end
        end

        function plot(rrt, varargin)
        %RRT.plot Visualize navigation environment
        %
        % R.plot() displays the navigation tree in 3D.

            clf
            rrt.graph.plot('noedges', 'NodeSize', 6, 'NodeFaceColor', 'g', 'NodeEdgeColor', 'g', 'edges');

            hold on
            for i=2:rrt.graph.n
                b = rrt.graph.data(i);
                plot2(b.path(:,1:b.k)')
            end
            xlabel('x'); ylabel('y'); zlabel('\theta');
            grid; hold off
        end
% 
%         % required by abstract superclass
%         function next(rrt)
%         end

    end % methods


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    P R I V A T E    M E T H O D S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    methods (Access='protected')

        function [best, collision_free] = bestpath(rrt, x0, xg, N)

            % ANTON TODO: set the nocollision flag, change the
            % rrt.vehicle.run2 to be Runge Kutta integration instead.
            % everything else should work like a charm thereafter!
            
            % initial and final state as column vectors
            x0 = x0(:); xg = xg(:);

            best.d = Inf;
            collision_free = false;
            
            for i=1:N   % for multiple trials 
            
                %choose random direction of motion and random steer angle
                if rand(1,1) > 0.5
                    vel = rrt.speed;
                else
                    vel = -rrt.speed;
                end
                steer = -rrt.steermax + (i-1)/(N-1)*2*rrt.steermax;    % uniformly distributed
                
                % simulate motion of vehicle for this speed and steer angle which 
                % results in a path
                % x = rrt.vehicle.run2(rrt.sim_time, x0, vel, steer)';
                x = rrt.simforward(rrt.sim_time, x0, vel, steer);
                
                collision = rrt.checkcollision(x);
                
                if collision
                    continue
                end
                
                x = x';
                
                %% find point on the path closest to xg
                % distance of all path points from goal
                d = colnorm( [bsxfun(@minus, x(1:2,:), xg(1:2)); angdiff(x(3,:), xg(3))] );
                % the closest one
                [dmin,k] = min(d);

                % is it the best so far?
                if dmin < best.d
                    % yes it is!  save it and the inputs that led to it
                    collision_free = true;
                    best.d = dmin;
                    best.path = x;
                    best.steer = steer;
                    best.vel = vel;
                    best.k = k;
                end
            end 
        end
        
        % Runge-Kutta integration:
        function pose_hist = simforward(rrt, sim_time, x0, vel, steer)
            dt = 0.5;           % timestep for integration
            pose_hist = zeros(sim_time/dt, 3);
            
			pose = x0;
            pose(4) = steer;
			input = [vel; steer];
			
            for i=1:(sim_time/dt)
                w1 = rrt.calc_q_dot(pose, input);
                w2 = rrt.calc_q_dot(pose + dt/2*w1, input);
                w3 = rrt.calc_q_dot(pose + dt/2*w2, input);
                w4 = rrt.calc_q_dot(pose + dt*w3, input);
                pose = pose + dt/6 * (w1 + w2 + w3 + w4);
                pose_hist(i,:) = pose(1:3)';
            end
        end
        
        function collision = checkcollision(rrt, x)
            
            collision = false;

            %poses = [round(x(:,1)) round(x(:,2)) x(:,3)];
            poses = unique(round(x), 'rows');
            
            % check whether we've gone off the map.
            if min(poses(:,1)) < 1 || max(poses(:,1)) > rrt.xrange(2) || min(poses(:,2)) < 1 || max(poses(:,2)) > rrt.yrange(2)
                collision = true;
                return;
            end
            
            % check for collisions first. Check for a box of size L^2 around
            % the centre of the robot.
            centers = poses(:, 1:2) + [cos(poses(:,3))/(0.5*rrt.L) sin(poses(:,3))/(0.5*rrt.L)];
            
            % ranges: each row: [xmin xmax ymin ymax]
            ranges = [max(round(centers(:,1)-rrt.L/2), 1) min(round(centers(:,1)+rrt.L/2), rrt.xrange(2)) max(round(centers(:,2)-rrt.L/2), 1) min(round(centers(:,2)+rrt.L/2), rrt.yrange(2))];
 
            occgrid = rrt.map(ranges(:,1):ranges(:,2), ranges(:,3):ranges(:,4));

            if any(any(occgrid))
                collision = true;
                return;
            end
            
        end
        
        
        % Antonized
        % Bicycle Model kinematics, straight from Barfoot's lecture
        function q_dot = calc_q_dot(rrt, q, p)
			Gq = [cos(q(3)) 0; sin(q(3)) 0; tan(q(4))/rrt.L 0; 0 0];
			q_dot = Gq * p;
        end        
        

        % generate a random coordinate within the working region
        function xy = randxy(rrt)
            xyrand = rand(1,2);
            % pick the goal point with a 10% chance.
            if xyrand(1,1) < 0.1
                xy = rrt.goal(1:2);
            else
                xy = round(xyrand .* [rrt.xrange(2) rrt.yrange(2)]);
            end
        end

    end % private methods
end % class
