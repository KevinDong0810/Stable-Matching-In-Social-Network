function [AveSatis,AveCost,Connectivity,APL]=H_R_simulation(N_H,N_R,w_H,w_R,ratio,type,Scores_to_H,Scores_to_R,D)
%   simulate the matching result given network type and preference list
    AM_H=ba(2*w_H,w_H, N_H);% use the BA model to generate the network of hospitals; WS model or other models could also be used here
    [Quota_vector]=quota_distribution(AM_H,ratio,N_R);% distribute the job quota according to the degree of each hospital
    AM_H(AM_H==0)=inf;
    AM_H(logical(eye(size(AM_H))))=0;
    AM_R=AccessGenerator(N_R,w_R,type); % generate the network of residents
    [AveSatis,AveCost,Connectivity,APL]=NetworkMatch_HR(N_H,N_R,AM_H,AM_R,Scores_to_H,Scores_to_R,Quota_vector,D);

end