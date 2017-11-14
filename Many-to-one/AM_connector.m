function [Dijstra_Matrix,path] = AM_connector(AM_H, AM_R)
% get the dijkstra matrix based on the network of hospitals and residents
% Input: AM_H, AM_R: modified adjacent matrix, where 0 is changed to inf, and self-to-self is set as 0
    N_H = length(AM_H);
    N_R = length(AM_R);
    N=N_H+N_R;
    path=cell(N,N);
    R_H_Connection = inf(N_R,N_H);
    for i = 1:N_R
        connected_hospital = randperm(N_H,unidrnd(round(0.5*N_H)));%connect every resident to random hospitals randomly
        R_H_Connection(i,connected_hospital) = 1;
    end
    
    AM_whole=[AM_H,R_H_Connection';R_H_Connection,AM_R];
    
    %calulate the dijkstra distance between hospitals
    DM_hospital = zeros(N_H);
    for i=1:N_H
        for j=i+1:N_H
            [distance,path_temp]=dijkstra(AM_H,i,j);
            DM_hospital(i,j)=distance;
            DM_hospital(j,i)=distance;
            path{i,j}=path_temp;
            path{j,i}=fliplr(path_temp);
        end
    end
    
    %calulate the dijkstra distance between residents
    DM_resident = zeros(N_R);
    for i=1:N_R
        for j=i+1:N_R
            [distance,path_temp]=dijkstra(AM_R,i,j);
            DM_resident(i,j)=distance;
            DM_resident(j,i)=distance;
            path{i+N_H,j+N_H}=path_temp;
            path{j+N_H,i+N_H}=fliplr(path_temp);
        end
    end 
    
    %calculate the dijkstra distance between residents and hospitals
    DM_connection = zeros(N_R, N_H);
    for i = 1:N_R
        for j = 1:N_H
            [distance,path_temp]=dijkstra(AM_whole,i+N_H,j);
            DM_connection(i,j)=distance;
            path{i+N_H,j}=path_temp;
            path{j,i+N_H}=fliplr(path_temp);
        end                   
    end
    
    Dijstra_Matrix = [DM_hospital,DM_connection';DM_connection,  DM_resident];
end