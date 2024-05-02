#make scripts for NLSA pipeline
#make job scripts to run NLSA on Imperial's HPC
##################################################
#edited May 24

1) injectnoise - adds gaussian noise to the timing of each snapshot in dataPYP intensity matrix and reorder them. 
Parameters: 
sig - stddev parameter of normal distribution curve
numss - number of snapshots in dataPYP matrix

2) Make linear combination of light and dark states as synthetic input data. Run run_makepypdata_2.m and checknewdataPYPmask.m to generate synthetic matrix. 
Required files:
	pdbs of both states
	CCP4 for SFALL function to convert pdb to mtz
	python reciprocal_spaceship module to read mtz into dataframe and convert to readable format for matlab
	save mask files from raw dataPYP as separate file for input to run_makepypdata
	


