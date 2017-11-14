function [AccessMatrix]=AccessGenerator(N,k,type)
%  generate the modified adjacent matrix, plz note that since NCN needs even average degree, we would double k in case k is not even
%  Input:   N: node number of network
%           k: half average degree of the network  type: network type
%  Output:  AccessMatrix: the modified adjacent matrix
    AM=zeros(N);
    switch type
        case(1)
            AM=ba(4*k,2*k,N);
        case(2)
            AM=ws(N,2*k,0.5);
        case(3)
            AM=er(N,2*k/(N-1));
        case(4)
            AM=ncn(N,2*k);
        otherwise
            disp('type error')
    end

    AM(AM==0)=inf;
    AM(logical(eye(size(AM))))=0;
    AccessMatrix=AM;
end