% run_PYP_femtosec_concat_x_no_normalize
% 
% copyright (c) Russell Fung 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  param.env1=getenv('EPHEMERAL');
  addpath('~/pyp_run10/sna/release/2.0/connecting',...
          '~/pyp_run10/sna/release/2.0/core',...
          '~/pyp_run10/sna/release/2.0/validation',...
          '~/pyp_run10/sna/release/2.0/variations')
  D = 15498;           % # of pixels (Bragg points)
  N = 147799;          % # of snapshots before concatenation
  nN = 15000;           % # of nearest-neighbors for distance symmetrization
  numTasks = 6;       % # of tasks on the cluster    numtask set to 6 to satisfy n>nN             
  concatOrder = 32768;  % concatenation order
  n = ceil((N-concatOrder)/numTasks); % should be larger than nN
  %mkdir ~/pyphpcmain/dataPYP/worker;
  
%%%%%
% data parameters
% data file located on the computer cluster:
 param.rawDataFile = ['~/pyp_run10/dataPYP/dataPYP_femto_nS147799_nBrg15498.mat'];
 param.maskFile = ['~/pyp_run10/dataPYP/dataPYP_femto_nS147799_nBrg15498.mat'];
% data must first be uploaded onto the worker nodes
%
 param.rawDataVar = 'T';  % data matrix
 param.maskVar = 'M';         % mask

 param.io_format = 'double';
 param.D = D;
 param.N = N;
 param.n = n;
 param.c = concatOrder;
%%%%%
% local machine parameters
%  local machine is where you are sending the jobs from
%
  %param.local_hostname = 'localServer.uwm.edu';
  param.local_destination = 'test_results/';
%%%%%
% remote cluster parameters
%  remote cluster is where you are sending the jobs to
%
  %param.remote_hostname = 'remoteCluster.uwm.edu'; 
  userID = get_username();
  param.username = userID;
  rng shuffle;
  param.rnum = num2str(randi(9999,1));

  %param.share_directory = ['~/pyphpcmain/dataPYP/dataY/'];
  system(['mkdir ' param.env1 '/dataY_' param.rnum]);
  param.share_directory = [param.env1 '/dataY_' param.rnum '/'];

  %param.worker_directory_prefix = ['~/pyphpcmain/dataPYP/worker/worker_' userID '_']; % on worker nodes
  param.workerattach=[param.env1 '/worker_' param.rnum];
  system(['mkdir ' param.workerattach]);
  param.worker_directory_prefix = [param.workerattach '/worker_'];

%%%%%
  parallel_SnA_with_masks_no_norm
  
  nB = N-concatOrder;
  numFile = 1;   % (N-concatOrder) = nB * numFile
  io_format = param.io_format;
  directory = param.local_destination;
  fileName_template = ['dSq_N' num2str(N) '_n' num2str(n) '_c%d_row%d_col%d.dat'];

  %%%%%%%%%%
  make_dataY_files
  scriptDistanceSymmetrization
  %%%%%%%%%%

  %system(['rm -rf ' directory]);
  system('rm -f dataY*iB*');
  %system(['mv dataY*sym.* ' param.share_directory]);
  system(['mv dataY*sym.* ' param.local_destination]);
  
% end run_PYP_femtosec_concat_x_no_normalize
