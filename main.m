
close all

%% Load images

Imf = loadImages(); % Imf is saved to a .mat file to be faster

%load('Imf') % load image matrix


%% Feature detection and extraction of SIFT points

%[frames, descs] = extractSIFT(Imf); % using vl_feat

[frames, descs] = loadHessaff(); % using preprocessed Hessian SIFT descriptors

%load('descs')
%load('frames')



%% Apply normalized 8-point RANSAC and find best matches

bestMatches = eightPointRANSAC(Imf,frames,descs);

%% Chaining



%% Stitching


%% Apply bundle adjustment


%% Eliminate Affine ambiguity


%% 3D model plotting



