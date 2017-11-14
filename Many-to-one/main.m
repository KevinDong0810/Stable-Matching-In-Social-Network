% investigate the performance of different network agains different degree, D, and node number N
% note that parameters used here is pretty small, just for a demo
clc
clear
fprintf('calculating the  1st function\n');
[AveSatis_k,AveCost_k,Phi_k,APL_k]=simulation_k(30, 3, 1, 1, 2, 2);
clear
fprintf('calculating the  2nd function\n');
[AveSatis_D,AveCost_D,Phi_D,APL_D]=simulation_D(30, 1, 1, 1, 2, 2);
clear
fprintf('calculating the  3rd function\n');
[AveSatis_N,AveCost_N,Phi_N,APL_N]=simulation_N(1, 3, 1, 25, 2, 2);
clear
fprintf('Finished');
