#!/usr/bin/env python
# coding: utf-8

# In[1]:


#get_ipython().run_line_magic('matplotlib', 'inline')
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import reciprocalspaceship as rs
import scipy.optimize as opt
import gemmi as gm
from tqdm import tqdm
import os
import sys

#extra required for xtalanalysis funcs
from skimage.restoration import denoise_tv_chambolle
import diptest
from scipy.stats import norm, kurtosis, skew, differential_entropy

import matplotlib
matplotlib.rc('xtick', labelsize=15) 
matplotlib.rc('ytick', labelsize=15)

#from xtal_analysis.xtal_analysis_functions import load_mtz, res_cutoff, scale, compute_weights, scale_iso
def load_mtz(mtz):
    """
    Loads mtz file (observed structure factors or intensities)

    Input :

	1. mtz file

    Returns :

	1. reciprocalspaceship object (effectively a pandas dataframe)

    """
    dataset = rs.read_mtz(mtz)
    dataset.compute_dHKL(inplace=True)
    
    return dataset
    
def compute_weights(df, sigdf, alpha):
    
    """
    Compute weights for each structure factor based on deltaF and its uncertainty

    Input :

	1. 1D numpy array of difference structure factors
	2. 1D numpy array of errors for the difference structure factors
	3. value of alpha to be used in the qweighting (as a float)

    Returns :

	1. 1D numpy array of 1/weights (to be multiplied with the array of deltaFs for weighting)

    """
    w = (1 + (sigdf**2 / (sigdf**2).mean()) + alpha*(df**2 / (df**2).mean()))
    return w**-1
    
def scale_iso(data1, data2, ds):

    """
    Isotropic resolution-dependent scaling of data2 to data1.
    (minimize [dataset1 - c*exp(-B*sintheta**2/lambda**2)*dataset2]

    Input :

    1. dataset1 in form of 1D numpy array
    2. dataset2 in form of 1D numpy array
    3. dHKLs for the datasets in form of 1D numpy array

    Returns :

    1. entire results from least squares fitting
    2. c (as float)
    3. B (as float)
    2. scaled dataset2 in the form of a 1D numpy array

    """
        
    def scale_func(p, x1, x2, qs):
        return x1 - (p[0]*np.exp(-p[1]*(qs**2)))*x2
    
    p0 = np.array([1.0, -20])
    qs = 1/(2*ds)
    matrix = opt.least_squares(scale_func, p0, args=(data1, data2, qs))
    
    return matrix, matrix.x[0], matrix.x[1], (matrix.x[0]*np.exp(-matrix.x[1]*(qs**2)))*data2


#from xtal_analysis.params import *
alpha         = 0.05
cell         = [66.9, 66.9, 40.8, 90, 90, 120]
space_group  = 'P63'
#grid_size    = [128, 160, 180]
grid_size    = [160, 160, 140]


# In[2]:
from pathlib import Path
path = Path("./runallqw.py")
getrootdir=((path.parent.absolute()).parent.absolute()).parent.absolute()
#print(getrootdir)

path         = '{rootdr}/makemaps/'.format(rootdr=getrootdir)

input1 = int(float(sys.argv[1]))
input2 = int(float(sys.argv[2]))


# In[3]:



def runallqw(numstart, numend):
    for x in range(numstart, numend+1):
        lightname="hkl_mode2_light_num{copy}_fobs.mtz".format(copy=x)
        
        calc  = load_mtz("{path}inputmaps/pdb5hd3_SFALL.mtz".format(path=path))
        off   = load_mtz("{path}inputmaps/hkl_mode2_dark_num1_fobs.mtz".format(path=path))
        on    = load_mtz("{path}inputmaps/{lightname}".format(path=path, lightname=lightname))
        data     = pd.merge(calc, off, how='inner', right_index=True, left_index=True, suffixes=('_calc', '_off'))
        data_all = pd.merge(data, on, how='inner', right_index=True, left_index=True, suffixes=('_off', '_on')).dropna()
        f_on    = np.array(data_all.F_on)
        f_off   = np.array(data_all.F_off)
        f_calc  = np.array(data_all.FC_ALL)
        qs = 1/(2*data_all['dHKL'])

        results_on, c_on, b_on, on_s     = scale_iso(f_calc, f_on,  np.array(data_all['dHKL']))
        results_off, c_off, b_off, off_s = scale_iso(f_calc, f_off, np.array(data_all['dHKL']))

        sig_on       = (c_on  * np.exp(-b_on*(qs**2)))  * data_all['SIGF_on']
        sig_off      = (c_off * np.exp(-b_off*(qs**2))) * data_all['SIGF_off']
        
        diffs = on_s - off_s
        sig_diffs = np.sqrt(sig_on**2 + sig_off**2)

        ws = compute_weights(diffs, sig_diffs, alpha=alpha)
        diffs_w = ws * diffs
        
        calc_new = calc.copy(deep=True)
        calc_new = calc_new[calc_new.index.isin(data_all.index)]
        calc=calc_new
        
        calc["DF"]    = diffs
        calc["DF"]    = calc["DF"].astype("SFAmplitude")
        calc["WDF"]   = diffs_w
        calc["WDF"]   = calc["WDF"].astype("SFAmplitude")
        calc["SIGDF"] = sig_diffs
        calc["SIGDF"] = calc["SIGDF"].astype("Stddev")
    
        calc.write_mtz("{path}outputmaps/diffmap_{alpha}_num{copy}.mtz".format(path=path, alpha=alpha, copy=x))

        print("converting " + lightname + " to dwmtz done")


# In[4]:


runallqw(input1,input2)


# In[ ]:




