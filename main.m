clear all
close all

%% Load images

%Imf = loadImages(); % downscaled images for faster processing

load('Imf') % load image matrix, with colors! 4-D matrix, (x,y,color,frame)


%% Feature detection and extraction of SIFT points

%[frames, descs] = extractSIFT(Imf); % using vl_feat

%[frames, descs] = loadHessaff(); % using Hessian deterctor + SIFT descriptors

load('descs')
load('frames')



%% Apply normalized 8-point RANSAC and find best matches

bestMatches = eightPointRANSAC(Imf,frames,descs);


%% Chaining
measurementMatrix = createMeasurementMatrix(bestMatches,frames,descs);


%% Stitching

[M,S] = estimate_3D_points(measurementMatrix,frames,Imf);


%% Apply bundle adjustment


%% Eliminate Affine ambiguity


%% 3D model plotting



