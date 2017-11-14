function [AveSatis_D,AveCost_D,Phi_D,APL_D]=simulation_D(N_R,k_R,ratio,D_start,D_num,repeat_num)
% Simulate the matching results of different networks against different D
% Input:    N_R: node number of residents;  k_R: average degree of residents;   ratio: total quota / node number of residents;
%           D_start: the start value of D;  D_num: the number of different D values
%           repeat_num: the number of repeated experiments for each D
%Output:    Evaluation metrics in the paper
    if nargin==0
        N_R=70;ratio=1;k_R = 1; D_start=1;D_num=7;repeat_num=5;
    end
    % preparation
    N_H=30;w_H=2;
    D=D_start:1:(D_start+1*(D_num-1));
    AveSatis_D=zeros(4,D_num);
    AveCost_D=zeros(4,D_num);
    Phi_D=zeros(4,D_num);
    APL_D=zeros(4,D_num);
    [Scores_to_H,Scores_to_R]=fixed_preference_HR(N_H,N_R); % get the fixed preference score
    parfor i =1:4  % 1~4 represent different network types: BA:i=1; WS:i=2; ER:i=3; NCN:i=4
        for j=1:D_num 
                AveSatis_temp=zeros(1,repeat_num);AveCost_temp=zeros(1,repeat_num);Phi_temp=zeros(1,repeat_num);APL_temp=zeros(1,repeat_num);
                for t=1:1:repeat_num
                    [AveSatis_temp(t),AveCost_temp(t),Phi_temp(t),APL_temp(t)]=H_R_simulation(N_H,N_R,w_H,k_R,ratio,i,Scores_to_H,Scores_to_R,D(j));
                    fprintf('Calculation has finished %.2f%%\n',(t+(j-1)*repeat_num+(i-1)*D_num*repeat_num)/(4*D_num*repeat_num)*100);
                end
                AveSatis_D(i,j)=mean(AveSatis_temp);AveCost_D(i,j)=mean(AveCost_temp);Phi_D(i,j)=mean(Phi_temp);APL_D(i,j)=mean(APL_temp);
        end
        %save AveSatis_D_temp.mat
    end
    save AveSatis_D.mat
end