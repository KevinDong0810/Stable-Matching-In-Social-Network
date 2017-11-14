function [AveSatis_N,AveCost_N,Phi_N,APL_N]=simulation_N(k_R, D, ratio,N_start,N_num,repeat_num)
% Simulate the matching results of different networks against different N
% Input:    k_R: average degree of residents;   ratio: total quota / node number of residents;
%           N_start: the start value of N_R;  N_num: the number of different N_R values
%           repeat_num: the number of repeated experiments for each N_R
%Output:    Evaluation metrics in the paper
    if nargin==0
        k_R=1;D=3; ratio=1;N_start=50;N_num=10;repeat_num=5;
    end
    % preparation
    N_H=30;k_H=2;
    N_R=N_start:10:(N_start+10*(N_num-1));
    AveSatis_N=zeros(4,N_num);
    AveCost_N=zeros(4,N_num);
    Phi_N=zeros(4,N_num);
    APL_N=zeros(4,N_num);
    
    parfor j=1:N_num  
        [Scores_to_H,Scores_to_R]=fixed_preference_HR(N_H,N_R(j)); % get the fixed preference score
        for i =1:4  % 1~4 represent different network types: BA:i=1; WS:i=2; ER:i=3; NCN:i=4
                AveSatis_temp=zeros(1,repeat_num);AveCost_temp=zeros(1,repeat_num);Phi_temp=zeros(1,repeat_num);APL_temp=zeros(1,repeat_num);
                for t=1:1:repeat_num
                    [AveSatis_temp(t),AveCost_temp(t),Phi_temp(t),APL_temp(t)]=H_R_simulation(N_H,N_R(j),k_H,k_R, ratio,i,Scores_to_H,Scores_to_R,D);
                    fprintf('Calculation has finished %.2f%%\n',(t+(i-1)*repeat_num+(j-1)*4*repeat_num)/(4*N_num*repeat_num)*100);
                end
                AveSatis_N(i,j)=mean(AveSatis_temp);AveCost_N(i,j)=mean(AveCost_temp);Phi_N(i,j)=mean(Phi_temp);APL_N(i,j)=mean(APL_temp);
        end
        %save AveSatis_N_temp.mat
    end
    save AveSatis_N.mat
end