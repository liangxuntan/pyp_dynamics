#!/usr/bin/env python
# coding: utf-8

import reciprocalspaceship as rs
import pandas as pd 
import numpy as np
from pathlib import Path

parentdir = Path("/Users/liangxuntan/Desktop/pypscripts/pyp_syndat")

def load_mtz(mtz):
    
    dataset = rs.read_mtz(mtz)
    #dataset.compute_dHKL(inplace=True)
    
    return dataset

calc1  = load_mtz("{path}/light_5hd3_SFALL.mtz".format(path=parentdir))
calc2  = load_mtz("{path}/dark_5hds_SFALL.mtz".format(path=parentdir))
#print(calc.head())
#print(type(calc))
mat1 = pd.DataFrame(calc1)
mat2 = pd.DataFrame(calc2)
#print(mat1.head())
#print(type(mat1))
mat1.to_csv("{path}/light_5hd3.txt".format(path=parentdir), header=None, index=1, sep='\t', mode='w')
mat2.to_csv("{path}/dark_5hds.txt".format(path=parentdir), header=None, index=1, sep='\t', mode='w')
