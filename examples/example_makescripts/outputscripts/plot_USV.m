% plot_USV
%
% copyright (c) Ourmazd Lab 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('./Utilities');
set(0,'DefaultAxesFontSize',16);
set(0,'DefaultLineLineWidth', 2);
set(0,'defaultfigurecolor','w')

% % First, load SVD results:
load('SVD_results_sigma1420.00.mat')

% % the following params should match the data files of DM and SVD results:
nC = 32768;        % concatenation order
nS = 147799;      % # of snapshots (in the original data file)
nN = 15000;        % # of nearest-neighbors in used for embedding
nBrag = 15498;    % # of Bragg points
num_copy = 1000;  % # of copies used for SVD analysis
ell = 4;          % # of \psi's used for projecting

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t0 = 284.67;      %average of time span in the first concat window (in fs)
delta_t = 0.0074; %time interval between two successive data-points (in fs)
delay_ = t0 + delta_t*(1:nS-2*nC);
V = V(1:end-nC,:);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveFig = 0;
figFormat = '-dpng';
if saveFig && ~exist('FIGS_svd', 'dir')
  figsDir = mkdir('FIGS_svd');
end
dataID = 'femtosecond';
myTitle = sprintf('PYP-%s',dataID);

[DT,nTopo] = size(U);
[DC,nChrono] = size(V);
if nBrag~=(DT/num_copy) 
  error('num_copy must be the same as in "run_PYP_femtosec_concat_x_USV.m"'); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % setup figure names and titles

titleChronos =sprintf(['\\fontsize{16}{\\color{red}',myTitle,', Chronos}\n' ...
  '\\fontsize{14}{(nS=',int2str(nS),', nC=',int2str(nC),', nN=',int2str(nN),')}']);

%##########################################################################
% % plot cronos in data space:

V_dataSpace = V; %chronos already projected back onto data-space

%flip Y axis - july22
V_dataSpace = V_dataSpace.*-1;

s = 0;
nn = 0;
colorspec = colormap(jet(nChrono)*0.8);   
for cr=1:nChrono
    if mod(cr,ell+1)==1 
     s = 0; 
     nn = nn+1; 
     hc = figure('visible', 'off'); 
     set(hc, 'Position', [100, 100, 850, 1200]); 
     HA = tight_subplot(ell+1,1,[.02 .05],[.07 .07],[.1 .03]);
    end
   s = s + 1; 
   axes(HA(s));
   Chrono = V_dataSpace(:,cr);
   color = colorspec(cr,:);

   if cr==4
       Chrono = Chrono.* -1;
   end

   if cr==1
       Chrono = Chrono.* -1;
   end

   plot(delay_,Chrono,'LineWidth',3,'Color',color); hold on;

   set(gca,'linewidth',2);
   if cr==1
       ylim([0 2]);
   end
   if cr==2
       ylim([-1.3 1.2]); %chrono 2
   end
   if cr==3
       ylim([-3.2 1.2]);%chrono 3
   end
   if cr==4
       ylim([-1.4 2.2]); %chrono 4
   end
   if cr==5
       ylim([-4.3 2]);
   end
   xlim([280 900]);

   yLabel = ylabel(['V',int2str(cr)],'FontSize',20,'FontWeight','bold','Color','k');
   set(yLabel,'Rotation',0, 'Units', 'Normalized', 'Position', [-0.08, 0.5, 0]);

   if mod(cr,ell+1)~=0
     %set(gca,'xTick',[])
     set(gca,'Xticklabel',[])
   end
   if mod(cr,ell+1)==0
     %xlabel('Snapshot #','FontSize',20,'FontWeight','bold','Color','k');
     xlabel('delay time (fs)','FontSize',20,'FontWeight','bold','Color','k');
   end 
   if s==1, title(titleChronos); end
      
   if saveFig
     FIG_chronos= sprintf('Fig%d_Chronos_%s_nS%d_nC%d_nN%d_sigmaDM%d',...
                        nn, dataID, nS, nC, nN, sigmaDM);                 
     print(fullfile(figsDir, FIG_chronos),figFormat,'-r300');
   end     
end

%
% EOF