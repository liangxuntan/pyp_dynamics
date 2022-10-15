% run_PYP_femtosec_concat_x_USV
%
  addpath('~/pyp_run10/sna/release/2.0/connecting',...
          '~/pyp_run10/sna/release/2.0/core',...
          '~/pyp_run10/sna/release/2.0/validation',...
          '~/pyp_run10/sna/release/2.0/variations', ...
          '~/pyp_run10/dataPYP', ...
          '~/pyp_run10/dataPYP/dataPsi')
% loading data file located on the local host machine
load('~/pyp_run10/dataPYP/dataPYP_femto_nS147799_nBrg15498.mat','T');
X1 = T'; 
sigmaOpt=1420;
sigmastr=sprintf('%3.2E',sigmaOpt);
dataPsi_template=(['~/pyp_run10/dataPYP/dataPsi/dataPsi_nS115031_nN15000_nA0_sigma' sigmastr '_nEigs4.mat']);
read_format = 'double';
D = 15498;          % # of pixels (Bragg points)
N = 147799;         % # of snapshots before concatenation
n = 19172;           % compatible with dp_N*_n*_c* folder
concatOrder = 32768; % concatenation order
num_copy = 1000;    % # of copies (topos) for unwrapping
ell = 4;            % # of \psi's for projecting
%ell = 2;

sigmaList0 = 10.^linspace(log10(sigmaOpt/10),log10(sigmaOpt),7);
sigmaList1 = 10.^linspace(log10(sigmaOpt),log10(sigmaOpt*20),10);
sigmaList = unique([sigmaList0 sigmaList1]);

% compute SVD for different sigma values (sigma search)
for jj=7%1:16 %(jj=7 gives sigmaList=1)
  sigma = sigmaList(jj);
  dataPsi = sprintf(dataPsi_template,num2str(sigma,'%.4f'));
  [U,S,V] = extract_topos_chronos(ell,X1,dataPsi,read_format,D,N,n,concatOrder,num_copy);
  fileNameUSV = ['SVD_results_sigma' num2str(sigma,'%.2f') '.mat'];
  save(fileNameUSV,'U','S','V','-v7.3')
end

%EOF