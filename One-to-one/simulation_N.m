function [AveSatis_N,AveCost_N,Phi_N,APL_N]=simulation_N(k, D, N_start,N_num,repeat_num)  
% simulate the matching results in different networks against different averate degree N
% Input: k: average degree;  D: maximum depth
%        N_start: the start value of N;     N_num: the number of different N values
%        repeat_num: the number of repeated experiments for each N
%Output: Evaluation metrics in the paper

    if nargin==0
         k=1;D=3;N_start=40;N_num=11;repeat_num=2;
    end
    %preparation
    N=N_start:2:(N_start+2*(N_num-1));
    AveSatis_N=zeros(4,N_num);
    Phi_N=zeros(4,N_num);
    APL_N=zeros(4,N_num);
    AveCost_N=zeros(4,N_num);
    
    parfor j=1:N_num
        [Score_to_man,Score_to_woman,manSN,womanSN]=fixed_preference(N(j));
        for i=1:4
            AveSatis_temp=zeros(1,repeat_num); AveCost_temp=zeros(1,repeat_num); Phi_temp=zeros(1,repeat_num);APL_temp=zeros(1,repeat_num);
            for t=1:repeat_num
                [AM]=AccessGenerator(N(j),k,i);
                [AveSatis_temp(t),AveCost_temp(t),Phi_temp(t),APL_temp(t)]=NetworkMatch(N(j),AM,D,womanSN,manSN,Score_to_man,Score_to_woman);
            end
            AveSatis_N(i,j)=mean(AveSatis_temp); AveCost_N(i,j)=mean(AveCost_temp); Phi_N(i,j)=mean(Phi_temp); APL_N(i,j)=mean(APL_temp);
            index=t+(i-1)*repeat_num+(j-1)*repeat_num*4; 
            fprintf('Calculation has finished %.1f%%\n',100*index/(N_num*repeat_num*4));
        end
    end 
    save satisfaction_N.mat
end

 

