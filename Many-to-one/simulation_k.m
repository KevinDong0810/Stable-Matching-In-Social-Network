function [AveSatis_k,AveCost_k,Phi_k,APL_k]=simulation_k(N_R, D, ratio,k_start,k_num,repeat_num)
% Simulate the matching results of different networks against different average degree k
% Input:    k_R: average degree of residents;   ratio: total quota / node number of residents;
%           k_start: the start value of k;      k_num: the number of different k values
%           repeat_num: the number of repeated experiments for each k
%Output:    Evaluation metrics in the paper
    if nargin==0
        N_R=70; D=3; ratio=1; k_start=1;k_num=10;repeat_num=5;
    end
    % preparation
    N_H=30;k_H=2;
    K_R=k_start:1:(k_start+(k_num-1));
    AveSatis_k=zeros(4,k_num);
    AveCost_k=zeros(4,k_num);
    Phi_k=zeros(4,k_num);
    APL_k=zeros(4,k_num);
    [Scores_to_H,Scores_to_R]=fixed_preference_HR(N_H,N_R); % get the fixed preference score
    parfor i =1:4  % 1~4 represent different network types: BA:i=1; WS:i=2; ER:i=3; NCN:i=4
        for j=1:k_num 
                AveSatis_temp=zeros(1,repeat_num);AveCost_temp=zeros(1,repeat_num);Phi_temp=zeros(1,repeat_num);APL_temp=zeros(1,repeat_num);
                for t=1:1:repeat_num
                    [AveSatis_temp(t),AveCost_temp(t),Phi_temp(t),APL_temp(t)]=H_R_simulation(N_H,N_R,k_H,K_R(j),ratio,i,Scores_to_H,Scores_to_R,D);
                    fprintf('Calculation has finished %.2f%%\n',(t+(j-1)*repeat_num+(i-1)*k_num*repeat_num)/(4*k_num*repeat_num)*100);
                end
                AveSatis_k(i,j)=mean(AveSatis_temp);AveCost_k(i,j)=mean(AveCost_temp);Phi_k(i,j)=mean(Phi_temp);APL_k(i,j)=mean(APL_temp);
        end
        %save AveSatis_w_temp.mat
    end
    save AveSatis_k.mat
end