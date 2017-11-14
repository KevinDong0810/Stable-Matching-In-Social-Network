function [AM] = Pre_AM_Creator(Connection,N)
% Create the AdjacentMatrix from the follower/following relationship matrix
%Input	Connection	Host|Follower/Following
%		N			the number of matching members
    AM = zeros(N,N);
    n = length(Connection);
    for i = 1:n
        x = Connection(i,1);
        y = Connection(i,2);
        AM(x,y) = 1;
    end
    AM(logical(eye(size(AM))))=0;
end