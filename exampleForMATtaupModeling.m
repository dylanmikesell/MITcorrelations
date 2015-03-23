clear all
close all
clc

% run MAT-taup modeling software from the SEIZMO package on GIT hub.
% https://github.com/g2e/seizmo
%
% TO INSTALL:
% 1 - These scripts require the included files:
% mattaup/lib/*.jar
% to be added in Matlab's javaclasspath. You may use the functions
% javaaddpath and javarmpath to alter the dynamic portion of the path.
javaaddpath('/Users/dmikesell/GIT/seizmo/mattaup/lib/MatTauP-2.1.1.jar');
%
% 2 - To install the scripts in Matlab, add this directory to the Matlab
% path. You may do this by using Matlab functions addpath, rmpath,
% and savepath. This can be done graphically in Matlab by going to
% File => Set Path. Setting the path may require administrative
% privileges. You should have already done this by adding the entire
% seizmo/ folder to your PATH.
%
% 3 - Type 'help mattaup' in Matlab to check if step 2 worked. Run some
% of the m-file functions listed to check if step 1 worked.
help mattaup

%% test 

taup


% tauptime('p','ttp','d',25)













