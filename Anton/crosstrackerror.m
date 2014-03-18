function cte = crosstrackerror(pose, from_node, to_node)
    % if moving virtually straight, compute straight line distance to
    % nearest point
    
    % if moving in an arc, compute center of the circle, get desired radius
    % of circle, compute current distance to center of the circle, the
    % difference btween the two is our CTE.
    cte = 1;
end
