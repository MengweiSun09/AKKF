Project:  AKKF\Single target tracking\Bearing-only 

This project demonstrates the application of the **Adaptive Kernel Kalman Filter (AKKF)** for tracking a single target with bearing-only radar data in non-linear and non-Gaussian environments. The AKKF leverages kernel transformations to embed probability distributions in high-dimensional spaces, providing precise tracking with reduced computational load. This implementation compares the AKKF with a Bootstrap Particle Filter (PF) to highlight the advantages of the AKKF approach.

**Getting Started**
> -  **Run the Code:** Begin by executing "Main.m"  in MATLAB. This will initiate the tracking process, allowing you to select parameters and compare results between the AKKF and the PF.
> -  **Configuration:** You can select the kernel type and the number of particles for both the AKKF and PF. Adjust these settings as needed for your analysis.
> -  **Kernel Parameters:** The kernel parameters for the AKKF can be customised in "AKKF_track.m" under **Section 0. AKKF parameters setting.**

**File Descriptions**

> 1. Main.m: The main script to run the tracking simulation, initiate parameters, and execute the tracking functions.
> 2. AKKF_track.m: Contains the tracking logic for the Adaptive Kernel Kalman Filter.
> 3. AKKF_predict.m: Implements the prediction step for the AKKF.
> 4. AKKF_update.m: Handles the update step for the AKKF, incorporating new observations.
> 5. AKKF_proposal.m: Computes proposal distributions for AKKF.
> 6. PF_track.m: Provides the tracking implementation for the Bootstrap PF.
> 7. Target_generation.m: Generates target motion for simulation purposes using a constant velocity model.
> 8. Tracking_performance.m: Evaluates and visualises tracking performance metrics.
> 9. mgd.m: Utility function for managing multivariate Gaussian distributions.


**Additional Resources**

> - For theoretical background on the AKKF, please refer to the paper "Adaptive Kernel Kalman Filter" in _IEEE Transactions on Signal Processing_: https://ieeexplore.ieee.org/abstract/document/10064092.
> - The corresponding Python implementation of the AKKF is available on the Stone Soup Platform: https://stonesoup.readthedocs.io/en/v1.4/auto_tutorials/filters/AKKF.html#sphx-glr-auto-tutorials-filters-akkf-py.
