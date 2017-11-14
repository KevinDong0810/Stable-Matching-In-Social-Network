function b = ws(N,k,p)
% N The node number of the whole network
% k the average degree of the whole network
% p the possibility for two nodes getting connected
% AM Adjacent Matrix
b = ncn(N,k);
for i = 1:N-1
    for j = i+1:N
        if b(i,j)~=0
            if rand<p
                b(i,j) = 0;
                b(j,i) = 0;         %随机重连，遍历原规则网络中的每一条边
                c = 1:N-1;
                c = c';             %保持其一端的节点不变，产生一个随机数
                for h = N-1:(-1):i  %若该随机数小于p，则随机选取除该端点
                    c(h,1) = h+1;   %之外的另一个节点作为另一端的节点。
                end
                d = ceil((N-1)*rand);
                s = c(d,1);
                b(i,s) = 1;
                b(s,i) = 1;
            end
        end
    end
end
end