int    i;               /* counter dummy variable */    
    
double from_node[6];    /* 1-dim C array */
double to_node[6];      /* 1-dim C array */
int    path_index;      /* xD[0], the first discrete state variable */
double prev_dist_to;    /* xD[1], the second discrete state variable */
double dist_to;         /* distance to the target node */
int    direction;       /* travelling direction, 1 for forward, -1 for backward */
double theta;           /* orientation of vehicle */
double theta_path;      /* orientation of nearest path point */ 
double theta_err;       /* orientation error */
double cte;             /* cross-track error */
double k;               /* gain parameter for steering control law */

/* FOR CTE CALCULATIONS */
double STRAIGHT_THRESH; /* threshold for assuming straight driving */
double ROBOT_LENGTH;    /* robot length */
double phi;             /* required steering angle */
double dist;            /* required driving distance between nodes */
double beta;            /* turning angle between nodes */
double radius;          /* turning radius */
double CX;              /* x-coord of centre of turning circle */
double CY;              /* y-coord of centre of turning circle */
double v_from[2];       /* vector between centre and from_node */
double v_to[2];         /* vector between centre and to_node */
double angle;           /* angle between v_from and v_to, ctr-clockwise from v_from to v_to */

if (exec_path[0] == 0) {
    steer_angle[0] = 0;
    drive_speed[0] = 0;
    return;
} else {
    /* Get the data */
    // path = (double *)mxGetData(path);
    path_index = xD[0];
    prev_dist_to = xD[1];

    /* copy the nodes from the path */
    for (i=0; i<6; i++) {
        from_node[i] = path[path_index*6 + i];
        to_node[i] = path[(path_index+1)*6 + i];
    }

    /* execute the FUCK out of this path. */

    /* set drive speed */
    direction = (to_node[3] > 0) ? 1 : -1;
    drive_speed[0] = direction * 20;

    /* Calculate the steering angle */

    /* Stanley Method from the DARPA Grand Challenge
     * 
     * Stanley method is a nonlinear feedback function of the cross track
     * error e_fa, measured from the centre of the front axle to the nearest
     * path point (cx, cy), for which exponential convergence can be shown.
     * Co-locating the point of control with the steered front wheels allows
     * for an intuitive control law, where the first term simply keeps the
     * wheels aligned with the given path by setting the steering angle
     * phi equal to the heading error:
     *          theta_err = theta - theta_path
     * where theta is the heading of the vehicle and theta_path is the
     * heading of the path at (cx, cy). When e_fa is non-zero, the second
     * term adjusts phi such that the intended trajectory intersects the
     * path tangent from (cx, cy) at k*v units from the front axle. The
     * resulting control law is given as
     *          phi = theta_err + atan(k*e_fa / v)
     * where k is a gain parameter and v is the vehicle's speed. As e_fa
     * increases, the wheels are steered further towards the path.
     *    Snider, Jarrod. Automatic Steering Methods for Autonomous
     *    Automobile Path Tracking. CMU-RI-TR-09-08 */

    theta = pose[2];

    /* Stanley Method from the DARPA Grand Challenge
    %
    %   The cross-track error cte(t) measures the lateral distance of the center of
    % the vehicle's front wheels from the nearest point on the trajectory. In
    % the absence of any lateral errors, the control law points the front
    % wheels parallel to the planner trajectory. 
    %   The basic steering angle control law is given by 
    %         delta(t) = psi(t) + arctan[k*cte(t) / u(t)]
    % where psi is the orientation of the nearest path point relative to the
    % vehicle's own orientation, k is a gain parameter, and u(t) is the speed
    % of the vehicle. The second term adjusts the steering in (nonlinear)
    % proportion to the cross-track error cte(t): the larger this error, the
    % stronger the steering response toward the trajectory.
    %   With this control law, the error converges exponentially to cte(t)=0,
    % and the parameter k determines the rate of convergence. 
    %%% Thrun et. al. Stanley: The Robot that Won the DARPA Grand Challenge */

    /* Cross-track error is calculated via standard orientation (right-hand rule). */
    STRAIGHT_THRESH = 0.025;
    ROBOT_LENGTH = 0.17;

    phi = to_node[4];
    dist = to_node[5];

    if (abs(phi) > STRAIGHT_THRESH) {
        /**************************************************************
         * Assume we're moving along an arc.
         * 
         * To get path orientation, instead of actually determining the
         * nearest point, simply get the angle between two vectors: 
         * vector between centre and from_node, and between centre and 
         * current pose.
         *
         * To get the cross-track error, since we're travelling in a 
         * circle of fixed radius, the CTE to the nearest point is just
         * equal to the distance from the centre minus the radius of
         * the circle.
         *************************************************************/

        beta = dist*tan(phi)/ROBOT_LENGTH;
        radius = dist/beta;

        CX = from_node[0] - sin(from_node[2]) * radius;                  
        CY = from_node[1] + cos(from_node[2]) * radius;

        v_from[0] = from_node[0]-CX;
        v_from[1] = from_node[1]-CY;
        v_to[0] = pose[0]-CX;
        v_to[1] = pose[1]-CY;

        angle = fmod(atan2(v_from[0]*v_to[1]-v_to[0]*v_from[1],v_from[0]*v_to[0]+v_from[1]*v_to[1]),2*M_PI);

        theta_path = fmod(from_node[2] + angle, 2*M_PI);
        cte = sqrt(v_to[0]*v_to[0] + v_to[1]*v_to[1]) - radius;

    } else {           
        /**************************************************************
         * Otherwise, we're moving virtually straight.
         *
         * If calculated as above, we would have beta=0 and radius=Inf.
         * 
         * In this case, the orientation of the path is the same as the
         * orientation of the from_node, and the cross-track error is
         * the perpendicular distance to that line. 
         *
         * http://mathworld.wolfram.com/Point-LineDistance2-Dimensional.html
         *************************************************************/
        theta_path = from_node[2];
        cte = ((to_node[0] - from_node[0])*(from_node[1] - pose[1]) - (from_node[0] - pose[0])*(to_node[1] - from_node[1])) / sqrt( (to_node[0]-from_node[0])*(to_node[0]-from_node[0]) + (to_node[1]-from_node[1])*(to_node[1]-from_node[1]) );
    }

    theta_err = theta - theta_path;
    k = 5.0;

    steer_angle[0] = theta_err - atan(k * cte / drive_speed[0]);

    mexPrintf("PATH FOLLOWER: vel=%.2f, steer=%.2f\n", drive_speed[0], steer_angle[0]);
        
}