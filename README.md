
 README
 ----------
This is implementation of our paper:

A. A. Joshi, A. J. Chaudhari, C. Li, J. Dutta, S. R. Cherry, D. W. Shattuck, A. W. Toga and R. M. Leahy, DigiWarp: a method for deformable mouse atlas warping to surface topographic data, Physics in Medicine and Biology, 55(20), 6197-6214.[link](http://dx.doi.org/10.1088/0031-9155/55/20/011)

![Digiwarp](https://iopscience.iop.org/0031-9155/55/20/011/downloadFigure/figure/pmb354584fig02)


* Start by downloading Digimouse atlas: [Download Digimouse Atlas](https://neuroimage.usc.edu/neuro/Digimouse).

* There are 2 main scripts.
`main_select_points_for_reorientation.m` and `main_digiwarp.m`

* Start with `main_select_points_for_reorientation.m`.
Please read comments in the matlab script. You can use this script to select a set of initial points on the subject and atlas to get an approximate alignment.
Here is a screenshot of point selection process:

![selecting points](digimouse_select_pts.png)

For points selection process, please check our paper above. 

* Then run `main_digiwarp.m` script. Make sure that all the variables in this script are properly initialized to the desired values.
This script will run for some time (~30 min) and generate the outputs in the output directory that you configured in the main script. The output will be warped volume and warped tetrahedral mesh.
