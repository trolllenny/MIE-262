
# WARP Shoe Company Optimization Model (MIE262)

# Define Sets
set p; # set of shoe types
set m; # set of machine types
set r; # set of raw materials
set w; # set of warehouses

# Define Parameters

param P{p}; # P_p
param D{p}; # D_p
param t{p,m} default 0; # in seconds, t_pm: in seconds required to produce one unit of shoe p on machine m
param rm_cost{R}; # c_r
param rm_avail{R}; # Q_r
param bom{P,R} default 0; # q_pr
param warehouse_cap{W}; # W_cap
param wh_op_cost{W}; # c_w
param machine_capacity_min{m in M} :=20160
param labour_cost := 25;
param mach_op_min{M}

# Define Variables

var x{P} >= 0, integer; #production qty
var y{W] binary; # 1 = warehouse used, 0 not used

# Objective Function

maximize Profit:
	(sum{p in P} price[p]*x[p])
- 	(sum{p in P},{m in M}


# Define Constraints