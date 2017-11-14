function [Score_to_man,Score_to_woman,manSN,womanSN]=fixed_preference(N)
% generate the fixed preference score
% Input: N: the node number for the whole network
% Output: Score_to_man: woman's preference score for man (one virtual man is added for initialization)
%         Score_to_woman: man's preference score for woman 
%         manSN, womanSN: the serial number for man and woman 
    n=N/2;
    PreferenceVectorW=zeros(n);  
    for i=1:n
        PreferenceVectorW(i,:)=randperm(n);% generate the preference list for woman (to man)
    end
    
    PreferenceVectorW=[PreferenceVectorW, (n+1)*ones(n,1)];% add the virtual man for initialization
    Score_to_man=zeros(n,n+1); 
    
    for i=1:n  
        k=1;
        for counter=n:-1:1
            Score_to_man(i,PreferenceVectorW(i,counter))=k*10/n; % tranform the preference into the score to man or utility 
            k=k+1;
        end
    end   
    
    PreferenceVectorM=zeros(n); 
    for i=1:n
        PreferenceVectorM(i,:)=randperm(n); % generate the preference list for man (to woman)
    end
    Score_to_woman=zeros(n,n);
    
    
    for i=1:n   
        k=1;
        for counter=n:-1:1
            Score_to_woman(i,PreferenceVectorM(i,counter))=k*10/n; % tranform the preference into the score to woman or utility 
            k=k+1;
        end
        
    end
    
    gender=zeros(1,N); % assign gender to node randomly
    idx=randperm(N);
    gender(idx(1:N/2))=1;
    
    % get the man and woman serial number
    manSN=zeros(1,N/2);
    womanSN=zeros(1,N/2);
    
    counter=1; 
    for i=1:N     
        if gender(i)==1           
            manSN(counter)=i;
            counter=counter+1;
        end
    end
    
    counter=1;  
    for i=1:N    
        if gender(i)==0      
            womanSN(counter)=i;
            counter=counter+1;
        end
    end
end











