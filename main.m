run('D:\TU Delft no sync\SIFT\vlfeat-0.9.21/toolbox/vl_setup')


%% Load images

%Imf = loadImages(); % Imf is saved to a .mat file to be faster

load('Imf') % load image matrix


%% Feature detection and extraction of SIFT points


%% Apply normalized 8-point RANSAC and find best matches


%% Chaining



%% Stitching


%% Apply bundle adjustment


%% Eliminate Affine ambiguity


%% 3D model plotting



