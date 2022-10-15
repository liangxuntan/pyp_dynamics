README file for making DED videos using HKL files
Liangxun Tan 2022
Edited Oct 2022
##################################################
//Put folder in User home dir (example- /Users/<name>/makemaps or ~/makemaps)

1)put HKL files in inputhkl/hkl_mode*_light_num*.hkl 
//both light and dark (see pyp_dataset for example)

2)cd /f2scripts
// >>./run_hkl2pml.sh (A) (B)
//A=firstlightnum B=lastlightnum 
//example hkl_mode*_light_num1.hkl to hkl_mode*_light_num100.hkl //A=1 B=100

3)run makepng_A_B.pml in /pymscripts 
//all output images in /pymscripts/pngfiles

4)on macos, launch quicktime
// go to >>File>>Open Image Sequence to make .mov using .png in /pymscripts/pngfiles

##################################################
//use >>./cleanall.sh to clear all data files
//log messages: h2plog.txt 

//Programs required: Pymol, CCP4, Phenix


Reference: "Few-femtosecond resolution of a photoactive protein traversing a conical intersection", A. Hosseinizadeh et al., Nature 599, 697-701 (2021).


