% using the processed dataset of Professor and Student to testify the
% accuracy rate of different algorithms
clc
clear
load 'MatchingMember.mat' % load the data mat

D_num = 10;
D = 1:1:D_num;

% One-to-one matching problem
accuracy = zeros(1,D_num);
accuracy_classical = zeros(1,D_num);

% Test our one-to-one network matching algorithm
for i = 1 : D_num
    [~,accuracy(i)] = Purpose_RG(Distance_dijkstra, Professor, Student,match_real_one,D(i),0);
end

% Test the classic G-S matching algorithm
for i = 1 : D_num
    [~,accuracy_classical(i)] = Purpose_RG(Distance_dijkstra_connected, Professor, Student,match_real_one,D(i),0);
end

% Many-to-one matching problem
accuracy_n = zeros(1,D_num);
accuracy_classical_n = zeros(1,D_num);

% Test our many-to-one network matching algorithm
for i = 1 : D_num
    [~,accuracy_n(i)] = Purpose_RG(Distance_dijkstra, Professor, Student,match_real_many,D(i),1);
end

% Test the classic H-R matching algorithm
for i = 1 : D_num
    [~,accuracy_classical_n(i)] = Purpose_RG(Distance_dijkstra_connected, Professor, Student,match_real_many,D(i),1);
end

save('MatchingResult.mat','accuracy','accuracy_n','accuracy_classical','accuracy_classical_n','D');