clc
clear
load('RawData.mat');

AM_follower = Pre_AM_Creator(Connection_follower,559);
AM_following = Pre_AM_Creator(Connection_following,559);
AdjacentMatrix = AM_following + AM_follower;
AdjacentMatrix(AdjacentMatrix==1) =0;
AdjacentMatrix(AdjacentMatrix==2) =1;% get the adjacent matrix, only two nodes follow each other then a conncetion between them is formed

[Distance_dijkstra,~] = path_match_finder(AdjacentMatrix,MatchingMemberList);% this may take 1h in a common laptop
Distance_dijkstra_connected = ones(size(Distance_dijkstra)) - eye(size(Distance_dijkstra));% get the fully connected network for classic G-S algorithm

save('MatchingMember.mat','Distance_dijkstra', 'Distance_dijkstra_connected', 'Professor','Student','match_real_many','match_real_one');