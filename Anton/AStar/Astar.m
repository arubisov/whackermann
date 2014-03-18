function Optimal_path = Astar(world, start, goal)
    
    MAX_ROW = size(world, 1);
    MAX_COL = size(world, 2);
    rGoal = goal(1);     %X Coordinate of the Target
    cGoal = goal(2);     %Y Coordinate of the Target
    rStart = start(1);   %Starting Position
    cStart = start(2);   %Starting Position
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LISTS USED FOR ALGORITHM
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %OPEN LIST STRUCTURE
    %--------------------------------------------------------------------------
    %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
    %--------------------------------------------------------------------------
    OPEN = [];
    %CLOSED LIST STRUCTURE
    %--------------
    %X val | Y val |
    %--------------
    % CLOSED=zeros(MAX_VAL,2);
    CLOSED = [];

    %Put all obstacles on the Closed list
    k = 1;  %Dummy counter
    for i = 1:MAX_ROW
        for j = 1:MAX_COL
            if (world(i,j) == 1)
                CLOSED(k,1) = i; 
                CLOSED(k,2) = j; 
                k=k+1;
            end
        end
    end
    CLOSED_COUNT = size(CLOSED,1);
    
    %set the starting node as the first node
    rNode = rStart;
    cNode = cStart;
    OPEN_COUNT = 1;
    path_cost = 0;
    
    goal_distance = euclid_dist(rNode, cNode, rGoal, cGoal);
    OPEN(OPEN_COUNT, :) = insert_open(rNode, cNode, rNode, cNode, ...
                                  path_cost, goal_distance, goal_distance);
    OPEN(OPEN_COUNT, 1) = 0;
    CLOSED_COUNT = CLOSED_COUNT + 1;
    CLOSED(CLOSED_COUNT,1) = cNode;
    CLOSED(CLOSED_COUNT,2) = rNode;
    NoPath = 1;
    
    %======================================================================
    % Begin A*
    %======================================================================
    while((rNode ~= rGoal || cNode ~= cGoal) && NoPath == 1)
    
        exp_array = expand_array(rNode,cNode,path_cost,rGoal,cGoal,CLOSED,MAX_ROW,MAX_COL);
        exp_count = size(exp_array,1);
        %UPDATE LIST OPEN WITH THE SUCCESSOR NODES
        %OPEN LIST FORMAT
        %--------------------------------------------------------------------------
        %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
        %--------------------------------------------------------------------------
        %EXPANDED ARRAY FORMAT
        %--------------------------------
        %|X val |Y val ||h(n) |g(n)|f(n)|
        %--------------------------------
        for i = 1:exp_count
            flag = 0;
                for j = 1:OPEN_COUNT
                    if (exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3))
                        OPEN(j,8) = min(OPEN(j,8),exp_array(i,5)); %#ok<*SAGROW>
                        if OPEN(j,8)== exp_array(i,5)
                            %UPDATE PARENTS,gn,hn
                            OPEN(j,4) = rNode;
                            OPEN(j,5) = cNode;
                            OPEN(j,6) = exp_array(i,3);
                            OPEN(j,7) = exp_array(i,4);
                        end %End of minimum fn check
                        flag = 1;
                    end %End of node check
                end %End of j for
                if flag == 0
                    OPEN_COUNT = OPEN_COUNT+1;
                    OPEN(OPEN_COUNT,:) = insert_open(exp_array(i,1),exp_array(i,2),rNode,cNode,exp_array(i,3),exp_array(i,4),exp_array(i,5));
                end    %End of insert new element into the OPEN list
        end     %End of i for

        %Find out the node with the smallest fn 
        index_min_node = min_fn(OPEN,OPEN_COUNT,rGoal,cGoal);
        if (index_min_node ~= -1)    
            %Set xNode and yNode to the node with minimum fn
            rNode = OPEN(index_min_node,2);
            cNode = OPEN(index_min_node,3);
            path_cost = OPEN(index_min_node,6); %Update the cost of reaching the parent node
            %Move the Node to list CLOSED
            CLOSED_COUNT = CLOSED_COUNT+1;
            CLOSED(CLOSED_COUNT,1) = rNode;
            CLOSED(CLOSED_COUNT,2) = cNode;
            OPEN(index_min_node,1) = 0;
        else
            NoPath = 0;     %No path exists to target, exit the search.
        end
    end
    
    %======================================================================
    % A* has finished, now reverse engineer the path.
    %======================================================================
    
    i = size(CLOSED,1);
    Optimal_path = [];
    row = CLOSED(i,1);
    col = CLOSED(i,2);
    i = 1;
    Optimal_path(i,1) = row;
    Optimal_path(i,2) = col;
    i = i+1;

    if ((row == rGoal) && (col == cGoal))
        inode = 0;
        %Traverse OPEN and determine the parent nodes
        parent_r = OPEN(node_index(OPEN,row,col),4);%node_index returns the index of the node
        parent_c = OPEN(node_index(OPEN,row,col),5);

        while( parent_r ~= rStart || parent_c ~= cStart)
            Optimal_path(i,1) = parent_r;
            Optimal_path(i,2) = parent_c;
            %Get the grandparents:-)
            inode = node_index(OPEN,parent_r,parent_c);
            parent_r = OPEN(inode,4);%node_index returns the index of the node
            parent_c = OPEN(inode,5);
            i = i+1;
        end
    end
end

function dist = euclid_dist(x1, y1, x2, y2)
    dist = sqrt((x2-x1)^2 + (y2-y1)^2);
end

function new_row = insert_open(xval, yval, parent_xval, parent_yval, hn, gn, fn)
%Function to Populate the OPEN LIST
%OPEN LIST FORMAT
%--------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%-------------------------------------------------------------------------
    new_row=[1,8];
    new_row(1,1) = 1;
    new_row(1,2) = xval;
    new_row(1,3) = yval;
    new_row(1,4) = parent_xval;
    new_row(1,5) = parent_yval;
    new_row(1,6) = hn;
    new_row(1,7) = gn;
    new_row(1,8) = fn;
end

function exp_array=expand_array(node_x,node_y,hn,xTarget,yTarget,CLOSED,MAX_X,MAX_Y)
    %Function to return an expanded array
    %This function takes a node and returns the expanded list
    %of successors,with the calculated fn values.
    %The criteria being none of the successors are on the CLOSED list.
    %
    %   Copyright 2009-2010 The MathWorks, Inc.
    
    exp_array=[];
    exp_count=1;
    c2=size(CLOSED,1);%Number of elements in CLOSED including the zeros
    for k= 1:-1:-1
        for j= 1:-1:-1
            if (k~=j || k~=0)  %The node itself is not its successor
                s_x = node_x+k;
                s_y = node_y+j;
                if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y))%node within array bound
                    flag=1;                    
                    for c1=1:c2
                        if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2))
                            flag=0;
                        end;
                    end;%End of for loop to check if a successor is on closed list.
                    if (flag == 1)
                        exp_array(exp_count,1) = s_x;
                        exp_array(exp_count,2) = s_y;
                        exp_array(exp_count,3) = hn+euclid_dist(node_x,node_y,s_x,s_y);%cost of travelling to node
                        exp_array(exp_count,4) = euclid_dist(xTarget,yTarget,s_x,s_y);%distance between node and goal
                        exp_array(exp_count,5) = exp_array(exp_count,3)+exp_array(exp_count,4);%fn
                        exp_count=exp_count+1;
                    end%Populate the exp_array list!!!
                end% End of node within array bound
            end%End of if node is not its own successor loop
        end%End of j for loop
    end%End of k for loop    
end

function n_index = node_index(OPEN,xval,yval)
    i=1;
    while(OPEN(i,2) ~= xval || OPEN(i,3) ~= yval )
        i=i+1;
    end
    n_index=i;
end

function i_min = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget)
    %Function to return the Node with minimum fn
    % This function takes the list OPEN as its input and returns the index of the
    % node that has the least cost
    %
    %   Copyright 2009-2010 The MathWorks, Inc.

    temp_array=[];
    k=1;
    flag=0;
    goal_index=0;
    for j=1:OPEN_COUNT
        if (OPEN(j,1)==1)
            temp_array(k,:)=[OPEN(j,:) j]; %#ok<*AGROW>
            if (OPEN(j,2)==xTarget && OPEN(j,3)==yTarget)
                flag=1;
                goal_index=j;%Store the index of the goal node
            end
            k=k+1;
        end
    end     %Get all nodes that are on the list open
    if flag == 1 % one of the successors is the goal node so send this node
        i_min=goal_index;
    end
    %Send the index of the smallest node
    if size(temp_array ~= 0)
        [min_fn,temp_min]=min(temp_array(:,8)); %Index of the smallest node in temp array
        i_min=temp_array(temp_min,9);   %Index of the smallest node in the OPEN array
    else
        i_min=-1;   %The temp_array is empty i.e No more paths are available.
    end
end