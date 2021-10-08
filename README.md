# sCMOS_DDM
#### Language: Matlab
Differential Dynamic Microscopy algorithm, that works with videos in proprietary format (.sifx) of Andor sCMOS cameras (Zyla).

---
Differential Dynamic Microscopy is the counterpart of DLS and can be employed to measure diffusion constants. Instead of using a laser and detect/correlate the light scattered of the sample here a simply light microscope can be employed. A video of the sample is acquired and later the indvidual frames get correlated. More information on the DDM algortihm can be found elsewhere:

[Differential Dynamic Microscopy to characterize Brownian motion and bacteria motility (arXiv:1511.00923v1)](https://arxiv.org/abs/1511.00923v1)
[Differential Dynamic Microscopy: Probing Wave Vector Dependent Dynamics with a Microscope (Phys. Rev. Lett. 100, 188102)](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.100.188102)


sCMOS cameras can reach fast framerates and large field of views and hence, they generate large files during acquisition. Therefore, Andor cameras spool the data directly to a disc utilizing a proprietary .sifx format. Opening the files with Andor SOLIS Software and exporting them takes a ot of time and usually looses information due to video compression.

Instead, this project opens and processes the .sifx files directly in Matlab. This can save a lot of time and provides a convenient nan easy way for further evaluation.

**How to use?** 
In DDM_Script.m adjust the parameters:
- <code>pxsz</code> pixel size of your detector
- <code>limit_t</code> iteration limit (to keep the calculation time tolerable)
- <code>timesteps</code> A vector containing the computed timesteps (lower the number of timesteps to keep calculation time small)
Then run the file and choose the .sifx file to be evaluated in the following dialog.

---
**NOTE: The DDM_radialavg.m file is not my work! It was written by David J. Fischer:**

[David Fischer (2018). radialavg.zip, MATLAB Central File Exchange. Retrieved October 7, 2018.](https://www.mathworks.com/matlabcentral/fileexchange/46468-radialavg-zip)
