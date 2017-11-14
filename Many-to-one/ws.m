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
                b(j,i) = 0;         %�������������ԭ���������е�ÿһ����
                c = 1:N-1;
                c = c';             %������һ�˵Ľڵ㲻�䣬����һ�������
                for h = N-1:(-1):i  %���������С��p�������ѡȡ���ö˵�
                    c(h,1) = h+1;   %֮�����һ���ڵ���Ϊ��һ�˵Ľڵ㡣
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