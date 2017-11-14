function [Distance_dijkstra,path_dijkstra] = path_match_finder(AdjacentMatrix,MatchingMemberList)
%	Creat the Distance_dijkstra matrix for matching members from the Adjacent Matrix of community members
%	Input:	AdjacentMatrix: the Adjacent Matrix of (559) community members, where 1 means two nodes follow each other in RG
%			MatchingMemberList:	the No. of matching members
%	Output: The dijkstra distance matrix of matching members
    AdjacentMatrix(AdjacentMatrix==0)=inf;
    AdjacentMatrix(logical(eye(size(AdjacentMatrix))))=0;
    N = length(MatchingMemberList);
    path_dijkstra = cell(N,1);
    Distance_dijkstra=zeros(N,N);%此时的N为总人数
    parfor i=1:N
        Distance_temp = zeros(1,N);
        path_temp = cell(1,N);
        for j = i+1:N
            [distance,path_temp2]=dijkstra(AdjacentMatrix,MatchingMemberList(i),MatchingMemberList(j));
            Distance_temp(1,j)=distance;
			path_temp{1,j}=path_temp2;
        end
        Distance_dijkstra(i,:) = Distance_temp;
        path_dijkstra{i} = path_temp;
    end
    Distance_dijkstra = Distance_dijkstra + Distance_dijkstra';
    path_temp = cell(N,N);
    for i = 1:N
        row = path_dijkstra{i};
        for j = i+1:N
        path_temp{i,j} =  row{j};
        path_temp{j,i} =  fliplr(row{j});
        end
    end
    path_dijkstra = path_temp;
end