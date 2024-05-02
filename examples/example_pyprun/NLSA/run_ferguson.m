%run_ferguson.m 
%edited July 2022

% D: Distance matrix
% logEps: range of \epsilon values to try
% nS: number of snapshots as in dataY_nS*_nN*_sym.mat (just for the plot)
% nN: number of nearest-neighbors as in dataY_nS*_nN*_sym.mat (for the plot)
% a0: a vector of four random numbers
% plotFerg: 1 to plot the result, 0 otherwise
%
% Example of how to run this code: 
% - load dataY_nS*_nN*_sym.mat
% - logEps = [-20:0.2:40];
% - ferguson(sqrt(yVal),logEps,1*(rand(4,1)-.5),nS,nN,1);
%
% Notice: First run of this function may not converge to the right fit. If
% so, repeat until the fit (of the green curve to the blue curve) happens.
% Copyright (c) Ourmazd Lab, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%addpath('~/pyp_run11/dataPYP/dataY');

%load '~/pyphpcmain/dataPYP/dataY/dataY_nS115031_nN15000_sym.mat';
load './test_results/dataY_nS115031_nN15000_sym.mat';
logEps = [-20:0.2:40];
%parameters nS,nN by referring to input file dataY_nS*_nN*_sym.mat
nS = 115031;
nN = 15000;
ferguson(sqrt(yVal),logEps,1*(rand(4,1)-.5),nS,nN,0);