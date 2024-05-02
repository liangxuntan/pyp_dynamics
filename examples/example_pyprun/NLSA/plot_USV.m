% plot_USV
%
% copyright (c) Ourmazd Lab 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('./Utilities');
set(0,'DefaultAxesFontSize',16);
set(0,'DefaultLineLineWidth', 2);
set(0,'defaultfigurecolor','w')

% % First, load SVD results:
%load('SVD_results_sigma1420.00.mat')
load('SVD_results_sigma0.29.mat')

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
% % plot singular values

hs = figure('visible', 'off'); 
set(hs, 'Position', [100, 100, 1000, 900]); % size & position of figure on screen
HA = tight_subplot(1,1,[.08 .08],[.11 .11],[.11 .03]);
axes(HA(1));

Sing = diag(S);
bar((Sing(1:end)),'FaceColor','r');

set(gca,'linewidth',2)
xlabel('Singular value #','FontSize',16,'FontWeight','bold','Color','k'); 
yLabel = ylabel('Singular value','FontSize',16,'FontWeight','bold','Color','k'); 
set(yLabel, 'Units', 'Normalized', 'Position', [-0.07, 0.5, 0]);

title("singularvalues");

if saveFig
  FIG_singulars= sprintf('Fig_singVals_%s_nS%d_nC%d_nN%d_sigmaDM%d',...
                          dataID, nS, nC, nN, sigmaDM);                                            
  print(fullfile(figsDir, FIG_singulars),figFormat,'-r300');
end

%##########################################################################
%##########################################################################
% % plot topos

s = 0;
nn = 0;
colorspec = colormap(jet(nTopo)*0.8);   
for tp=1:nTopo  % # of topos considered
  if mod(tp,ell+1)==1 
     s = 0; 
     nn = nn+1; 
     ht = figure('visible', 'off'); 
     set(ht, 'Position', [100, 100, 850, 1200]); 
     HA = tight_subplot(ell+1,1,[.02 .05],[.07 .07],[.1 .03]);
  end
  s = s + 1;
  axes(HA(s));
  %%%%%%%%%%%%%%%%%%%%%% making the average of topos
  U_sum = zeros(nBrag,1);
  for jj=1:num_copy
    i0 = (jj-1)*nBrag+1;
    i1 = i0+nBrag-1;
    U_sum = U_sum+U(i0:i1,tp);
  end
  U_avg = U_sum/num_copy;
  %%%%%%%%%%%%%%%%%%%%%%%
 %Topo = U(1:nBrag,tp); % just the first copy  
  Topo = U_avg; % average of all copies
  
  color = colorspec(tp,:);
  %color = [0.2 0.2 0.8];
  plot(Topo,'LineWidth',3,'Color',color); hold on;
  set(gca,'linewidth',2)
  ylim([min(Topo)-abs(min(Topo))/10,max(Topo)+abs(max(Topo))/10])
  xlim([0 nBrag+50]);
  %set(gca,'xTick',[]);
  %set(gca,'yTick',[]);
  yLabel = ylabel(['U',int2str(tp)],'FontSize',16,'FontWeight','bold','Color','k');
  set(yLabel,'Rotation',0, 'Units', 'Normalized', 'Position', [-0.05, 0.5, 0]);
  if mod(tp,ell+1)~=0
     %set(gca,'xTick',[])
     set(gca,'Xticklabel',[])
  end
  if mod(tp,ell+1)==0
     xlabel('# of Reflections','FontSize',16,'FontWeight','bold','Color','k');
  end 
  if s==1, title("topos"); end

  if saveFig
    FIG_topos= sprintf('Fig%d_Topos_%s_nS%d_nC%d_nN%d_sigmaDM%d',...
                        nn, dataID, nS, nC, nN, sigmaDM);                       
    print(fullfile(figsDir, FIG_topos),figFormat,'-r300');
  end    

end
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


   plot(delay_,Chrono,'LineWidth',3,'Color',color); hold on;

   set(gca,'linewidth',2);
   if cr==1
       ylim([-2 2]);
   end
   if cr==2
       ylim([-2 2]); %chrono 2
   end
   if cr==3
       ylim([-2 2]);%chrono 3
   end
   if cr==4
       ylim([-2 2]); %chrono 4
   end
   if cr==5
       ylim([-2 2]);
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