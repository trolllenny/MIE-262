
# WARP Shoe Company Optimization Model (MIE262)

#define sets
set P;          # set of all products numbers(shoe types)
set M;          # set of all machines numbers
set R;          # set of all raw materials
set W;			# set of all warehouses

# define parameters
param price{P}; # price per pair of shoes
param demand{P}; # forecasted demand in february for each shoe type P
param rm_cost{R}; # raw material cost and availability to buy
param bom{P,R} default 0; # quantity of raw material r required per pair of product p
param rm_avail{R};
param proc_time{P,M} default 0; #assign a processing time for every shoe that in each machine 
param mach_op_min{M}; # operating cost per minute
param wh_op_cost{W}; #operational cost for warehouse
param warehouse_cap{W}; # warehouse capacity for each warehouse 

# Constants

param rm_budget := 10000000; # raw material budget
param machine_capacity_min{m in M} := 20160; # time capacity: machine minutes available in February
param labour_cost := 25; 
param penalty := 10;
# Variables

var x{P} >= 0/*, integer*/;   # production quantity (pairs) 
var y{W} >=0 binary;   # 1 = warehouse used, 0 = not used

## DOUBLE CHECK FORMULATION FROM HERE (also when you run it, remember that I have commetned out the integer from the variable but make sure to put it back once you fix the code so that we can get the right ans.
maximize Profit:
    (sum{p in P} price[p] * x[p]) #revenue
  - (sum{m in M, p in P} mach_op_min[m] * (proc_time[p,m] * x[p])/60) #cost to make shoes using machine. per second
  - (labour_cost*sum{m in M, p in P}(proc_time[p,m] * x[p])/3600) #labour cost
  - (sum{r in R, p in P} rm_cost[r] * bom[p,r] * x[p]) #cost to buy shoe materials
  - (penalty * sum{p in P} max(0,demand[p]-x[p])) #unmet demand
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
