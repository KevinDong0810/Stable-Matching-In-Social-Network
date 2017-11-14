function [Scores_to_H,Scores_to_R]=fixed_preference_HR(N_H,N_R)
% generate the preference list for hospitals and residents
%Input:   N_H: node number for hospitals; N_R: node number for residents
%Output:  Scores_to_H:  the scores from residents to hospitals
%         Scores_to_R;  the scores from hospitals to residents

    if nargin==0
        N_H=30;N_R=70;
    end
    rng('shuffle'); % shuffle the rand seed
    Scores_to_H=zeros(N_R,N_H);
    Scores_to_R=zeros(N_H,N_R);
    Order_to_H=zeros(N_R,N_H);
    Order_to_R=zeros(N_H,N_R);
 
    % generate Scores_to_H
    for i=1:N_R
        Order_to_H(i,:)=randperm(N_H); % generate the preference list
    end
    
    for i=1:N_R   %turn the preference list into score/utility
        k=1;
        for j=N_H:-1:1
            Scores_to_H(i,Order_to_H(i,j))=k*10/N_H;
            k=k+1;
        end
    end   
    
    % generate Scores_to_R
    for i=1:N_H
        Order_to_R(i,:)=randperm(N_R); % generate the preference list
    end

    
    for i=1:N_H    %turn the preference list into score/utility
        k=1;
        for j=N_R:-1:1
            Scores_to_R(i,Order_to_R(i,j))=k*10/N_R;
            k=k+1;
        end
    end 
end











