%edited August 2022
%v2-meanI and SIGI w/o zeros
%v3-sum mode 1 and 2
%v4-add 'end of reflections'

load('2_dataPYP_femto_reconst_nS147799_nC32768_nN15000.mat'); %snapshotsxrflc
T_rec1=T_rec;
clear('T_rec');
load('1_dataPYP_femto_reconst_nS147799_nC32768_nN15000.mat');
T_rec2=T_rec;
clear('T_rec');
T_rec=T_rec1+T_rec2;

param.merge = 204; %#snapshots to merge
param.mode = '2';
param.type = 'light';

T_rec = T_rec.*1e6; %scale by 1e6
[row1,col1]=size(T_rec);
nframe=fix(row1/param.merge);
T_merge=zeros(nframe,col1);
sigi=zeros(nframe,col1);

timer1=tic;

for i=1:nframe

    %merge intensity
    startrow = (i-1)*param.merge+1;
    lastrow = i*param.merge;
    currentwindow = T_rec(startrow:lastrow,:);
    %iframe = sum(T_rec(startrow:lastrow,:),1)/param.merge; %mean intensity over merge window
    %riframe = round(iframe,3);

    %mean intensity without zeros
    iframe=zeros(1,col1);
    for refcol=1:col1
        inzcol=currentwindow(:,refcol);
        inz=sum(inzcol)/nnz(inzcol);
        iframe(1,refcol)=inz;
    end
    iframe(isnan(iframe))=0;
    Tmerge(i,:) = iframe;

    %sigI
    
    si = zeros(1,col1);
    %sigI without zeros
    for wincol=1:col1
        snzcol=nonzeros(currentwindow(:,wincol));
        snz=std(snzcol,0);
        %replace nan with zero
        %snznan=isnan(snz);
        %snz(snznan)=0;
        si(1,wincol)=snz;
    end
    si(isnan(si))=0;
    %si = std(currentwindow,0);
    sigi(i,:) = si;

end

toc(timer1);

save('reconst_merge.mat','Tmerge','sigi');
%writematrix(Tmerge, 'reconst_merge.txt','Delimiter','tab');
%system('mv reconst_merge.txt reconst_merge.hkl');

%assemble hkl files from reconst_merge

load 'reconst_merge.mat'; % Nx150 for Tmerge,sigi
load ('~/pyp_run11/dataPYP/dataPYP_femto_nS147799_nBrg15498.mat', ...
    'miller_h','miller_k','miller_l'); % 150x1 for miller_h/k/l
[row2,col2]=size(Tmerge);
%se=ones([col2 1])*round(1.001,2);

%hkl tail file
tailtxt = "'End of reflections'";
createtailtxt=sprintf("echo %s > hkl_tail.txt",tailtxt);
system(createtailtxt);

timer2=tic;

for j=1:row2
    intcol = Tmerge(j,:)';
    secol = sigi(j,:)';
    hklmat = [miller_h miller_k miller_l intcol secol];
    filenametxt = sprintf('hkl_mode%s_%s_num%i.txt',param.mode,param.type,j);
    filenamehkl = sprintf('hkl_mode%s_%s_num%i.hkl',param.mode,param.type,j);
    filenametemp = sprintf('hkl_%i.txt',j);

    %writematrix(hklmat,filenametxt,'Delimiter','tab');
    
    system(['touch ' filenametemp]);
    fileID = fopen(filenametemp,'w');
    hklmat_t = hklmat';
    %fprintf(fileID,'%5d %4d %4d %11.3f %5.2f\n',hklmat_t);
    fprintf(fileID,'%5d %4d %4d %11.3f %11.3f\n',full(hklmat_t));
    fclose(fileID);

    system(['cat ' filenametemp ' hkl_tail.txt > ' filenametxt]);
    system(['mv ' filenametxt ' ' filenamehkl ]);
    system(['rm ' filenametemp]);

end

toc(timer2);

system('mkdir hkl_files');
system('mv *.hkl hkl_files');
system(['rm hkl_tail.txt']);
%eof