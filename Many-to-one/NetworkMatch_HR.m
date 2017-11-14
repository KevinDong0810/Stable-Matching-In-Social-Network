function [AveSatis,AveCost,Connectivity,APL,match_res,libHospital] = NetworkMatch_HR(N_H,N_R,AM_H,AM_R,Scores_to_H,Scores_to_R,Quota_vector,D)
% implement the stable matching in the network
% Output:   AveSatis, AveCost, Connectivity, APL: metrics mentioned in paper
%           match_res, libHospital: matching results for debug
        [Distance_dijkstra,path] = AM_connector(AM_H, AM_R); % get the dijkstra matrix based on the network of hospitals and residents  
        N = N_H + N_R;
        Access=Distance_dijkstra;
        Access(Distance_dijkstra<=D)=1;
        Access(Distance_dijkstra>D)=0;
       
        Distance_dijkstra(logical(eye(size(Distance_dijkstra))))=0;% set the self-to-self distance as 0 to get the true APL
        Distance_dijkstra(Distance_dijkstra==inf)=20; % in case the inf distance would influence APL, set it equals to 20 
        APL=sum(Distance_dijkstra(:))/(N*(N-1));
        Connectivity=length(find(Access==1))/(N*N);
        Access(logical(eye(size(Access))))=0;

        
        Access_H_R=Access(1:N_H,N_H+1:end);
        Access_R_H=Access_H_R';
        
        P_R=zeros(N_R,N_H);%generate the P^{R} preference score matrix for residents, if two nodes are unaccessible, set preference score to -inf
        for i=1:N_R     
            for j=1:N_H
                if Access_R_H(i,j)==1
                    P_R(i,j)=Scores_to_H(i,j);
                else
                    P_R(i,j)=-inf;
                end
            end
        end
        
        
        
        P_H=zeros(N_H,N_R);%generate the P^{H} preference score matrix for hospitals, if two nodes are unaccessible, set preference score to -inf
        for i=1:N_H     
            for j=1:N_R
                if Access_H_R(i,j)==1
                    P_H(i,j)=Scores_to_R(i,j);
                else
                    P_H(i,j)=-inf;
                end
            end
        end
        
        [~,RankResident]=sort(P_R,2,'descend');  %for every resident, sort hospitals according to matrix P^{R};

        libHospital=cell(2,N_H);%libHospital stores the necessary information fro hospitals
        for i=1:N_H
            libHospital{1,i}=[zeros(Quota_vector(i),1),(N_R+1)*ones(Quota_vector(i),1)];
            libHospital{2,i}=0;
        end
        resident_application=ones(1,(N_R)); % store the next hospital to apply for every resident.
        Index_resident=zeros(1,N_R);   % store the application sequence for residents
        top=1;
        while(top<(N_R+1))
            Index_resident(top)=top;
            top=top+1;
        end
        top=top-1;
        
        
        while(top>=1)
            r = Index_resident(top); % denote the current resident as r
            if resident_application(r)>N_H  %if r has applied to all hospitals, then r remains unmatched.
                top=top-1;
                continue;
            end
            h=RankResident(r,resident_application(r));  % r is going to apply to hospital h
            if P_R(r,h)==(-inf) % if r and h are not accessible to each other
                resident_application(r)=resident_application(r)+1;% the current application fails, r applies to next hospital
                if  resident_application(r)>N_H  %if r has applied to all hospitals, then r remains unmatched.
                            top=top-1;
                            continue;
                end
            else
                if libHospital{2,h}<Quota_vector(h)% if hospital h still has student quota
                    libHospital{1,h}(libHospital{2,h}+1,2)=r;
                    libHospital{1,h}(libHospital{2,h}+1,1)=P_H(h,r);
                    libHospital{2,h}=libHospital{2,h}+1;
                    top=top-1;
                else
                    [~,I]=sort(libHospital{1,h}(:,1),1,'descend');
                    libHospital{1,h}=libHospital{1,h}(I,:);
                    if P_H(h,r)>libHospital{1,h}(end,1)%if hospiral h prefer r to his/her last resident 
                        libHospital{1,h}(end,1)=P_H(h,r);
                        post_resident=libHospital{1,h}(end,2);
                        resident_application(post_resident)=resident_application(post_resident)+1;% r becomes admitted, and the former resident has to apply to another hospital.
                        libHospital{1,h}(end,2)=r;
                        Index_resident(top)=post_resident;
                    else
                        resident_application(r)=resident_application(r)+1;% the current application fails, r applies to next hospital
                        if  resident_application(r)>N_H%if r has applied to all hospitals, then r remains unmatched.
                            top=top-1;
                            continue;
                        end
                    end
                end
            end
        end
        
        %reorganize the matching results
        pair_sum=0;
        for i=1:N_H
            pair_sum=pair_sum+libHospital{2,i};
        end        
        match_res=zeros(pair_sum,4);
        index=1;
        for i=1:N_H
            for j=1:libHospital{2,i}
                match_res(index,1)=i;match_res(index,2)=libHospital{1,i}(j,1);
                match_res(index,3)=libHospital{1,i}(j,2);match_res(index,4)=P_R(libHospital{1,i}(j,2),i);
                index=index+1;
            end
        end
        AveSatis=(sum(match_res(:,2))+sum(match_res(:,4)))/(2*pair_sum);
        
       % calculate the connective cost
       Distance_cost=zeros(N,N);
        for i=1:N   
            for j=1:N
                if isempty(path{i,j})                   
                    if Distance_dijkstra(i,j)==1
                        Distance_cost(i,j)=1;
                    else
                        Distance_cost(i,j)=inf;
                    end
                else 
                    Distance_cost(i,j)=length(path{i,j})-1;
                end
            end
        end
           
        if pair_sum==0
            AveCost=0;
        else
            cost_temp=zeros(1,pair_sum);
            for i=1:pair_sum
                process=path{match_res(i,3)+N_H,match_res(i,1)}; 
                dist=Distance_cost(match_res(i,3)+N_H,match_res(i,1));  
                if  isempty(process) 
                    if dist==1  
                        if length(find(Distance_cost(match_res(i,3)+N_H,:)==1))==1
                            prob=0.01;
                        else
                            prob=log(length(find(Distance_cost(match_res(i,3)+N_H,:)==1)));
                        end
                        cost_temp(i)=prob*exp(2);
                    else 
                        fprintf('error %d \n',i);
                    end
                else
                   
                    
                    prob=zeros(1,length(process)-1);                 
                    prob(1)=length(find(Distance_cost(process(1),:)==1));
                    aa=cell(1,length(process)-1);
                    bb=cell(1,length(process)-1);
                    id=cell(1,length(process)-1);
                    number=cell(1,length(process)-1);
                    for j=2:length(process)-1
                        aa{j}=find(Distance_cost(process(1),:)==j); 
                        bb{j}=find(Distance_cost(process(j),:)==1);
                        id{j}=ismember(aa{j},bb{j});
                        number{j}=aa{j}(id{j});
                        prob(j)=length(number{j});
                    end
                    cost_temp(i)=log(prod(prob))*exp(Distance_dijkstra(match_res(i,3)+N_H,match_res(i,1)));
                end
            end
            AveCost=sum(cost_temp)/min(sum(Quota_vector),N_R);
        end 
        
end
