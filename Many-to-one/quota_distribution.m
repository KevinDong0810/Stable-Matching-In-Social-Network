function [Quota_vector]=quota_distribution(AM_H,ratio,N_R)
%   distribute the job quota according to the degree of each hospital
%   Input:  AM_H: the adjacent matrix for hospitals 
%           ratio: total quotas / N_R    N_R: node number of residents
%   Output: Quota_vector: Quota distribution vector for every hospital
    N_H = length(AM_H);
    Quota_total=round(ratio*N_R); 
    Quota_vector=zeros(1,N_H);
    k_total=sum(sum(AM_H(:)));
        if k_total == 0 % trivial case
            i = 1;
            Quota_vector(1) =  unidrnd(Quota_total);
            sum_taken = Quota_vector(1);
            while (sum_taken < Quota_total )&&(i<=(N_H-2))
                i = i+1;
                Quota_max = ceil(0.6*(Quota_total - sum_taken));
                Quota_vector(i) = unidrnd(Quota_max);
                sum_taken = Quota_vector(i) + sum_taken;                
            end
            Quota_vector(N_H) = Quota_total - sum_taken;
        else
            for i=1:N_H
                degree=sum(AM_H(i,1:N_H));
                Quota_vector(i)=round(degree*Quota_total/k_total);
            end
        end
        Quota_vector(Quota_vector==0) = 1;
end