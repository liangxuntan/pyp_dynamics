%%%% read mtz converted txt and generate intensity matrix from
%%%% corresponding ML hkl
tic
disp([datestr(now) sprintf("read data...")]);

normT=0; %normalize all hkl value to frac of 1
%makemask=1;
%sparsity_fraction=0.03;

filename = 'light_5hd3.txt'; %light 3ps structure
fileID = fopen(filename);
fdata = textscan(fileID,'%d %d %d %f %*[^\n]','CollectOutput',1); 
fclose(fileID);
miller_h = fdata{1,1}(:,1); 
miller_k = fdata{1,1}(:,2);
miller_l = fdata{1,1}(:,3);
lighthkl=[miller_h miller_k miller_l];
T_light= fdata{1,2}(:,1);
clear fdata miller_h miller_k miller_l;

filename = 'dark_5hds.txt'; %dark
fileID = fopen(filename);
fdata = textscan(fileID,'%d %d %d %f %*[^\n]','CollectOutput',1); 
fclose(fileID);
miller_h = fdata{1,1}(:,1); 
miller_k = fdata{1,1}(:,2);
miller_l = fdata{1,1}(:,3);
darkhkl=[miller_h miller_k miller_l];
T_dark=fdata{1,2}(:,1);
clear fdata miller_h miller_k miller_l;

load ML_hkl.mat;
MLhkl=[miller_h miller_k miller_l];

% pick T for ML hkl
[~,common_light,MLidx1]=intersect(lighthkl,MLhkl,'rows');
[~,common_dark,MLidx2]=intersect(darkhkl,MLhkl,'rows');
[out1,idx1]=sort(MLidx1);
[out2,idx2]=sort(MLidx2);

if out1==transpose(1:15498)
    sort_light=common_light(idx1);
end

if out2==transpose(1:15498)
    sort_dark=common_dark(idx2);
end

check_equal = isequal(MLhkl(MLidx1(idx1),:),MLhkl(MLidx2(idx2),:),MLhkl);

if check_equal
    Ts_light=T_light(sort_light,:);
    Ts_dark=T_dark(sort_dark,:);
    Ts_light=Ts_light./1000; %scale down
    Ts_dark=Ts_dark./1000; %scale down
    clear T_dark T_light;
end

clear lighthkl darkhkl MLhkl common_dark common_light sort_dark sort_light MLidx1 MLidx2 out1 out2 idx1 idx2;

%normalize amplitudes
if normT
    sumTlight=sum(Ts_light);
    Ts_light=Ts_light./sumTlight;
    %checknorm = sum(Ts_light) % check
    sumTdark=sum(Ts_dark);
    Ts_dark=Ts_dark./sumTdark;
end
toc

%exponential decay
tic
disp([datestr(now) sprintf("exp func and initialize matrix")]);

tau1 = 1;
t_init = 0;
t_final =4;%% 4 time constants e^-4
snapshots = 147799;

t=linspace(t_init,t_final,snapshots);
ef_dark=exp(-tau1*t);
ef_light=1-ef_dark;
clear t;

Ts_light=transpose(Ts_light);
Ts_dark=transpose(Ts_dark);

[~,col_light]=size(Ts_light);
[~,col_dark]=size(Ts_dark);
check_equal2 = isequal(col_dark,col_light);

if check_equal2
    T_new = zeros([snapshots col_light]);
end

% make maskfile
%if makemask
    %M_new = zeros([snapshots col_light]);
%end

%%% load mask from 3ps data

load ML_mask.mat;
M_new=full(M);
clear M;

toc


%%%%%%%%%%%%%%%%%%%
%%% parallel loop
delete(gcp('nocreate'));   
jm=parcluster('local');
parpool(jm,32);

%%testing var
%parpool(jm,2);
%col_light=100;
%snapshots=1000;
%M_new=zeros(1000,100);
%T_new=zeros(1000,100);
%ef_dark=linspace(0,1,snapshots);
%ef_light=1-ef_dark;
%Ts_dark=[1:100];
%Ts_light=[1:100];

%tic
%disp([datestr(now) sprintf("starting mask loop \n\n")]);
%mask loop
%num_ones=round(sparsity_fraction*col_light);
%parfor (mrow=1:10000,30)
%parfor (mrow=1:snapshots,30)
%    M_row=zeros([col_light 1]);
%    M_row(randperm(col_light,num_ones))=1;
%    M_new(mrow,:)=M_row;
%end
%toc

tic
disp([datestr(now) sprintf("starting T parallel loop \n\n")]);
%parfor (ir=1:10000,30)
parfor (ir=1:snapshots,30)
    T_new(ir,:)=(M_new(ir,:).*Ts_dark*ef_dark(ir)+M_new(ir,:).*Ts_light*ef_light(ir)).^2;
end
toc
disp([datestr(now) "finish parallel loop"]);
delete(gcp('nocreate'));

T=sparse(T_new);
M=sparse(M_new);

save ("dataPYP_new_147799_15498.mat","T","M","miller_h","miller_k","miller_l","-v7.3");

