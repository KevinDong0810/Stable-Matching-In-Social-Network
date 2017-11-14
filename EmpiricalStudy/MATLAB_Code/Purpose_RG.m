function [match_pair,accuracy] = Purpose_RG(Distance_dijkstra, Professor, Student,match_real,D,flag)
%predicate the matching results between Professor and Student, and calculate the accuracy rate
%Input: Distance_dijkstra: the dijkstra distance between different nodes for matching members
%       Professor: No.in Community Members|No. in Matching Members|Score|the number of student co-authors
%       Student: No.in Community Members|No. in Matching Members|Score
%       match_real: Real matching results from RG
%       D: the maximum depth
%       flag: when flag==1, it is many-to-one matching problem; when flag==0, it is one-to-one matching problem;
%Output:match_pair: the matching results predicated by algorithm
%       accuracy:   accuracy rate

%   Access: access matrix, 1 means two nodes acquaint each other in the meaning of D-neiborhood
    Access=Distance_dijkstra;
    Access(Distance_dijkstra<=D)=1;
    Access(Distance_dijkstra>D)=0;
    Access(logical(eye(size(Access))))=0;
    
    N_prof = length(Professor);% The number of professors
    N_stu = length(Student);% The number of students
    
    P_S=zeros(N_stu,N_prof);%generate the P^{S} preference matrix for professors according to RG score, if two nodes are unaccessible, set preference score to -inf
    for i=1:N_stu     
        for j=1:N_prof
            index_stu = Student(i,2);
            index_prof = Professor(j,2);
            if Access(index_stu,index_prof)==1
                P_S(i,j)=Professor(j,3);
            else
                P_S(i,j)=-inf;
            end
        end
    end
                
    P_T=zeros(N_prof,N_stu);%generate the P^{T} preference matrix for students according to RG score, if two nodes are unaccessible, set preference score to -inf
    for i=1:N_prof     
        for j=1:N_stu
            index_stu = Student(j,2);
            index_prof = Professor(i,2);
            if Access(index_prof,index_stu)==1
                P_T(i,j)=Student(j,3);
            else
                P_T(i,j)=-inf;
            end
        end
    end

    [~,RankStudent]=sort(P_S,2,'descend'); %for every student, sort professors according to matrix P^{S};
    
    libProfessor=cell(2,N_prof);
    Jobs_individual = Professor(:,4);
    if flag == 0
        Jobs_individual(find(Jobs_individual>=1))=1; % if this is a one-to-one matching problem, force professors'quota equal to one.
    end
    
    
    %libHospital stores the necessary information fro professors
    for i=1:N_prof
        if Jobs_individual(i) >0
            libProfessor{1,i}=[-1*ones(Jobs_individual(i),1),(N_stu+1)*ones(Jobs_individual(i),1)]; % initialization, assume every professor have admitted one virtual student.
            libProfessor{2,i}=0;
        else
            libProfessor{1,i} = [];
            libProfessor{2,i}=0;
        end
    end
    student_application=ones(1,(N_stu)); % store the next professor to apply for every student.
    Index_student=zeros(1,N_stu);   % store the application sequence for students
    top=1;
    while(top<(N_stu+1))
        Index_student(top)=top;
        top=top+1;
    end
    top=top-1;

    while(top>=1)
        s = Index_student(top); % denote the current student as s
        if student_application(s)>N_prof %if s has applied to all professors, then s remains unmatched.
            top=top-1;
            continue;
        end
        t = RankStudent(s,student_application(s));   % t s is going to apply to professor t
        if P_S(s,t)==(-inf) % if s and t are not accessible to each other
            student_application(s)=student_application(s)+1;% the current application fails, s applies to next professor
            if  student_application(s)>N_prof %if s has applied to all professors, then s remains unmatched.
                        top=top-1;
                        continue;
            end
        else
            if Jobs_individual(t) == 0 % if professor t doest admit student at all
                student_application(s)=student_application(s)+1;% the current application fails, s applies to next professor
                if  student_application(s)>N_prof %if s has applied to all professors, then s remains unmatched.
                     top=top-1;
                     continue;
                end
            else
                if libProfessor{2,t}<Jobs_individual(t)% if professor t still has student quota
                    libProfessor{1,t}(libProfessor{2,t}+1,2)=s;
                    libProfessor{1,t}(libProfessor{2,t}+1,1)=P_T(t,s);
                    libProfessor{2,t}=libProfessor{2,t}+1;
                    top=top-1;
                else
                    [~,I]=sort(libProfessor{1,t}(:,1),1,'descend');
                    libProfessor{1,t}=libProfessor{1,t}(I,:);%将该矩阵按照第一列的分数排序
                    if P_T(t,s)>libProfessor{1,t}(end,1)%if professor t prefer to his/her last student 
                        libProfessor{1,t}(end,1)=P_T(t,s);
                        post_student=libProfessor{1,t}(end,2);
                        student_application(post_student)=student_application(post_student)+1;
                        libProfessor{1,t}(end,2)=s;
                        Index_student(top)=post_student;% s becomes admitted, and the former student has to apply to another professors.
                    else
                        student_application(s)=student_application(Index_student(top))+1;% the current application fails, s applies to next professor
                        if  student_application(s)>N_prof %if s has applied to all professors, then s remains unmatched.
                            top=top-1;
                            continue;
                        end
                    end
                end
           end
        end
    end
    
    match_pair = zeros(sum(Jobs_individual),2);
    pair_num = 1;
    for i = 1:N_prof % reorganize the matching results
        num_pair = libProfessor{2,i};
        if num_pair >0
            for j = 1:num_pair
                index_prof = Professor(i,1);
                index_stu = Student(libProfessor{1,i}(j,2),1);
                match_pair(pair_num,1) = index_prof;
                match_pair(pair_num,2) = index_stu;
                pair_num = pair_num + 1;
            end               
        end
    end
    
	%calculate the accuracy rate
    match_pair = match_pair(1:pair_num-1,:);
    Lia = ismember(match_pair, match_real, 'rows');
    accuracy = sum(Lia)/length(match_pair);
end