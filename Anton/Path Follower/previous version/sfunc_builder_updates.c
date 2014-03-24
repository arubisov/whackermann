int    i;               /* counter dummy variable */  

int    path_ind;        /* value of xD[0] */
double prev_dist_to;    /* value of xD[0] */
double from_node[6];    /* 1-dim C array */
double to_node[6];      /* 1-dim C array */
double dist_to;         /* distance to the target node */
int    reached_path_end;  /* boolean: whether we've reached the path end */ 

if (exec_path[0] == 0) {
    /* reset internal states */
    xD[0] = 0;
    xD[1] = 99999;
    xD[2] = 0;
    return;
}

path_ind = xD[0];
prev_dist_to = xD[1];

/* copy the nodes from the path */
for (i=0; i<6; i++) {
    from_node[i] = path[path_ind*6 + i];
    to_node[i] = path[(path_ind+1)*6 + i];
}

/* check that we haven't yet passed the destination waypoint */
dist_to = sqrt( (to_node[0]-pose[0])*(to_node[0]-pose[0]) + (to_node[1]-pose[1])*(to_node[1]-pose[1]) );

if (dist_to > prev_dist_to) {
    path_ind = path_ind + 1;
    xD[0] = path_ind;      /* increment path index */
    xD[1] = 99999;          /* reset dist_to_next */
    
    reached_path_end = 1;
    /* check whether we've reached the end of the path */
    for (i=0; i<6; i++) {
        if (path[path_ind*6 + i] != 0) {
            reached_path_end = 0;
            break;
        }
    }
    
    if (reached_path_end == 1 || path_ind == 19) {
        xD[2] = 1;
    }
    
    return;
} else {
    xD[1] = dist_to;        /* overwrite dist_to_next */
    return;
}