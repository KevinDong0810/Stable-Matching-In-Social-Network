function [AveSatis,AveCost,Connectivity,APL] = NetworkMatch(N,AM,D,womanSN,manSN,Score_to_man,Score_to_woman)
% implement the stable matching in the network
% Output: Evaluationg metrics in the paper
        Distance_dijkstra=zeros(N);
        path=cell(N,N);
        for i=1:N
            for j=i+1:N
				[distance,path_temp]=dijkstra(AM,i,j);
				Distance_dijkstra(i,j)=distance;
				Distance_dijkstra(j,i)=distance;
				path{i,j}=path_temp;
				path{j,i}=fliplr(path_temp);
            end
        end
        Distance_dijkstra(logical(eye(size(Distance_dijkstra))))=0;
        
        Access=Distance_dijkstra;
        Access(Distance_dijkstra<=D)=1;
        Access(Distance_dijkstra>D)=0;
        
        Distance_dijkstra(Distance_dijkstra==inf)=20; % in case the inf distance would influence APL, set it equals to 20 
        APL=sum(sum(Distance_dijkstra))/(N*(N-1));
        Connectivity=length(find(Access==1))/(N*N);
        Access(logical(eye(size(Access))))=0;
        
        Access_ij=zeros(size(Access));
        for i=1:N/2
            for j=1:N/2
                Access_ij(i,j)=Access(womanSN(i),manSN(j));% get the access matrix from woman to man
            end
        end
        
        P_W=zeros(N/2); % generate the P^{W} preference score matrix for woman, if two nodes are unaccessible, set preference score to -inf
        for i=1:N/2     
            for j=1:N/2
                if Access_ij(i,j)==1
                    P_W(i,j)=Score_to_man(i,j);
                else
                    P_W(i,j)=-inf;
                end
            end
        end
        
        P_W=[P_W,zeros(N/2,1)];%add a virtual man for initialization
        
        Access_ji=Access_ij';
        P_M=zeros(N/2);
        for i=1:N/2 % generate the P^{M} preference score matrix for man, if two nodes are unaccessible, set preference score to -inf    
            for j=1:N/2
                if Access_ji(i,j)==1
                    P_M(i,j)=Score_to_woman(i,j);
                else
                    P_M(i,j)=-inf;
                end
            end
        end
                
        [~,RankMan]=sort(P_M,2,'descend'); %for every man, sort woman according to matrix P^{M};
        
        man_courtship=ones(1,(N/2)+1); % store the next woman to propose for every man
        WomanTo=((N/2)+1)*ones(1,N/2); % store the woman's current partner
        Index_man=zeros(1,N/2); % store the courtship sequence for man
        top=1;
        while(top<((N/2)+1))
            Index_man(top)=top;
            top=top+1;
        end
        top=top-1;
                
        while(top>=1)  
            m = Index_man(top); % denote the current man as m
            w=RankMan(m,man_courtship(m)); % denote the current woman that m is proposing to as w
            if P_W(w,WomanTo(w))<P_W(w,m) % if w prefers m to its current partner t
                t=WomanTo(w);  
                man_courtship(t)=man_courtship(t)+1;
                WomanTo(w)=m;
                top=top-1;
                if t~=(N/2)+1  % take care of the initial value
                    top=top+1;
                    Index_man(top)=t;
                end
            else
                man_courtship(m)=man_courtship(m)+1;  % the current courtship fails, m applies to next one
                if  man_courtship(m)>N/2
                    top=top-1;                   
                end               
            end
        end
         
        woman_matched= find(WomanTo<(N/2)+1);
        man_matched=WomanTo(find(WomanTo<(N/2)+1));% find out matched man and woman
        pair_num=length(woman_matched);
        satis=zeros(1,pair_num);
        for i=1:pair_num
           satis(i)=(P_W(woman_matched(i),man_matched(i))+P_M(man_matched(i),woman_matched(i)))/2;
        end
        AveSatis=sum(satis(1:pair_num))/(N/2);
        
% compute depth ~cost for the whole matching

    if pair_num==0
        AveCost=0;
    else
        cost_temp=zeros(1,pair_num);
        for i=1:pair_num
            process=path{manSN(man_matched(i)),womanSN(woman_matched(i))}; 
            dist=Distance_dijkstra(manSN(man_matched(i)),womanSN(woman_matched(i)));  
            if isempty(process) && dist==1  
                if length(find(Distance_dijkstra(manSN(man_matched(i)),:)==1))==1
                    prob=0.01;
                else
                    prob=log(length(find(Distance_dijkstra(manSN(man_matched(i)),:)==1)));
                end
                cost_temp(i)=prob*exp(1);
            else
                prob=zeros(1,length(process)-1);
                prob(1)=length(find(Distance_dijkstra(process(1),:)==1));
                aa=cell(1,length(process)-1);
                bb=cell(1,length(process)-1);
                id=cell(1,length(process)-1);
                number=cell(1,length(process)-1);
                for j=2:length(process)-1
                    aa{j}=find(Distance_dijkstra(process(1),:)==j); 
                    bb{j}=find(Distance_dijkstra(process(j),:)==1);
                    id{j}=ismember(aa{j},bb{j});
                    number{j}=aa{j}(id{j});
                    prob(j)=length(number{j});
                end
                cost_temp(i)=log(prod(prob))*exp(length(process)-1);
            end
        end
        AveCost=sum(cost_temp)/(N/2);
    end        
end