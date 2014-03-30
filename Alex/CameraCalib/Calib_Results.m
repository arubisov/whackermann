% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 533.855256245525990 ; 529.518030225685380 ];

%-- Principal point:
cc = [ 307.800553872510870 ; 272.806766559932040 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ 0.179653890262604 ; -0.313271564591985 ; 0.005416793233274 ; -0.008204342872750 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 6.809954821852307 ; 6.695289455506722 ];

%-- Principal point uncertainty:
cc_error = [ 4.033290340509057 ; 4.518571529203871 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.019226513844759 ; 0.032971135483639 ; 0.002662282892312 ; 0.002664181963531 ; 0.000000000000000 ];

%-- Image size:
nx = 640;
ny = 480;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 14;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 2.018893e+00 ; 2.222909e+00 ; -7.942399e-01 ];
Tc_1  = [ 1.398495e+02 ; 4.973709e+01 ; 6.968614e+02 ];
omc_error_1 = [ 1.037515e-02 ; 8.507254e-03 ; 1.941194e-02 ];
Tc_error_1  = [ 5.299772e+00 ; 5.968595e+00 ; 9.084202e+00 ];

%-- Image #2:
omc_2 = [ 2.192430e+00 ; 2.113274e+00 ; 4.163422e-01 ];
Tc_2  = [ 1.703619e+02 ; -6.780599e+01 ; 6.247728e+02 ];
omc_error_2 = [ 1.061089e-02 ; 5.363452e-03 ; 1.021281e-02 ];
Tc_error_2  = [ 4.898110e+00 ; 5.370368e+00 ; 8.554011e+00 ];

%-- Image #3:
omc_3 = [ NaN ; NaN ; NaN ];
Tc_3  = [ NaN ; NaN ; NaN ];
omc_error_3 = [ NaN ; NaN ; NaN ];
Tc_error_3  = [ NaN ; NaN ; NaN ];

%-- Image #4:
omc_4 = [ 1.720568e+00 ; 2.032713e+00 ; -7.441588e-01 ];
Tc_4  = [ -6.725906e+01 ; 6.318404e+01 ; 7.086337e+02 ];
omc_error_4 = [ 6.813849e-03 ; 9.599016e-03 ; 1.287870e-02 ];
Tc_error_4  = [ 5.296456e+00 ; 6.076444e+00 ; 8.957142e+00 ];

%-- Image #5:
omc_5 = [ -1.659997e+00 ; -2.102332e+00 ; 2.692099e-01 ];
Tc_5  = [ 5.478616e+00 ; -2.439176e+02 ; 6.070416e+02 ];
omc_error_5 = [ 7.892591e-03 ; 6.968906e-03 ; 1.197430e-02 ];
Tc_error_5  = [ 4.750615e+00 ; 5.212359e+00 ; 8.086808e+00 ];

%-- Image #6:
omc_6 = [ -1.877801e+00 ; -2.224975e+00 ; -1.059829e+00 ];
Tc_6  = [ -2.107218e+02 ; -2.361277e+02 ; 5.323878e+02 ];
omc_error_6 = [ 8.128250e-03 ; 9.369973e-03 ; 1.627138e-02 ];
Tc_error_6  = [ 4.239135e+00 ; 4.725891e+00 ; 9.209123e+00 ];

%-- Image #7:
omc_7 = [ -2.140714e+00 ; -2.207461e+00 ; 1.714694e-01 ];
Tc_7  = [ -4.761225e+01 ; -7.376681e+01 ; 1.090154e+03 ];
omc_error_7 = [ 1.823740e-02 ; 1.970601e-02 ; 3.839629e-02 ];
Tc_error_7  = [ 8.223584e+00 ; 9.273298e+00 ; 1.419686e+01 ];

%-- Image #8:
omc_8 = [ -1.681375e+00 ; -1.950476e+00 ; 6.690912e-01 ];
Tc_8  = [ -3.018353e+01 ; 1.841218e+01 ; 7.364400e+02 ];
omc_error_8 = [ 7.767910e-03 ; 5.985161e-03 ; 9.556165e-03 ];
Tc_error_8  = [ 5.536822e+00 ; 6.292001e+00 ; 9.301198e+00 ];

%-- Image #9:
omc_9 = [ NaN ; NaN ; NaN ];
Tc_9  = [ NaN ; NaN ; NaN ];
omc_error_9 = [ NaN ; NaN ; NaN ];
Tc_error_9  = [ NaN ; NaN ; NaN ];

%-- Image #10:
omc_10 = [ -2.009876e+00 ; -2.337598e+00 ; 6.941648e-01 ];
Tc_10  = [ 7.118255e+02 ; -1.374571e+02 ; 1.608021e+03 ];
omc_error_10 = [ 1.326813e-02 ; 1.255387e-02 ; 2.522275e-02 ];
Tc_error_10  = [ 1.211513e+01 ; 1.410824e+01 ; 2.263143e+01 ];

%-- Image #11:
omc_11 = [ 1.921561e+00 ; 1.702147e+00 ; 1.921707e-01 ];
Tc_11  = [ -8.040676e+02 ; -1.405153e+02 ; 1.511367e+03 ];
omc_error_11 = [ 1.100248e-02 ; 1.693743e-02 ; 2.063196e-02 ];
Tc_error_11  = [ 1.060709e+01 ; 1.362089e+01 ; 2.775847e+01 ];

%-- Image #12:
omc_12 = [ -2.044171e+00 ; -2.208912e+00 ; 6.996213e-02 ];
Tc_12  = [ 2.644942e+02 ; 2.512587e+02 ; 2.054203e+03 ];
omc_error_12 = [ 1.559766e-02 ; 2.482458e-02 ; 4.232452e-02 ];
Tc_error_12  = [ 1.568334e+01 ; 1.762414e+01 ; 2.826149e+01 ];

%-- Image #13:
omc_13 = [ -1.890357e+00 ; -2.044852e+00 ; 2.452165e-01 ];
Tc_13  = [ 9.290893e+02 ; 2.728415e+02 ; 1.924704e+03 ];
omc_error_13 = [ 1.369979e-02 ; 2.937462e-02 ; 3.312055e-02 ];
Tc_error_13  = [ 1.305937e+01 ; 1.773892e+01 ; 2.738309e+01 ];

%-- Image #14:
omc_14 = [ 1.715605e+00 ; 1.910996e+00 ; -8.223296e-01 ];
Tc_14  = [ 1.549528e+02 ; 4.136058e+02 ; 1.838765e+03 ];
omc_error_14 = [ 1.058843e-02 ; 1.146793e-02 ; 1.783524e-02 ];
Tc_error_14  = [ 1.403944e+01 ; 1.586147e+01 ; 2.510904e+01 ];

