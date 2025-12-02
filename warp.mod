
# WARP Shoe Company Optimization Model (MIE262)

#define sets
set P;          # set of all products numbers(shoe types)
set M;          # set of all machines numbers
set R;          # set of all raw materials
set W;			# set of all warehouses

param price{P} >= 0; #assign a price for all shoes
param demand{P} >= 0; #assign a demand for all shoes

#assign a processing time for every shoe that in each machine 
param proc_time{P,M} >= 0 default 0; 

# effective cost per second of machine time (machine op cost + labour)
param mach_cost_sec{M} >= 0;

# raw material cost and availability to buy
param rm_cost{R} >= 0;
param rm_avail{R} >= 0;

# quantity of raw material r required per pair of product p
param bom{P,R} >= 0 default 0;

# warehouse capacity for each warehouse 
param warehouse_cap{W} >= 0;

# raw material budget (given in project)


# time capacity: machine seconds available in February
# param machine_capacity_sec{M} >= 0;

#operational cost for warehouse
param wh_op_cost{W} >=0;

param rm_budget := 10000000;

param machine_capacity_min{m in M} := 20160;

param labour_cost := 25; 

param mach_op_min{M}; # operating cost per minute

var x{P} >= 0, integer;   # production quantity (pairs)
var y{W} binary;   # 1 = warehouse used, 0 = not used

maximize Profit:
    (sum{p in P} price[p] * x[p]) #revenue
  - (sum{m in M, p in P} mach_op_min[m] * (proc_time[p,m] * x[p])/60) #cost to make shoes using machine. per second
  - (labour_cost*sum{m in M, p in P}(proc_time[p,m] * x[p])/3600) #labour cost
  - (sum{r in R, p in P} rm_cost[r] * bom[p,r] * x[p]) #cost to buy shoe materials
  - (10 * sum{p in P} max(0,demand[p]-x[p])) #unmet demand
  - (sum{w in W} wh_op_cost[w] * y[w]); #cost of warehouse

subject to Machine_Capacity{m in M}:
    sum{p in P} proc_time[p,m] * x[p] <= machine_capacity_min[m]; #time has to be less than 12 hours a day 28 days a month, averaged out

subject to RM_Budget: #all the materials bought is less than budget
    sum{r in R, p in P} rm_cost[r] * bom[p,r] * x[p] <= rm_budget;

subject to RM_Availability{r in R}: #all materials bought is less than the materials availible
    sum{p in P} bom[p,r] * x[p] <= rm_avail[r];

subject to Warehouse_Cap: #the total shoes is less than all operating warehouse
    sum{p in P} x[p] <= sum{w in W} warehouse_cap[w] * y[w];

# End of model
