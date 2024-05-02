% parallel_reconstruct
% 
% copyright (c) Russell Fung 2013
% some updates by A. Hosseini 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% user section #1 BEGIN %
%%%%%%%%%%%%%%%%%%%%%%%%%
% % initializations:
D = 15498;                 % # of pixels (Bragg points)
concatOrder = 32768;        % concatenation order
nS = 115031;               % # of snapshots AFTER concatenation (# of chronos)  
c0 = 1;                    % keep it always 1
ell = 4+1;                   % # of of chronos
kOfInterest = [1:ell];     % the modes we take into account (<=ell)
copyOfInterest = [1:1000]; % # of copies, must be <= concatOrder
tOfInterest = concatOrder+[1:nS-concatOrder];  
numTasks = 6;             % # of tasks on the cluster

%myClusterProfile = '[your MATLAB parallel profile name]'; % Matlab parallel profile name                            
myCluster = parcluster('local');                              
disp(myCluster.Profile);                                               

% destination directory on the remote cluster (to be adjustd by user):
shareDir = '~/pyp_run11/NLSA/';
% local directory on the remote cluster:
localDir = '~/pyp_run11/NLSA/';  
logfile_template = [shareDir 'reconstruct_%d_of_' num2str(numTasks) '.log'];
dataSVD = [localDir,'SVD_results_sigma0.29.mat'];
reconstructedData_template = [shareDir,'reconstructedData_%d_of_',num2str(numTasks),'.mat'];

param.D = D;
param.concatOrder = concatOrder;
param.c0 = c0;
param.kOfInterest = kOfInterest;
param.copyOfInterest = copyOfInterest;
param.dataSVD = dataSVD;
%%%%%%%%%%%%%%%%%%%%%%%
% user section #1 END %
%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%
% setup
msg = sprintf('\n\nset up the cluster, create the jobs ...\n\n');
disp(msg)
tic

currentDirectory = pwd;

for nn=1:numTasks

%%%%%%%%%%%%%%%%%%%%%%%%%
% user section #2 BEGIN %
%%%%%%%%%%%%%%%%%%%%%%%%%
  num_t = numel(tOfInterest);
  num_t_per_task = ceil(num_t/numTasks);
  i0 = (nn-1)*num_t_per_task+1;
  i1 = min(i0+num_t_per_task-1,num_t);
  param.tOfInterest = tOfInterest(i0:i1);

  % creats an independent job object for the identified cluster
  job{nn} = createJob (myCluster);  % we can attach files to this as well    
           
  param.logfile = sprintf(logfile_template,nn);
  param.reconstructedData = sprintf(reconstructedData_template,nn);
  createTask(job{nn},@reconstruct,1,{param});

%%%%%%%%%%%%%%%%%%%%%%%
% user section #2 END %
%%%%%%%%%%%%%%%%%%%%%%%
  submit(job{nn});
  disp([datestr(now) sprintf('  task#%d submitted',nn)])
end

toc
%%%%%%%%%%
% submit the job and wait
msg = sprintf('\n\nsubmit the jobs, work on the jobs ...\n\n');
disp(msg)
tic

results = cell(numTasks,1);
InProgress = [1:numTasks];
while ~isempty(InProgress)
  for id = InProgress
    if strcmp(job{id}.State,'finished')
      disp([datestr(now) sprintf('  task#%d completed',id)])
      results{id} = fetchOutputs(job{id}); 
      disp([datestr(now) sprintf('  task#%d results downloaded',id)])
%%%%%%%%%%%%%%%%%%%%%%%%%
% user section #3 BEGIN %
%%%%%%%%%%%%%%%%%%%%%%%%%

      if (~isempty(results{id}))
        status = results{id}{1};
        disp([datestr(now) sprintf('  task#%d returns %d',id,status)])
      else
        disp([datestr(now) sprintf('  task#%d failed',id)])
      end

%%%%%%%%%%%%%%%%%%%%%%%
% user section #3 END %
%%%%%%%%%%%%%%%%%%%%%%%
      InProgress = setxor(InProgress,id);
    end
  end
end

toc
%%%%%%%%%%
% clean up
msg = sprintf('\n\ncleaning up ...\n\n');
disp(msg)
tic

for nn=1:numTasks
  destroy(job{nn});
end

toc
%%%%%%%%%%
% EOF