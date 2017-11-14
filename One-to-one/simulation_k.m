function [AveSatis_k,AveCost_k,Phi_k,APL_k]=simulation_k(N, D, k_start,k_num,repeat_num)  
% simulate the matching results in different networks against different averate degree k
% Input: N: the node number of whole network; D: maximum depth
%        k_start: the start value of k;     k_num: the number of different k values
%        repeat_num: the number of repeated experiments for each k
%Output: Evaluation metrics in the paper

    if nargin==0
         N=100;D=3;k_start=1;k_num=10;repeat_num=5;
    end
    %preparation
    K=k_start:(k_start+k_num-1);
    AveSatis_k=zeros(4,k_num);
    Phi_k=zeros(4,k_num);
    APL_k=zeros(4,k_num);
    AveCost_k=zeros(4,k_num);
    [Score_to_man,Score_to_woman,manSN,womanSN]=fixed_preference(N);
    parfor i=1:4
        for j=1:k_num
            AveSatis_temp=zeros(1,repeat_num); AveCost_temp=zeros(1,repeat_num); Phi_temp=zeros(1,repeat_num);APL_temp=zeros(1,repeat_num);
            for t=1:repeat_num
                [AM]=AccessGenerator(N,K(j),i);
                [AveSatis_temp(t),AveCost_temp(t),Phi_temp(t),APL_temp(t)]=NetworkMatch(N,AM,D,womanSN,manSN,Score_to_man,Score_to_woman);
            end
            AveSatis_k(i,j)=mean(AveSatis_temp); AveCost_k(i,j)=mean(AveCost_temp); Phi_k(i,j)=mean(Phi_temp); APL_k(i,j)=mean(APL_temp);
            index=t+(j-1)*repeat_num+(i-1)*repeat_num*k_num; 
            fprintf('Calculation has finished %.1f%%\n',100*index/(k_num*repeat_num*4));
        end
    end 
    save satisfaction_k.mat
end

 

