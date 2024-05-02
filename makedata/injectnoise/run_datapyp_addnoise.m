inputmatrix='~/pyphpcmain/dataPYP/dataPYP_femto_nS147799_nBrg15498.mat';

%parameters
sig=[100];
numss=147799;

tic
for isig=sig
    getmat(isig,numss,inputmatrix);
end
toc

function timedelay = calctn(sig,numss)
    [row1,col1] = size(numss);
    %idelay=[1:row1-1]'.*7.35;
    idelay=[0:row1-1]'.*7.35;
    %noise = normrnd(0,sig,[row1-1 1]);
    noise = normrnd(0,sig,[row1 1]);
    timedelay = idelay + noise;

end

function [newind,sortedtime] = sortdelay(delaytime)
    [sortedtime,indst]=sort(delaytime);
    %newind =[1;indst+1];
    newind = indst;

end

function filename=outputnewmat(inputmatrix,newind,nameext,delmat)
    path=sprintf('%s',inputmatrix);
    load (path);
    [row1,col1]=size(T);

    Tnew=sortrows([newind T],1);
    Tnew2=Tnew(:,2:(col1+1));
    T=sparse(Tnew2);

    Mnew=sortrows([newind M],1);
    Mnew2=Mnew(:,2:(col1+1));
    M=sparse(Mnew2);

    delay=delmat;
    order=newind;

    filename=sprintf('dataPYP_femto_nS147799_nBrg15498_sig%.1f.mat',nameext);
    save(filename,"M","T","delay","miller_h","miller_k","miller_l","order","-v7.3");
end

function getmat(sig,numss,inputmatrix)
    tnew=calctn(sig.*1000,zeros([numss 1]));
    [indexnew,delaynew]=sortdelay(tnew);
    name=outputnewmat(inputmatrix,indexnew,sig,delaynew);
    system(['mv ' name ' ../dataPYP']);
end