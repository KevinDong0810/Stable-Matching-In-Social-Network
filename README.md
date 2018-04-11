# Stable-Matching-In-Social-Network
This repository contains the supporting material for the journal paper **Stable Matching in Various Social Network Structures**. Stable matching investigates how to pair elements of two disjoint sets with the purpose to achieve a matching that satisfies all participants based on their preference lists. In this paper, we consider the case of matching with incomplete information in a social network where agents are not fully connected.

## One-to-one
This directory contains the source code for the one-to-one matching. Running "main.m" in MATLAB would generate the simulation results for one-to-one matching mentioned in the paper. Note that the parallel computation, namely 'parfor', in MATLAB is used to accelerate the computation. "simulation_k", "simulation_N.m" and "simulation_D.m" simulate the matching results in different networks against different average degree k, average degree N and average degree D respectively.

## Many-to-one
This directory contains the source code for the Many-to-one matching, whose files are similar to those in *One-to-many*.

## EmpiricalStudy
This directory contains the source code and dataset(in the subdirectory *RG Dataset*) for the experiment made on ResearchGate(RG). 

*CrawlerProgram* contains the python programs for crawling data from RG. The user has to input his/her own RG account information. Note that owing to the change of RG website itself, the success of crawler programs is not guaranted. 

*MATLAB_Code* contains the matlab code for processing data and get the algorithm accuracy. Firstly, run the "main_preprocess.m". It would process the rawdata stored in "RawData.mat" and generate the necessary matrices in "MatchingMember.mat". Then, run the "main_test.m". It would use our algorithm to predicate the matching results for the agents in RG, and output the accuracy results. Running the "result_ploter.m" would plot the result figure.
