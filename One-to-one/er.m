function AM = er(N,p)
% N The node number of the whole network
% p the possibility for two nodes getting connected
% AM Adjacent Matrix
AM = zeros(N);
for i = 1:N-1
    for j = (i+1):N
        r=rand;
        if r<p
            AM(i,j)=1;
            AM(j,i)=1;
        end
    end
end
end