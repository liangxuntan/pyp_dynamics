%%% check and add raw pyp variables to synthetic pypdata


load ../dataPYP_femto_nS147799_nBrg15498.mat M delay;
rM=M;
clear M;

load ./1k_dataPYP_new_147799_15498.mat;

if isequal(rM,M)
    clear rM;
    save new_dataPYP_femto_nS147799_nBrg15498.mat -v7.3
    disp("new file created")

end