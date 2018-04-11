function [AveSatis_D,AveCost_D,Phi_D,APL_D]=simulation_D(N, k, D_start,D_num,repeat_num)  
% simulate the matching results in different networks against different average degree D
% Input: N: the node number of whole network; k: average degree
%        D_start: the start value of D;     D_num: the number of different D values
%        repeat_num: the number of repeated experiments for each D
%Output: Evaluation metrics in the paper

    if nargin==0
         N=100;k=1;D_start=1;D_num=7;repeat_num=5;
    end
    %preparation
    D=D_start:(D_start+D_num-1);
    AveSatis_D=zeros(4,D_num);
    Phi_D=zeros(4,D_num);
    APL_D=zeros(4,D_num);
    AveCost_D=zeros(4,D_num);
    [Score_to_man,Score_to_woman,manSN,womanSN]=fixed_preference(N);
    parfor i=1:4
        for j=1:D_num
            AveSatis_temp=zeros(1,repeat_num); AveCost_temp=zeros(1,repeat_num); Phi_temp=zeros(1,repeat_num);APL_temp=zeros(1,repeat_num);
            for t=1:repeat_num
                [AM]=AccessGenerator(N,k,i);
                [AveSatis_temp(t),AveCost_temp(t),Phi_temp(t),APL_temp(t)]=NetworkMatch(N,AM,D(j),womanSN,manSN,Score_to_man,Score_to_woman);
            end
            AveSatis_D(i,j)=mean(AveSatis_temp); AveCost_D(i,j)=mean(AveCost_temp); Phi_D(i,j)=mean(Phi_temp); APL_D(i,j)=mean(APL_temp);
            index=t+(j-1)*repeat_num+(i-1)*repeat_num*D_num; 
            fprintf('Calculation has finished %.1f%%\n',100*index/(D_num*repeat_num*4));
        end
    end 
    save satisfaction_D.mat
end

 

