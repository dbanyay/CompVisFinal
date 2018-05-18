
close all

%% Load images

%Imf = loadImages(); % downscaled images for faster processing

%load('Imf') % load image matrix


%% Feature detection and extraction of SIFT points

%[frames, descs] = extractSIFT(Imf); % using vl_feat

%[frames, descs] = loadHessaff(); % using Hessian deterctor + SIFT descriptors

%load('descs')
%load('frames')



%% Apply normalized 8-point RANSAC and find best matches

bestMatches = eightPointRANSAC(Imf,frames,descs);

%% Chaining



%% Stitching


%% Apply bundle adjustment


%% Eliminate Affine ambiguity


%% 3D model plotting



