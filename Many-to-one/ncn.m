function AM=ncn(N,k)
% N The node number of the whole network
% k:the average degree of the whole network 
% AM Adjacent Matrix
AM=zeros(N);
for i=1:N
    for j=(i+1):(i+k/2)
        if j<=N
            AM(i,j)=1;
            AM(j,i)=1;
        else
            AM(i,j-N)=1;
            AM(j-N,i)=1;
        end
    end
end
end