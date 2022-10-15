% scriptReconstruction
% loads the reconstructed data files and adds them up.
% Selected modes utilized during the adding process.
% copyright (c) Ourmazd Lab, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 

nS = 147799;       % # of snapshots before concat. 
nC = 32768;        % concatenation order 
nN = 15000;        % # of nearest-neighbors   
numFiles = 6;     % # of reconstruced data files out of myParallel_reconst
kOfInterest_new = [2]; % # of desired modes for the reconstruction M2-M3

% to load mask M corresponding to data matrix T:
file_Orig = '~/pyp_run10/dataPYP/dataPYP_femto_nS147799_nBrg15498.mat';

% to load reconstructdata from step(8)
sharedir_reconstruct = '~/pyp_run10/NLSA/'

% too store the output:
fileReconst  = 'dataPYP_femto_reconst';

load(file_Orig,'M');
M_rec = M(nC+1:end-nC,:);

X_ = cell(1, numFiles);
kn = kOfInterest_new;

for fileID = 1:numFiles
 file1 =[sharedir_reconstruct,'reconstructedData_',int2str(fileID),'_of_',int2str(numFiles),'.mat'];
 load( file1, 'X' );
 X_{fileID} = squeeze(sum(X(kOfInterest_new,:,:) , 1));
 disp([datestr(now) sprintf(',  fileID#%d done.',fileID)])
end

T_rec = cat(2 , X_{1 : numFiles});

T_rec = sparse(T_rec');      

[nS_rec , nBrg_rec] = size(T_rec);

disp(['size of T_rec = ',num2str(size(T_rec)) ]);

%--------------------------------------------------------------------------
% saving
disp('saving ...');
fileRec=[int2str(kOfInterest_new),'_',fileReconst,'_nS',int2str(nS),'_nC',int2str(nC),...
       '_nN',int2str(nN),'.mat'];
save( fileRec, 'T_rec', 'M_rec', 'kOfInterest_new' , '-v7.3' );

%
% EOF

