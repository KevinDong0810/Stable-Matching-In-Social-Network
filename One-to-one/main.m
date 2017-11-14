% investigate the performance of different network agains different degree, D, and node number N
clc
clear
fprintf('calculating the  1st function\n');
[AveSatis_k,AveCost_k,Phi_k,APL_k]=simulation_k();
clear
fprintf('calculating the  2nd function\n');
[AveSatis_N,AveCost_N,Phi_N,APL_N]=simulation_N();
clear
fprintf('calculating the  3rd function\n');
[AveSatis_D,AveCost_D,Phi_D,APL_D]=simulation_D();  
fprintf('Finished');